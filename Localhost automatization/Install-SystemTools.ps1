# Name: Install-SystemTools
# author: Radek Zahradník (radek.zahradnik@msn.com)
# Date: 2020-12-29
# Version: 2.0
# Purpose: This script performs an installation of tools
# required by Origin project to run it locally or remotely.
##########################################################################


####################################################
# Support functions
####################################################
function Install-SystemPrerequisites
{
    Install-Chocolatey
    Install-PowerShell
    Install-Git
    Install-MicrosoftEdgeChromium
    Install-DotNetSDK
    Install-MicrosoftRedistributablePackage
    Install-BuildTools
    Install-NuGet
    Install-RemoteDebugger
    Install-VPNClient
    Set-CompanyVPN
    Set-CompanyVPNAutoStart
    Update-PathVariable
}

function Install-Chocolatey
{
    if (!(Test-Path "$($env:ProgramData)\chocolatey\choco.exe"))
    {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Write-Verbose
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Install-Module -Name Choco -Force
        Import-Module -Name Choco
        Install-Choco
        Uninstall-Module Choco
    }
}

function Install-PowerShell
{
    choco upgrade powershell-core -y --install-arguments='"ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 REGISTER_MANIFEST=1"'
    Update-PathVariable
    try
    {
        Start-Process pwsh.exe "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command `"Write-Host 'PowerShell has been installed.'`""
    }
    catch [System.InvalidOperationException]
    {
        Install-PowerShellFromWeb -Quiet:$false
    }
}

function Install-Git
{
    choco upgrade git -y
}

function Install-MicrosoftEdgeChromium
{
    choco upgrade microsoft-edge -y
}

function Install-DotNetSDK
{
    choco upgrade dotnet-sdk -y
}

function Install-MicrosoftRedistributablePackage
{
    choco upgrade  vcredist140 -y
}

function Install-BuildTools
{
    # TODO: Optimize workloads
    choco upgrade visualstudio2019buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.NetCoreBuildTools --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.WebBuildTools --add Microsoft.VisualStudio.Workload.DataBuildTools --includeRecommended --passive --locale en-US" -y
}

function Install-NuGet
{
    choco upgrade nuget.commandline -y
}

function Install-RemoteDebugger
{
    choco upgrade visualstudio-2019-remotetools -y
}

function Install-VPNClient
{
    # Workaround for silent installation fail in choco
    # See https://chocolatey.org/packages/openconnect-gui#discussion
    choco upgrade tapwindows -y --force
    $VerbosePreference = 'Continue'
    $latestClientDownloadUrl = Invoke-RestMethod -uri  https://api.github.com/repos/openconnect/openconnect-gui/releases/latest | Select-Object -ExpandProperty assets | Select-Object -expand browser_download_url | Where-Object { $_ -match '.exe$' }
    $fileName = $latestClientDownloadUrl.Split('/')[-1]
    [System.IO.FileInfo] $setupFilePath = Join-Path -Path $env:TEMP -ChildPath $fileName
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($latestClientDownloadUrl, $setupFilePath.FullName)
    Start-Process -FilePath $setupFilePath -ArgumentList '/S'

    # Another nasty workaround how to "easily" overcome the publisher check of Windows.
    # By default, OpenConnect-GUI installs the obsolete version of the TAP driver for Windows.
    # We need to skip this installation. The publisher check blocks the continuation of the script.
    Start-Sleep 1
    $wshell = New-Object -ComObject wscript.shell
    [UInt16] $counter = 0
    while ($counter -lt 100)
    {
        $windowTitle = Get-Process -Name 'rundll32' -ErrorAction:SilentlyContinue | Select-Object -ExpandProperty MainWindowTitle
        if ([string]::IsNullOrWhiteSpace($windowTitle))
        {
            "Attempt $(($counter++)): Waiting for rundll32..." | Write-Verbose
            Start-Sleep 1
            continue
        }
        "Activating $windowTitle" | Write-Verbose
        Start-Sleep 2
        [void]$wshell.AppActivate($windowTitle)
        Start-Sleep 2
        $wshell.SendKeys('{ENTER}') # ~ = ENTER, by default it is on 'Not install' which is what we need.
        Start-Sleep 2
        $counter = 0
        while ($counter -lt 100)
        {
            $tapWindowsProcess = Get-Process -Name 'tap-windows' -ErrorAction:SilentlyContinue
            if ([string]::IsNullOrWhiteSpace($tapWindowsProcess))
            {
                'Waiting for TAP Windows...' | Write-Verbose
                Start-Sleep 1
                continue
            }
            $tapWindowsProcess | Stop-Process -Force
            break
        }
        break
    }
    $VerbosePreference = 'SilentlyContinue'
}

function Set-CompanyVPN
{
    # I use Radek.Zahradnik as user for testing 01/2021
    # Will be replaced by some dedicated user
    $literalPath = 'HKCU:\Software\OpenConnect-GUI Team\OpenConnect-GUI\server:Company VPN'
    New-Item $literalPath -Force -ErrorAction SilentlyContinue | Write-Verbose

    # We want to ensure the value override, so we use -Force switch.
    New-ItemProperty -LiteralPath $literalPath -Name 'server' -Value 'vpn.chyron.com' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'batch' -Value 'true' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'proxy' -Value 'false' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'disable-udp' -Value 'false' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'minimize-on-connect' -Value 'false' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'reconnect-timeout' -Value 60 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'dtls_attempt_period' -Value 16 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'username' -Value $configuration.VPNUserName -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'password' -Value '@ByteArray(xxxxAQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAj1oyhVoFA0+xjuqAC4To/AAAAAACAAAAAAAQZgAAAAEAACAAAAC2wkjjGS7P2Qs1IQvZA8k8X+p2V186MbUdLzzw0V2sMAAAAAAOgAAAAAIAACAAAAAWABPWTkVbo1xtDRbk3AL8o0xLKojwSwNCLqMuuB2zpSAAAACjqzZwLolsceK4SEZYXaEd0LZUgHrBnyFtLLDqhFK3akAAAABmZkEFGOTH5fiyh84rHQryiogAu7bJZEdLcKMG+DusvAAEfQxUrSaAGl5HvLcaTCS2xHfl60F8t0DRskT5RNAq)' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'groupname' -Value 'Company-Secure-VPN' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'ca-cert' -Value '@ByteArray()' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'client-cert' -Value '@ByteArray()' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'client-key' -Value '@ByteArray(xxxxAQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAj1oyhVoFA0+xjuqAC4To/AAAAAACAAAAAAAQZgAAAAEAACAAAAAu5ZkkeCj1nIgCYKoEMWXGL5cO6k9+s/FvTbZjHsk8hgAAAAAOgAAAAAIAACAAAAAZEtT8YCLKIfPUMDGn+kxb2Iiy7PK7qCpihUdF8lT4bhAAAABWxntIiIKaXgxsPhLOjnh4QAAAAEe/4T2McMAr40F+IZ/DMu1iMCZLa867kJwkiFwNu/xoC/YjgYHNEp1aYIH2Vl7CB6vY+vJyYEdjFrg5vRyLM+E=)' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'server-hash' -Value '@ByteArray(&ßU9L§fØ6Í¢À:à5É]6)' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'server-hash-algo' -Value 3 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'token-str' -Value '@ByteArray(xxxxAQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAj1oyhVoFA0+xjuqAC4To/AAAAAACAAAAAAAQZgAAAAEAACAAAAC7ORghEMHQRHiEyp7W6tcFESsPo3AdT0g2kYe9O6ot4wAAAAAOgAAAAAIAACAAAADI+4F8MptqReZEWXNCvTSYiIVYt9Ct40LulHblhZlarBAAAAA/WJDDNJRd9nTlxV/fQuBHQAAAACUawuvQPknNnnGybmq4647fWNWpLFBgM7W2cDT2ZhHl5zwFzaFOFPGJZmOJUkQrsIfBBO9fOjmer4SdTSA+LsE=)' -PropertyType String -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'token-type' -Value 3145829 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Write-Verbose
    New-ItemProperty -LiteralPath $literalPath -Name 'protocol-id' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Write-Verbose
}

function Set-CompanyVPNAutoStart
{
    $targetScriptFileName = 'Start-OriginVPN.ps1'
    [System.IO.FileInfo] $targetScript = Get-ChildItem -Path $PSScriptRoot -Recurse -File -Filter $targetScriptFileName
    $firstPartdestination = Join-Path -Path $Env:LOCALAPPDATA -ChildPath 'CompanyName'
    $destination = Join-Path -Path $firstPartdestination -ChildPath 'VPN auto start'
    New-Item -Path $destination -ItemType:Directory -Force | Write-Verbose
    Copy-Item -Path $targetScript.FullName -Destination $destination -Force
    $File = Join-Path -Path $destination -ChildPath $targetScriptFileName
    Register-ScheduledTask -TaskName 'Company VPN auto start' -Action (New-ScheduledTaskAction -Execute `"pwsh.exe`" -Argument "-NoLogo -NoProfile -File `"$File`"") -Trigger (New-ScheduledTaskTrigger -AtLogon) -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -WakeToRun) -RunLevel Highest -Force
}

function Update-PathVariable
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Set-DnsIpV6Servers
{
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell.exe "-ExecutionPolicy Bypass -Command Set-DnsIpV6Servers" -Verb RunAs; exit }

    Get-NetAdapter -Physical |
    Where-Object { $_.Name -notcontains 'hyper' -or $_.Description -notcontains 'hyper' } |
    Set-DnsClientServerAddress -ServerAddresses ("2606:4700:4700::1111", "2606:4700:4700::1001")
}

function Set-ExecutionPolicyRestriction
{
    try
    {
        Set-ExecutionPolicy -ExecutionPolicy:RemoteSigned -Scope:CurrentUser
    }
    catch [System.Security.SecurityException]
    {
        # Running process is bypassing the command result which leads to an error that can be ignored.
    }
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

function Install-PowerShellFromWeb
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Preview,
        [Parameter()]
        [switch]
        $Quiet
    )
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell.exe "-ExecutionPolicy Bypass -Command Set-DnsIpV6Servers" -Verb RunAs; exit }
    Write-Host "Installing PowerShell..."
    Set-DnsIpV6Servers
    $previewStatus = $null
    if ($Preview)
    {
        $previewStatus = '-Preview'
    }
    $quietStatus = $null
    if ($Quiet)
    {
        $quietStatus = '-Quiet'
    }
    try
    {
        if ($PSVersionTable.PSVersion.Major -lt 6)
        {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) }-UseMSI $quietStatus $previewStatus"
        }
        else
        {
            Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1 -SslProtocol:Tls12) } -UseMSI $quietStatus $previewStatus"
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

function Get-OriginEnvironmentConfiguration
{
    Write-Host "Reading configuration JSON..."
    return Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath 'configuration.json') | ConvertFrom-Json
}
####################################################

# Elevate this script to admin privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args`"" -Verb RunAs; exit }

# Read the configuration to the global scope
$configuration = Get-OriginEnvironmentConfiguration

Install-SystemPrerequisites
Set-ExecutionPolicyRestriction
Write-Host 'The system configuration for Origin has been completed.' -ForegroundColor:Green