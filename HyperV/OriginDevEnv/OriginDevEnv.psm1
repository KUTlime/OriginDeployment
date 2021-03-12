####################################################
# Private support functions
####################################################
Write-Host "Reading configuration JSON..."
$configurationFilePath = (Join-Path -Path $PSScriptRoot -ChildPath configuration.json)
$configuration = Get-Content -Path $configurationFilePath | ConvertFrom-Json

enum VMSwitchStrategy
{
    First
    Last
}

function Update-PathVariable
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Test-PSVersion
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Version = '7.0.3'
    )
    if ($PSVersionTable.PSEdition -eq 'Desktop')
    {
        $testedVersion = [System.Version]::new($Version)
    }
    else
    {
        $testedVersion = [System.Management.Automation.SemanticVersion]::new($Version)
    }
    return ($testedVersion.Major -eq $PSVersionTable.PSVersion.Major) -and ($testedVersion.Minor -eq $PSVersionTable.PSVersion.Minor)
}

function Set-DnsIpV6Servers
{
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Set-DnsIpV6Servers" -Verb RunAs; exit }

    Get-NetAdapter -Physical |
    Where-Object { $_.Name -notcontains 'hyper' -or $_.Description -notcontains 'hyper' } | ForEach-Object {
        Set-DnsClientServerAddress -ServerAddresses ("2606:4700:4700::1111", "2606:4700:4700::1001") -PassThru -InterfaceAlias $_.Name
    }
}

function Install-PowerShellCore
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Preview
    )
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Install-PowerShellCore" -Verb RunAs; exit }
    Write-Host "Installing PowerShell Core..."
    Set-DnsIpV6Servers
    $previewStatus = $null
    if ($Preview)
    {
        $previewStatus = '-Preview'
    }
    try
    {
        if ($PSVersionTable.PSVersion.Major -lt 6)
        {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) }-UseMSI -Quiet $previewStatus"
        }
        else
        {
            Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1 -SslProtocol:Tls12) } -UseMSI -Quiet $previewStatus"
        }
        Write-Host "PS Core has been installed."
    }
    catch
    {
        Write-Error -Message "PS Core installation failed. Error was $_`nError was in Line $($_.InvocationInfo.ScriptLineNumber)"
    }
    finally
    {
        Update-PathVariable
    }
}

# Maybe this solves the problem with Install-PowerShellCore
function Install-PowerShell
{
    Install-Module Choco -Force
    Import-Module Choco
    Install-Choco
    Update-PathVariable
    choco upgrade powershell-core -y
    Update-PathVariable
}

function Enable-HyperV
{
    Write-Host "Checking Hyper-V status"
    if ((Get-CimInstance Win32_OperatingSystem).Caption -match 'Microsoft Windows 10')
    {
        if ((Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ne 'Enabled')
        {
            Write-Host "Enabling Hyper-V in host..."
            Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
        }
    }
    if ((Get-CimInstance Win32_OperatingSystem).Caption -match 'Microsoft Windows Server')
    {
        if ((Get-WindowsFeature -Name Hyper-V).Installed -eq $false)
        {
            Write-Host "Enabling Hyper-V in host..."
            Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
        }
    }
}

function New-OriginVMSwitch
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Name
    )
    $originSwitch = Get-VMSwitch -Name $Name -ErrorAction:SilentlyContinue
    if ($originSwitch)
    {
        Write-Information "The VMSwitch $Name already exists."
        return $originSwitch
    }

    $interface = Get-NetAdapterInterface -SelectionStrategy $configuration.InterfaceSelectionStrategy
    $existingSwitch = Get-VMSwitch -SwitchType:External | Where-Object -Property NetAdapterInterfaceGuid -EQ $interface.InterfaceGuid
    if ($existingSwitch)
    {
        Write-Warning "The Hyper-V supervisor already has existing external VMSwitch $($existingSwitch.Name) bound to Ethernet interface $($interface.Name)."
        return $existingSwitch
    }
    Write-Host "Creating VMSwitch $Name"
    New-VMSwitch -Name $Name -NetAdapterName $interface.Name -AllowManagementOS $true
    return Get-VMSwitch -Name $Name
}

function Get-NetAdapterInterface
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [VMSwitchStrategy]
        $SelectionStrategy
    )
    switch ($VMSwitchStrategy)
    {
        [VMSwitchStrategy]::First
        {
            return (Get-NetAdapter -Physical | Sort-Object -Property InterfaceIndex | Select-Object -First 1)
        }
        [VMSwitchStrategy]::Last
        {
            return (Get-NetAdapter -Physical | Sort-Object -Property InterfaceIndex | Select-Object -Last 1)
        }
        Default
        {
            return (Get-NetAdapter -Physical | Sort-Object -Property InterfaceIndex | Select-Object -First 1)
        }
    }
}

function Test-IsoPath
{
    if ($configuration.PathToIso | Test-Path)
    {
        Write-Host "The target iso file $($configuration.PathToIso) already exists. Run Remove-OriginTargetIsoFile to remove this file."
    }
    else
    {
        # Download install ISO
        Write-Host "Start downloading target VHD file..."
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($configuration.UrlToIso, $configuration.PathToIso)
        Write-Host "Download completed."
    }
}

function Test-PSInstallation
{
    # Ensure PowerShell version
    if ((Test-PSVersion $configuration.SupportedPSVersion) -eq $false)
    {
        try
        {
            Start-Process pwsh.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Set-OriginDevEnv"; exit
        }
        catch [System.InvalidOperationException]
        {
            Install-PowerShellCore
            Start-Process pwsh.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Set-OriginDevEnv"; exit
        }
    }
}
####################################################


####################################################
# Public API
####################################################
function Set-OriginDevEnv
{
    # Elevate this script to admin privileges
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Set-OriginDevEnv" -Verb RunAs; exit }

    Test-PSInstallation

    Enable-HyperV

    Test-IsoPath

    #Create switch
    $VMSwitch = New-OriginVMSwitch -Name $configuration.SwitchName

    $configuration.VMs | ForEach-Object {
        # Create VM
        $params = @{
            Name               = $_.VMName
            MemoryStartupBytes = $_.MemoryStartupBytes
            Generation         = $_.Generation
            Switch             = $VMSwitch.Name
            Path               = $_.Path
            NewVHDPath         = $_.NewVHDPath
            NewVHDSizeBytes    = $_.NewVHDSizeBytes
            BootDevice         = $_.BootDevice
        }
        $timeStamp = [DateTime]::UtcNow.ToString('yyyy-MM-dd_HHmmss')
        if ($params.NewVHDPath | Test-Path)
        {
            [System.IO.FileInfo] $oldDisk = $params.NewVHDPath
            $newName = "$(Split-Path $params.NewVHDPath)\$($oldDisk.BaseName)_$($timeStamp)$($oldDisk.Extension)"
            Rename-Item -Path $params.NewVHDPath -NewName $newName -Force
            Get-VM |
            Get-VMHardDiskDrive |
            Where-Object -Property Path -EQ $params.NewVHDPath |
            ForEach-Object {
                Set-VMHardDiskDrive -VMName $_.VMName -Path $newName -ControllerType:SCSI
            }
        }
        Rename-VM -Name $_.VMName -NewName "$($_.VMName)_$timeStamp" -ErrorAction:SilentlyContinue
        New-VM @params

        if ($configuration.UseIso)
        {
            # Add DVD Drive to Virtual Machine
            Add-VMScsiController -VMName $_.VMName
            Add-VMDvdDrive -VMName $_.VMName -Path $configuration.PathToIso

            # Configure Virtual Machine to Boot from DVD
            Set-VMFirmware -VMName $_.VMName -FirstBootDevice (Get-VMDvdDrive -VMName $_.VMName)
        }
    }
}

function Remove-OriginDevEnv
{
    # Elevate this script to admin privileges
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Remove-OriginDevEnv" -Verb RunAs; exit }

    # Ensure PowerShell version
    if ((Test-PSVersion $configuration.SupportedPSVersion) -eq $false)
    {
        try
        {
            Start-Process pwsh.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Remove-OriginDevEnv"; exit
        }
        catch [System.InvalidOperationException]
        {
            Install-PowerShellCore
            Start-Process pwsh.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command Remove-OriginDevEnv"; exit
        }
    }

    #Remove switch
    Write-Host "Removing VM switch $($configuration.SwitchName)..."
    Get-VMSwitch -Name $configuration.SwitchName -ErrorAction:SilentlyContinue |
    Remove-VMSwitch -Force

    $configuration.VMs | ForEach-Object {
        # Remove VM
        $params = @{
            Name = $_.VMName + $configuration.RemovalPostfix
        }
        Write-Host "Removing VM machine $($params.Name)..."
        Stop-VM @params
        Get-VM @params | Select-Object VMId | Get-VHD | Remove-Item -Force
        Remove-VM @params -Force
    }
}

function Open-OriginDevEnvConfig
{
    Start-Process -FilePath $configurationFilePath
}

function Remove-OriginDevEnvTargetIsoFile
{
    if ($configuration.PathToIso | Test-Path)
    {
        Remove-Item -Path $configuration.PathToIso
    }
}
####################################################