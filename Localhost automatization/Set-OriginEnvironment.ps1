# Name: Set-OriginEnvironment
# author: Radek Zahradník (radek.zahradnik@msn.com)
# Date: 2020-12-28
# Version: 2.0
# Purpose: This script performs a configuration of
# local environment for running Origin services.
##########################################################################

#Requires -Version 7.0.3
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Module
)
####################################################
# Support functions (TOP to BOTTOM order)
# Further you would go, further details you would get.
####################################################
function Set-OriginLocalhostEnv
{
    param (
        [Parameter()]
        [OriginModule]
        $Module
    )
    Write-Message 'Starting a build of Origin environment...'
    Install-OriginPrerequisites
    Set-OriginPrerequisites
    switch ($Module)
    {
        ([OriginModule]::Portal)
        {
            Set-OriginLocalhostEnvForPortal
        }
        ([OriginModule]::Track)
        {
            Set-OriginLocalhostEnvForTrack
        }
        ([OriginModule]::OriginAPI)
        {
            Set-OriginLocalhostEnvForOriginAPI
        }
        ([OriginModule]::News)
        {
            Set-OriginLocalhostEnvForNews
        }
        ([OriginModule]::Compose)
        {
            Set-OriginLocalhostEnvForCompose
        }
        ([OriginModule]::Charts)
        {
            Set-OriginLocalhostEnvForCharts
        }
        ([OriginModule]::Order)
        {
            Set-OriginLocalhostEnvForOrder
        }
        ([OriginModule]::Typefaces)
        {
            Set-OriginLocalhostEnvForTypefaces
        }
        ([OriginModule]::Transport)
        {
            Set-OriginLocalhostEnvForTransport
        }
        ([OriginModule]::PreviewBox)
        {
            Set-OriginLocalhostEnvForPreviewBox
        }
        ([OriginModule]::RenderBox)
        {
            Set-OriginLocalhostEnvForRenderBox
        }
        ([OriginModule]::Quotes)
        {
            Set-OriginLocalhostEnvForQuotes
        }
        ([OriginModule]::Maps)
        {
            Set-OriginLocalhostEnvForMaps
        }
        Default
        {
            Write-Message 'Unknown Origin module'
        }
    }
}

function Install-OriginPrerequisites
{
    Get-OriginSourceCode
    Install-SQLExpress
    Install-MicrosoftReportViewer2010RedistributablePackage
    Install-MicrosoftSQLServerManagementStudio
    # SOLR (???)
    Enable-ASPTooling
    Restart-OriginHost -IfRequired
}

function Set-OriginPrerequisites
{
    Set-AzureNuGetFeed
    Set-RemoteDebugger
    Set-OriginNetworkCredential
}

function Set-OriginLocalhostEnvForPortal
{
    Write-Message 'Running specific setup for Portal...'
    Install-URLRewriteExtension
    Install-ApplicationRequestRoutingExtension
    Install-Nodejs
    Install-Vuejs
    Set-OriginUser
    Set-IISARRServerProxy
    Set-OriginAppPool
    Set-OriginWebsite
    Set-OriginWebAppForPortal
    Set-OriginRootWebConfig
    Set-PortalHomePageFolder
    Publish-PortalModule
    Set-OriginPortalkWebconfigToLocalhost
    Write-Message 'Setup for Portal is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForTrack
{
    Write-Message 'Running specific setup for Track...'
    Set-OriginWebAppForTrack
    Set-TrackCacheFolder
    Set-TrackVueJSComponent
    Publish-TrackModule
    Set-OriginTrackWebconfigToLocalhost
    Write-Message 'Setup for Track is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForOriginAPI
{
    Write-Message 'Running specific setup for Origin API...'
    Set-OriginWebAppForOriginAPI
    Publish-OriginAPIModule
    Set-OriginAPIWebconfigToLocalhost
    Write-Message 'Setup for Origin API is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForNews
{
    Write-Message 'Running specific setup for News...'
    Set-OriginWebAppForNews
    Publish-OriginNewsModule
    Set-OriginNewsWebconfigToLocalhost
    Write-Message 'Setup for News is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForCompose
{
    Write-Message 'Running specific setup for Compose...'
    Set-OriginWebAppForCompose
    Publish-OriginComposeModule
    Set-OriginComposeWebconfigToLocalhost
    Write-Message 'Setup for Compose is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForCharts
{
    Write-Message 'Running specific setup for Charts...'
    Set-OriginWebAppForCharts
    Publish-OriginChartsModule
    Set-OriginChartsWebconfigToLocalhost
    Set-ChartsVueJSComponent
    Write-Message 'Setup for Charts is completed. You may now close the console host window.'

}

function Set-OriginLocalhostEnvForOrder
{
    Write-Message 'Running specific setup for Order...'
    Set-OriginWebAppForOrder
    Publish-OriginOrderModule
    Set-OriginOrderWebconfigToLocalhost
    Set-OrderMediaFormatImage
    Write-Message 'Setup for Order is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForTypefaces
{
    Write-Message 'Running specific setup for Typefaces...'
    Set-OriginWebAppForTypefaces
    Publish-OriginTypefacesModule
    Set-OriginTypefacesWebconfigToLocalhost
    Write-Message 'Setup for Typefaces is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForTransport
{
    Write-Message 'Running specific setup for Transport...'
    Set-OriginWebAppForTransport
    Publish-OriginTransportModule
    Set-OriginTransportWebconfigToLocalhost
    Write-Message 'Setup for Transport is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForPreviewBox
{
    Write-Message 'Running specific setup for PreviewBox...'
    Set-OriginWebAppForPreviewBox
    Publish-OriginPreviewBoxModule
    Set-OriginPreviewBoxWebconfigToLocalhost
    Write-Message 'Setup for PreviewBox is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForRenderBox
{
    Write-Message 'Running specific setup for RenderBox...'
    Set-OriginWebAppForRenderBox
    Publish-OriginRenderBoxModule
    Set-OriginRenderBoxWebconfigToLocalhost
    Write-Message 'Setup for RenderBox is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForQuotes
{
    Write-Message 'Running specific setup for Quotes...'
    Set-OriginWebAppForQuotes
    Publish-OriginQuotesModule
    Set-OriginQuotesWebconfigToLocalhost
    Write-Message 'Setup for Quotes is completed. You may now close the console host window.'
}

function Set-OriginLocalhostEnvForMaps
{
    Write-Message 'Running specific setup for Maps...'
    Set-OriginWebAppForMaps
    Publish-OriginMapsModule
    Set-OriginMapsWebconfigToLocalhost
    Copy-CMDToolsFromNetwork
    Set-URLRewriteRuleForMaps
    Set-OriginLocalDirectoriesForMaps
    Build-OriginMapsConsoleApp
    Start-OriginMapsConsoleApp
    Write-Message 'Setup for Maps is completed. You may now close the console host window.'
}

function Set-AzureDevOpsCredentials
{
    Write-Message 'Setting up credentials for Azure DevOps...'
    if ([string]::IsNullOrWhiteSpace($configuration.AzureDevOpsUser.Password))
    {
        [Console]::Beep(1000, 1000)
        [securestring] $configuration.AzureDevOpsUser.Password = Read-Host -Prompt "Enter password for $($configuration.AzureDevOpsUser.Name)" -AsSecureString
    }
    else
    {
        [securestring] $configuration.AzureDevOpsUser.Password = ConvertTo-SecureString -String $configuration.AzureDevOpsUser.Password -AsPlainText -Force
    }

    Install-Module -Name CredentialManager -Force
    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
            [ValidateNotNullOrEmpty()]
            [string]
            $Name,
            [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
            [ValidateNotNullOrEmpty()]
            [SecureString]
            $Password
        )

        Import-Module CredentialManager
        $params = @{
            Target       = 'git:https://dev.azure.com/chyronhego'
            UserName     = $Name
            SecureString = $Password
            Persist      = 'LocalMachine'
            Type         = 'Generic'
        }
        New-StoredCredential @params
    }
    powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $configuration.AzureDevOpsUser.Name, $configuration.AzureDevOpsUser.Password
}

function Get-OriginSourceCode
{
    Write-Message 'Downloading Origin source code...'
    Remove-EmptyRepositoryFolder
    # Workaround to bypass IE Enhanced Security Configuration
    # On Windows Server, git prompts for credential in IE window which doesn't work because IE ESC.
    if (Test-WindowsEdition -WindowsServer)
    {
        Write-Verbose -Message 'Stopping Explorer in order to disable IE ESC...'
        $AdminKey = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}'
        $UserKey = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}'
        Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
        Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
        Stop-Process -Name explorer
    }
    $pathToDownloadScript = Join-Path -Path $PSScriptRoot -ChildPath Get-RepositoryFromAzureDevOps.ps1
    Invoke-Expression "& `"$pathToDownloadScript`" `"$([System.Environment]::ExpandEnvironmentVariables($configuration.SourceCodeLocalPath))`""
    Update-OriginRepositoryToLatest
    if (Test-WindowsEdition -WindowsServer)
    {
        Write-Verbose -Message 'Restarting Explorer in order to enable IE ESC...'
        Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 1
        Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 1
        Stop-Process -Name explorer
        Start-Sleep -Seconds 3
        [System.IO.FileInfo]$script = $PSCommandPath
        Invoke-Item -Path $script.Directory.FullName
        Start-Sleep -Seconds 3
        $wshell = New-Object -ComObject wscript.shell
        [void]$wshell.AppActivate($Host.UI.RawUI.WindowTitle)
        [void]$wshell.AppActivate($Host.UI.RawUI.WindowTitle)
    }
}

function Install-SQLExpress
{
    if ($configuration.Localhost)
    {
        Write-Verbose -Message 'Installing SQL Server Express due to configuration is set to localhost...'
        choco upgrade sql-server-express -y
    }
}

function Install-MicrosoftReportViewer2010RedistributablePackage
{
    choco upgrade reportviewer2010sp1 -y
}

function Install-MicrosoftSQLServerManagementStudio
{
    if ($configuration.Localhost)
    {
        Write-Verbose -Message 'Installing SQL Server Management Studio due to configuration is set to localhost...'
        choco upgrade sql-server-management-studio -y
    }
}

function Enable-ASPTooling
{
    Write-Message 'Enabling required Windows modules...'
    if (Test-WindowsEdition -Windows10)
    {
        Enable-Windows10Feature -FeatureName 'IIS-Metabase'
        Enable-Windows10Feature -FeatureName 'IIS-ManagementConsole'
        Enable-Windows10Feature -FeatureName 'IIS-ApplicationDevelopment'
        Enable-Windows10Feature -FeatureName 'IIS-ApplicationInit'
        Enable-Windows10Feature -FeatureName 'IIS-ASP'
        Enable-Windows10Feature -FeatureName 'IIS-ASPNET'
        Enable-Windows10Feature -FeatureName 'IIS-ASPNET45'
        Enable-Windows10Feature -FeatureName 'IIS-CGI'
        Enable-Windows10Feature -FeatureName 'IIS-ISAPIExtensions'
        Enable-Windows10Feature -FeatureName 'IIS-ISAPIFilter'
        Enable-Windows10Feature -FeatureName 'IIS-NetFxExtensibility'
        Enable-Windows10Feature -FeatureName 'IIS-NetFxExtensibility45'
        Enable-Windows10Feature -FeatureName 'IIS-ServerSideIncludes'
        Enable-Windows10Feature -FeatureName 'IIS-WebSockets'
        Enable-Windows10Feature -FeatureName 'MSMQ-Container'
        Enable-Windows10Feature -FeatureName 'MSMQ-Server'
        Enable-Windows10Feature -FeatureName 'NetFx4Extended-ASPNET45'
        Enable-Windows10Feature -FeatureName 'WAS-WindowsActivationService'
        Enable-Windows10Feature -FeatureName 'WAS-ConfigurationAPI'
        Enable-Windows10Feature -FeatureName 'WAS-NetFxEnvironment'
        Enable-Windows10Feature -FeatureName 'WAS-ProcessModel'
        Enable-Windows10Feature -FeatureName 'WCF-HTTP-Activation'
        Enable-Windows10Feature -FeatureName 'WCF-HTTP-Activation45'
        Enable-Windows10Feature -FeatureName 'WCF-MSMQ-Activation45'
        Enable-Windows10Feature -FeatureName 'WCF-Pipe-Activation45'
        Enable-Windows10Feature -FeatureName 'WCF-Services45'
        Enable-Windows10Feature -FeatureName 'WCF-TCP-Activation45'
        Enable-Windows10Feature -FeatureName 'WCF-TCP-PortSharing45'

    }
    if (Test-WindowsEdition -WindowsServer)
    {
        # The following list was made only based on previous version of Dev environment
        # and most likely consist more features than necessary.
        Enable-WindowsServerFeature -FeatureName 'File-Services'
        Enable-WindowsServerFeature -FeatureName 'FS-FileServer'
        Enable-WindowsServerFeature -FeatureName 'Web-WebServer'
        Enable-WindowsServerFeature -FeatureName 'Web-Common-Http'
        Enable-WindowsServerFeature -FeatureName 'Web-Static-Content'
        Enable-WindowsServerFeature -FeatureName 'Web-Default-Doc'
        Enable-WindowsServerFeature -FeatureName 'Web-Dir-Browsing'
        Enable-WindowsServerFeature -FeatureName 'Web-Http-Errors'
        Enable-WindowsServerFeature -FeatureName 'Web-App-Dev'
        Enable-WindowsServerFeature -FeatureName 'Web-Asp-Net'
        Enable-WindowsServerFeature -FeatureName 'Web-Net-Ext'
        Enable-WindowsServerFeature -FeatureName 'Web-ISAPI-Ext'
        Enable-WindowsServerFeature -FeatureName 'Web-ISAPI-Filter'
        Enable-WindowsServerFeature -FeatureName 'Web-Health'
        Enable-WindowsServerFeature -FeatureName 'Web-Http-Logging'
        Enable-WindowsServerFeature -FeatureName 'Web-Log-Libraries'
        Enable-WindowsServerFeature -FeatureName 'Web-Request-Monitor'
        Enable-WindowsServerFeature -FeatureName 'Web-Security'
        Enable-WindowsServerFeature -FeatureName 'Web-Filtering'
        Enable-WindowsServerFeature -FeatureName 'Web-Performance'
        Enable-WindowsServerFeature -FeatureName 'Web-Stat-Compression'
        Enable-WindowsServerFeature -FeatureName 'Web-Dyn-Compression'
        Enable-WindowsServerFeature -FeatureName 'Web-Mgmt-Tools'
        Enable-WindowsServerFeature -FeatureName 'Web-Mgmt-Console'
        Enable-WindowsServerFeature -FeatureName 'Web-Scripting-Tools'
        Enable-WindowsServerFeature -FeatureName 'Web-Mgmt-Service'
        Enable-WindowsServerFeature -FeatureName 'NET-Framework'
        Enable-WindowsServerFeature -FeatureName 'NET-Framework-Core'
        Enable-WindowsServerFeature -FeatureName 'NET-Win-CFAC'
        Enable-WindowsServerFeature -FeatureName 'NET-HTTP-Activation'
        Enable-WindowsServerFeature -FeatureName 'NET-Non-HTTP-Activ'
        Enable-WindowsServerFeature -FeatureName 'MSMQ'
        Enable-WindowsServerFeature -FeatureName 'MSMQ-Services'
        Enable-WindowsServerFeature -FeatureName 'MSMQ-Server'
        Enable-WindowsServerFeature -FeatureName 'RSAT'
        Enable-WindowsServerFeature -FeatureName 'RSAT-Role-Tools'
        Enable-WindowsServerFeature -FeatureName 'RSAT-Web-Server'
        Enable-WindowsServerFeature -FeatureName 'WAS'
        Enable-WindowsServerFeature -FeatureName 'WAS-Process-Model'
        Enable-WindowsServerFeature -FeatureName 'WAS-NET-Environment'
        Enable-WindowsServerFeature -FeatureName 'WAS-Config-APIs'

        # This list contains a features that are missing from list above
        # and were installed in dev machines used by Brno dev team.
        # It is highly possible that these feature are not required by Origin at all.
        Enable-WindowsServerFeature -FeatureName 'Web-Asp-Net45'
        Enable-WindowsServerFeature -FeatureName 'Web-Net-Ext45'
        Enable-WindowsServerFeature -FeatureName 'Web-WebSockets'
        Enable-WindowsServerFeature -FeatureName 'NET-Framework-45-ASPNET'
        Enable-WindowsServerFeature -FeatureName 'NET-WCF-HTTP-Activation45'
        Enable-WindowsServerFeature -FeatureName 'NET-WCF-MSMQ-Activation45'
        Enable-WindowsServerFeature -FeatureName 'NET-WCF-Pipe-Activation45'
        Enable-WindowsServerFeature -FeatureName 'NET-WCF-Services45'
        Enable-WindowsServerFeature -FeatureName 'NET-WCF-TCP-Activation45'
        Enable-WindowsServerFeature -FeatureName 'NET-WCF-TCP-PortSharing45'
    }
}

function Restart-OriginHost
{
    param (
        [switch]
        $IfRequired
    )
    # Workaround for pending reboot on Windows Server.
    # Possible TODO: Test pending reboot on Windows 10.
    # Windows Update time to time interferes with the configuration, specially when fresh Windows 10 installation is used.
    if (Test-WindowsEdition -WindowsServer)
    {
        $taskName = 'Finish Origin Config'
        if ($IfRequired -and (Test-PendingReboot))
        {
            $params = @{
                TaskName = $TaskName
                Action   = New-ScheduledTaskAction -Execute pwsh.exe -Argument "-NoLogo -NoProfile -NoExit -File `"$PSCommandPath`" -Module `"$Module`""
                Trigger  = New-ScheduledTaskTrigger -AtLogon
                Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -WakeToRun
                RunLevel = 'Highest'
            }
            Register-ScheduledTask @params
            Restart-Computer -Force
        }
        Unregister-ScheduledTask -TaskName $TaskName -ErrorAction:SilentlyContinue -Confirm:$false
    }
}

function Set-AzureNuGetFeed
{
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-artifacts-credprovider.ps1) }"
}

function Set-RemoteDebugger
{
    if ($configuration.Localhost -eq $false)
    {
        Write-Message 'Starting configure remote debugger due to configuration is set to localhost...'
        # No localhost, so we need to setup remote debugger as an service
        $latestDebuggerServiceVersion = Get-Service -DisplayName 'Visual*Studio*Remote*Debugger' |
        Sort-Object -Property Name |
        Select-Object -Last 1
        if ([void][object]::Equals($latestDebuggerServiceVersion, $null))
        {
            Write-Verbose -Message 'The remote debugger service hasn''t been configured yet.'
            [System.IO.FileInfo] $remoteDebuggerWizard = Get-ChildItem -Path $env:ProgramFiles, ${env:ProgramFiles(x86)} -Recurse -File -Filter rdbgwiz.exe | Select-Object -First 1
            Start-Process -FilePath $remoteDebuggerWizard.FullName
            Start-Sleep 2
            while ($true)
            {
                $windowTitle = Get-Process -Name 'pwsh' -ErrorAction:SilentlyContinue | Select-Object -ExpandProperty MainWindowTitle
                if ([string]::IsNullOrWhiteSpace($windowTitle))
                {
                    Write-Verbose -Message 'Waiting for rdbgwiz...'
                    Start-Sleep 1
                    continue
                }
                break
            }
            $wshell = New-Object -ComObject wscript.shell
            $wshell.AppActivate($windowTitle)
            Start-Sleep 1
            $wshell.SendKeys('~')
            Start-Sleep 1
            $wshell.SendKeys(' ')
            Start-Sleep 1
            $wshell.SendKeys('~')
            Start-Sleep 1
            $wshell.SendKeys('~')
            Start-Sleep 1
            $wshell.SendKeys('~')
        }
        if ($latestDebuggerServiceVersion.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Running)
        {
            Write-Verbose -Message 'The service is configured but not running. Starting...'
            Set-Service -Name $latestDebuggerServiceVersion.Name -StartupType:Automatic -PassThru |
            Start-Service
        }
    }
}

function Set-OriginNetworkCredential
{
    Write-Message 'Setting up network credentials used by Origin...'
    $configuration.NetworkHost | ForEach-Object {
        Write-Verbose "Storing network credentials for $($_.IP)"
        cmdkey /add:($_.IP) /user:($configuration.OriginUser.Name) /pass:($configuration.OriginUser.Password) | Write-Verbose
    }
}

function Install-URLRewriteExtension
{
    choco upgrade urlrewrite -y
}

function Install-ApplicationRequestRoutingExtension
{
    choco upgrade iis-arr -y
}

function Install-Nodejs
{
    choco upgrade nodejs -y
    Update-PathVariable
}

function Install-Vuejs
{
    if ($configuration.Localhost)
    {
        Write-Message 'Installing Vue.js via NPM'
        npm install -g @vue/cli
        # TODO: Check for installation skip.
        # TODO: Check if @vue/cli is everything what needs to be installed.
    }
}

function Set-OriginUser
{
    Write-Message 'Setting up a dedicated Origin user...'
    $password = ConvertTo-SecureString -String $configuration.OriginUser.Password -AsPlainText -Force
    Set-OriginLocalUser -Password $password -Name $configuration.OriginUser.Name -FullName $configuration.OriginUser.FullName -Group $configuration.OriginUser.Group
}

function Set-IISARRServerProxy
{
    Write-Message 'Setting up server proxy...'
    Add-Type -Path "$env:systemroot\system32\inetsrv\Microsoft.Web.Administration.dll" | Write-Verbose
    $manager = New-Object Microsoft.Web.Administration.ServerManager
    $sectionGroupConfig = $manager.GetApplicationHostConfiguration()

    $sectionName = 'proxy'

    $webserver = $sectionGroupConfig.RootSectionGroup.SectionGroups['system.webServer']
    if (!$webserver.Sections[$sectionName])
    {
        $proxySection = $webserver.Sections.Add($sectionName)
        $proxySection.OverrideModeDefault = "Deny"
        $proxySection.AllowDefinition = "AppHostOnly"
        $manager.CommitChanges()
    }

    $manager = New-Object Microsoft.Web.Administration.ServerManager
    $config = $manager.GetApplicationHostConfiguration()
    $section = $config.GetSection('system.webServer/' + $sectionName)
    $enabled = $section.GetAttributeValue('enabled')
    $section.SetAttributeValue('enabled', 'true')
    $manager.CommitChanges()

    Write-Message "ARR Server Proxy enabled."
}

function Set-OriginAppPool
{
    Write-Message 'Setting up a resource pool for Origin...'
    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject]
            $Configuration
        )

        Import-Module WebAdministration
        Remove-WebAppPool -Name $Configuration.AppPool.Name -Confirm:$false -ErrorAction:SilentlyContinue
        New-WebAppPool -Name $Configuration.AppPool.Name -Force | Write-Verbose

        $params = @{
            Path  = "IIS:\AppPools\$($Configuration.AppPool.Name)"
            Name  = 'processModel'
            Value = @{
                userName     = $Configuration.OriginUser.Name
                password     = $Configuration.OriginUser.Password
                identitytype = 'SpecificUser'
            }
        }
        Set-ItemProperty @params
    }
    # Workaround for STDOUT/STDIN problem of PS
    # The whole configuration can't be pushed into a new PS instance due to problems with STDOUT/STDIN cache.
    # The issue is tracked here: https://github.com/PowerShell/PowerShell/issues/14775
    powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args @{AppPool = $configuration.AppPool; OriginUser = $configuration.OriginUser }
}

function Set-OriginWebsite
{
    Write-Message 'Setting up website(s) for Origin...'
    Import-Module WebAdministration -WarningAction:SilentlyContinue
    Test-OriginWebsiteIdConfig
    # Get-Website throws an error 0x8007000d in configuration time.
    # So far, it looks like an error which doesn't produce any real impact.
    # https://stackoverflow.com/questions/16836473/asp-net-http-error-500-19-internal-server-error-0x8007000d
    # https://stackoverflow.com/questions/13532447/http-error-500-19-iis-7-5-error-0x8007000d
    $configuration.Website | Foreach-Object {
        $websiteToRemove = $_
        Get-Website -Name $websiteToRemove.Name -ErrorAction:SilentlyContinue |
        Where-Object { $_.Id -eq $websiteToRemove.Id -or $_.Name -eq $websiteToRemove.Name } |
        Remove-Website -Confirm:$false -ErrorAction:SilentlyContinue
    }
    New-OriginWebsite
    Set-OriginWebsiteHttpsBinding
    Set-OriginWebsiteAdditionalBinding
}

function Set-OriginWebAppForPortal
{
    Write-Message 'Setting up a WebApps for Portal...'
    Set-OriginWebApp -Module $configuration.WebApp.Portal
}

function Set-OriginPortalkWebconfigToLocalhost
{
    Write-Message 'Updating Portal Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Portal
}

function Set-OriginRootWebConfig
{
    Write-Message 'Setting Origin root web.config file...'
    $params = @{
        Path        = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Portal.FilePathToConfig)
        Destination = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Portal.TargetAbsolutePathToConfig)
    }
    Copy-Item @params
    Set-PortalWebConfigFix
}

function Set-PortalHomePageFolder
{
    Write-Message 'Setting up HomePageFiles...'
    $params = @{
        Site         = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId | Select-Object -ExpandProperty Name
        Application  = $configuration.WebApp.Portal.HomePageFiles.TargetWebApplication
        Name         = $configuration.WebApp.Portal.HomePageFiles.Name
        PhysicalPath = $configuration.WebApp.Portal.HomePageFiles.PhysicalPath
        Force        = $true
    }

    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject]
            $Params
        )
        New-WebVirtualDirectory @params | Write-Verbose
        Set-WebConfigurationProperty /system.webServer/security/authentication/anonymousAuthentication -name userName -value ""
    }
    powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $params
}

function Publish-PortalModule
{
    Write-Message 'Publishing Portal module...'
    Publish-OriginModule -Module $configuration.WebApp.Portal
}

function Set-OriginWebAppForTrack
{
    Write-Message 'Setting up a WebApps for Track...'
    Set-OriginWebApp -Module $configuration.WebApp.Track
}

function Set-TrackCacheFolder
{
    Write-Message 'Setting up a cache folder for Track...'
    Import-Module WebAdministration -WarningAction:SilentlyContinue
    $localFolderPath = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Track.Cache.LocalFolderPath)
    New-Item -Path $localFolderPath -ItemType:Directory -Force | Write-Verbose

    $params = @{
        Site         = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId | Select-Object -ExpandProperty Name
        Name         = $configuration.WebApp.Track.Cache.Name
        PhysicalPath = $configuration.WebApp.Track.Cache.PhysicalPath
        Force        = $true
    }

    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject]
            $Params
        )
        New-WebVirtualDirectory @params | Write-Verbose
    }
    powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $params
}

function Set-TrackVueJSComponent
{
    Write-Message 'Setting up the Track Vue.js component...'
    [System.Management.Automation.PathInfo] $originalPath = $PWD
    $vueJSComponentBuildPath = Resolve-OriginRelativePathToAbsolute -RelativePath $configuration.WebApp.Track.VueJS.RelativeSourcePath
    Set-Location -Path $vueJSComponentBuildPath
    npm clean-install
    npm run build
    $params = @{
        Path        = Resolve-OriginRelativePathToAbsolute -RelativePath $configuration.WebApp.Track.VueJS.RelativeBuildPath
        Destination = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Track.VueJS.Destination)
        Recurse     = $True
        Confirm     = $false
        Force       = $True
    }
    New-Item -Path $params.Destination -ItemType:Directory -Force | Write-Verbose
    Copy-Item @params
    Set-Location -Path $originalPath.Path
}

function Publish-TrackModule
{
    Write-Message 'Publishing Track module...'
    Publish-OriginModule -Module $configuration.WebApp.Track
}

function Set-OriginTrackWebconfigToLocalhost
{
    Write-Message 'Updating Track Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Track
}

function Set-OriginWebAppForOriginAPI
{
    Write-Message 'Setting up a WebApps for OriginAPI...'
    Set-OriginWebApp -Module $configuration.WebApp.OriginAPI
}

function Publish-OriginAPIModule
{
    Write-Message 'Publishing OriginAPI module...'
    Publish-OriginModule -Module $configuration.WebApp.OriginAPI
}

function Set-OriginAPIWebconfigToLocalhost
{
    Write-Message 'Updating Origin API Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.OriginAPI
}

function Set-OriginWebAppForNews
{
    Write-Message 'Setting up a WebApps for News...'
    Set-OriginWebApp -Module $configuration.WebApp.News
}

function Publish-OriginNewsModule
{
    Write-Message 'Publishing News module...'
    Publish-OriginModule -Module $configuration.WebApp.News
}

function Set-OriginNewsWebconfigToLocalhost
{
    Write-Message 'Updating News Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.News
}

function Set-OriginWebAppForCompose
{
    Write-Message 'Setting up a WebApps for Compose...'
    Set-OriginWebApp -Module $configuration.WebApp.Compose
}

function Publish-OriginComposeModule
{
    Write-Message 'Publishing Compose module...'
    Publish-OriginModule -Module $configuration.WebApp.Compose
}

function Set-OriginComposeWebconfigToLocalhost
{
    Write-Message 'Updating Compose Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Compose
}

function Set-OriginWebAppForCharts
{
    Write-Message 'Setting up a WebApps for Charts...'
    Set-OriginWebApp -Module $configuration.WebApp.Charts
}

function Publish-OriginChartsModule
{
    Write-Message 'Publishing Charts module...'
    Publish-OriginModule -Module $configuration.WebApp.Charts
}

function Set-OriginChartsWebconfigToLocalhost
{
    Write-Message 'Updating Charts Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Charts
}

function Set-ChartsVueJSComponent
{
    Write-Message 'Setting up the Charts Vue.js component...'
    [System.Management.Automation.PathInfo] $originalPath = $PWD
    $vueJSComponentBuildPath = Resolve-OriginRelativePathToAbsolute -RelativePath $configuration.WebApp.Charts.VueJS.RelativeSourcePath
    Set-Location -Path $vueJSComponentBuildPath
    npm clean-install
    npm run build
    $params = @{
        Path        = Resolve-OriginRelativePathToAbsolute -RelativePath $configuration.WebApp.Charts.VueJS.RelativeBuildPath
        Destination = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Charts.VueJS.Destination)
        Recurse     = $True
        Confirm     = $false
        Force       = $True
    }
    New-Item -Path $params.Destination -ItemType:Directory -Force | Write-Verbose
    Copy-Item @params
    Set-Location -Path $originalPath.Path
}

function Set-OriginWebAppForOrder
{
    Write-Message 'Setting up a WebApps for Order...'
    Set-OriginWebApp -Module $configuration.WebApp.Order
}

function Publish-OriginOrderModule
{
    Write-Message 'Publishing Order module...'
    Publish-OriginModule -Module $configuration.WebApp.Order
}

function Set-OriginOrderWebconfigToLocalhost
{
    Write-Message 'Updating Order Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Order
}

function Set-OrderMediaFormatImage
{
    Write-Message 'Setting up the MediaFormatImage directory for Order...'
    Import-Module WebAdministration -WarningAction:SilentlyContinue
    $localFolderPath = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Order.MediaFormatImages.LocalFolderPath)
    New-Item -Path $localFolderPath -ItemType:Directory -Force | Write-Verbose

    $params = @{
        Site         = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId | Select-Object -ExpandProperty Name
        Name         = $configuration.WebApp.Order.MediaFormatImages.Name
        PhysicalPath = $configuration.WebApp.Order.MediaFormatImages.PhysicalPath
        Force        = $true
    }

    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject]
            $Params
        )
        New-WebVirtualDirectory @params | Write-Verbose
    }
    powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $params
}

function Set-OriginWebAppForTypefaces
{
    Write-Message 'Setting up a WebApps for Typefaces...'
    Set-OriginWebApp -Module $configuration.WebApp.Typefaces
}

function Publish-OriginTypefacesModule
{
    Write-Message 'Publishing Typefaces module...'
    Publish-OriginModule -Module $configuration.WebApp.Typefaces
}

function Set-OriginTypefacesWebconfigToLocalhost
{
    Write-Message 'Updating Typefaces Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Typefaces
}

function Set-OriginWebAppForTransport
{
    Write-Message 'Setting up a WebApps for Transport...'
    Set-OriginWebApp -Module $configuration.WebApp.Transport
}

function Publish-OriginTransportModule
{
    Write-Message 'Publishing Transport module...'
    Publish-OriginModule -Module $configuration.WebApp.Transport
}

function Set-OriginTransportWebconfigToLocalhost
{
    Write-Message 'Updating Transport Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Transport
}

function Set-OriginWebAppForPreviewBox
{
    Write-Message 'Setting up a WebApps for PreviewBox...'
    Set-OriginWebApp -Module $configuration.WebApp.PreviewBox
}

function Publish-OriginPreviewBoxModule
{
    Write-Message 'Publishing PreviewBox module...'
    Publish-OriginModule -Module $configuration.WebApp.PreviewBox
}

function Set-OriginPreviewBoxWebconfigToLocalhost
{
    Write-Message 'Updating PreviewBox Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.PreviewBox
}

function Set-OriginWebAppForRenderBox
{
    Write-Message 'Setting up a WebApps for RenderBox...'
    Set-OriginWebApp -Module $configuration.WebApp.RenderBox
}

function Publish-OriginRenderBoxModule
{
    Write-Message 'Publishing RenderBox module...'
    Publish-OriginModule -Module $configuration.WebApp.RenderBox
}

function Set-OriginRenderBoxWebconfigToLocalhost
{
    Write-Message 'Updating RenderBox Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.RenderBox
}

function Set-OriginWebAppForQuotes
{
    Write-Message 'Setting up a WebApps for Quotes...'
    Set-OriginWebApp -Module $configuration.WebApp.Quotes
}

function Publish-OriginQuotesModule
{
    Write-Message 'Publishing Quotes module...'
    Publish-OriginModule -Module $configuration.WebApp.Quotes
}

function Set-OriginQuotesWebconfigToLocalhost
{
    Write-Message 'Updating Quotes Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Quotes
}

function Set-OriginWebAppForMaps
{
    Write-Message 'Setting up a WebApps for Maps...'
    Set-OriginWebApp -Module $configuration.WebApp.Maps
}

function Copy-CMDToolsFromNetwork
{
    Write-Message 'Coping network tools for Maps...'
    $configuration.WebApp.Maps.CMDTools | ForEach-Object {
        $params = @{
            Path        = $_.Source
            Destination = [System.Environment]::ExpandEnvironmentVariables($_.Destination)
            Recurse     = $True
            Confirm     = $false
            Force       = $True
        }
        New-Item -Path $_.Destination -ItemType:Directory -Force | Write-Verbose
        Copy-Item @params
    }
}

function Set-URLRewriteRuleForMaps
{
    Write-Message 'Setting up URL rewrite tool for Maps...'
    $frontendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId
    $URLRewriteSetup = $configuration.WebApp.Maps.URLRewriteRule

    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject]
            $WebsiteName,
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject]
            $URLRewriteSetup
        )

        Import-Module WebAdministration
        $site = "iis:\sites\$($WebsiteName.Name)\$($URLRewriteSetup.TargetWebApp)"
        $filterRoot = "system.webServer/rewrite/rules/rule[@name='$($URLRewriteSetup.RuleName)']"
        Set-WebConfigurationProperty -PSPath $site -Filter 'system.webServer/rewrite/rules' -Name '.' -Value @{Name = $URLRewriteSetup.RuleName; patternSyntax = 'Regular Expressions'; stopProcessing = 'True' }
        Set-WebConfigurationProperty -PSPath $site -Filter "$filterRoot/match" -Name 'url' -Value '^_(\w)o(\d+)p(\d)$'
        Set-WebConfigurationProperty -PSPath $site -Filter "$filterRoot/conditions" -Name 'logicalGrouping' -Value 'MatchAny'
        Set-WebConfigurationProperty -PSPath $site -Filter "$filterRoot/action" -Name 'type' -Value 'Rewrite'
        Set-WebConfigurationProperty -PSPath $site -Filter "$filterRoot/action" -Name 'url' -Value "http://10.10.3.{R:2}:808{R:3}/{R:1}"
    }
    powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $frontendWebsite, $URLRewriteSetup
}

function Publish-OriginMapsModule
{
    Write-Message 'Publishing Maps module...'
    Publish-OriginModule -Module $configuration.WebApp.Maps
}

function Set-OriginMapsWebconfigToLocalhost
{
    Write-Message 'Updating Maps Web.config files to use localhost...'
    Set-OriginWebconfigToLocalhost -OriginModule $configuration.WebApp.Maps
}

function Set-OriginLocalDirectoriesForMaps
{
    Write-Message 'Creating local directories required by Maps...'
    $configuration.WebApp.Maps.LocalDirectory | ForEach-Object {
        New-Item -Path ([System.Environment]::ExpandEnvironmentVariables($_.Path)) -ItemType:Directory -Force | Write-Verbose
    }
    $configuration.WebApp.Maps.NetworkSymbolicLinks | ForEach-Object {
        New-Item -Path ([System.Environment]::ExpandEnvironmentVariables($_.TargetPath)) -ItemType:SymbolicLink -Value $_.SourcePath -Force | Write-Verbose
    }
    $params = @{
        Path     = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Maps.Static.TargetRelativePath)
        ItemType = 'SymbolicLink'
        Value    = Resolve-OriginRelativePathToAbsolute -RelativePath $configuration.WebApp.Maps.Static.SourcePath
        Force    = $true
    }
    New-Item @params | Write-Verbose
}

function Build-OriginMapsConsoleApp
{
    Write-Message 'Building MapsConsole application...'
    [System.IO.FileInfo] $mapsSolutionFile = Resolve-OriginRelativePathToAbsolute -RelativePath $configuration.WebApp.Maps.MapsConsole.RelativePathToSolution
    nuget restore "$($mapsSolutionFile.FullName)"
    [System.IO.FileInfo] $msbuildAbsolutePath = Get-MSBuildAbsolutePath
    $msbuildArgumentList = @(
        "`"$($mapsSolutionFile.FullName)`"",
        "/p:Configuration=Release-Dev",
        "/p:Platform=""Any CPU""",
        "/p:UseSharedCompilation=false",
        "/nodeReuse:false"
    )
    Start-Process -FilePath $msbuildAbsolutePath.FullName -ArgumentList $msbuildArgumentList -NoNewWindow -Wait
}

function Start-OriginMapsConsoleApp
{
    Write-Message 'Starting MapsConsole application...'
    [System.IO.FileInfo] $mapsConsoleAbsoultePath = Resolve-OriginRelativePathToAbsolute -RelativePath $configuration.WebApp.Maps.MapsConsole.BuildPath
    Start-Process -FilePath $mapsConsoleAbsoultePath.FullName -ArgumentList 'SVRRENDER' -NoNewWindow -Wait
}

function Remove-EmptyRepositoryFolder
{
    Get-ChildItem -Path ([System.Environment]::ExpandEnvironmentVariables($configuration.SourceCodeLocalPath)) -Directory -ErrorAction:SilentlyContinue |
    ForEach-Object {
        if ([object]::Equals((Get-ChildItem -Path $_.FullName), $null))
        {
            Write-Verbose "Dumping folder $($_.FullName) becase it is empty."
            Remove-Item $_.FullName -Force -Recurse -Confirm:$false
        }
    }
}

function Update-OriginRepositoryToLatest
{
    Get-ChildItem -Path ([System.Environment]::ExpandEnvironmentVariables($configuration.SourceCodeLocalPath)) -Directory -ErrorAction:SilentlyContinue |
    ForEach-Object {
        Set-Location -Path $_.FullName
        Start-OriginGitOperation -Scriptblock { git pull }
    }
    Set-Location -Path $PSScriptRoot
}

function Start-OriginGitOperation
{
    [CmdletBinding()]
    [Alias('sago')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [scriptblock]
        $Scriptblock
    )
    & $Scriptblock
}

function Enable-Windows10Feature
{
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $FeatureName
    )
    if (Test-WindowsEdition -Windows10)
    {
        if ((Get-WindowsOptionalFeature -FeatureName $FeatureName -Online).State -ne 'Enabled')
        {
            Enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -All | Write-Verbose
            $status = "The feature $FeatureName has been enabled."
        }
        Write-Message ($status ??= "The feature $FeatureName is already enabled.")
    }
}

function Enable-WindowsServerFeature
{
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $FeatureName
    )
    if (Test-WindowsEdition -WindowsServer)
    {
        if ((Get-WindowsFeature -Name $FeatureName).Installed -eq $false)
        {
            Install-WindowsFeature -Name $FeatureName
            $status = "The feature $FeatureName has been enabled."
        }
        Write-Message ($status ??= "The feature $FeatureName is already enabled.")
    }
}

function Set-OriginLocalUser
{
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $Password,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FullName,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Group
    )

    if ([object]::Equals((Get-LocalUser -Name $Name -ErrorAction:SilentlyContinue), $null))
    {
        New-LocalUser $Name -Password $Password -FullName $FullName -Description "An ORIGIN user created $([DateTime]::UtcNow.ToString('u'))."
    }
    else
    {
        Set-LocalUser $Name -Password $Password -FullName $FullName -Description "An ORIGIN user created $([DateTime]::UtcNow.ToString('u'))."
    }

    if ([object]::Equals((Get-LocalGroupMember -Group $Group -Member (Get-LocalUser -Name $Name).SID -ErrorAction:SilentlyContinue), $null))
    {
        Add-LocalGroupMember -Group $Group -Member $Name
    }
    if ([object]::Equals((Get-LocalGroupMember -Group 'IIS_IUSRS' -Member (Get-LocalUser -Name $Name).SID -ErrorAction:SilentlyContinue), $null))
    {
        Add-LocalGroupMember -Group 'IIS_IUSRS' -Member $Name
    }
}

function Test-OriginWebsiteIdConfig
{
    $frontendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId
    $backendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.BackendWebsiteId
    if ([object]::Equals($frontendWebsite, $null))
    {
        Write-Error "There is no website configuration with the frontend configuration Id $($configuration.FrontendWebsiteId) in the website array in the configuration JSON."
    }
    if ([object]::Equals($backendWebsite, $null))
    {
        Write-Error "There is no website configuration with the backend configuration Id $($configuration.BackendWebsiteId) in the website array in the configuration JSON."
    }
}

function New-OriginWebsite
{
    Import-Module WebAdministration -WarningAction:SilentlyContinue
    $configuration.Website | ForEach-Object {
        $Params = @{
            Name            = $_.Name
            Port            = $_.Port
            ApplicationPool = $configuration.AppPool.Name
            PhysicalPath    = $_.PhysicalPath
            Id              = $_.Id
            Force           = $true
        }
        New-Website @Params | Write-Verbose
    }
}

function Set-OriginWebsiteHttpsBinding
{
    Import-Module IISAdministration
    $frontendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId
    $storeLocation = 'Cert:\LocalMachine\My'
    $hostName = "localhost"
    $friendlyName = 'Origin'
    $existingCertificate = Get-ChildItem $storeLocation | Where-Object { $_.Subject -match "CN=$hostName" } | Select-Object -First 1
    $existingCertificate ??= New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation $storeLocation -FriendlyName $friendlyName
    $password = $frontendWebsite.SelfSignedCertificatePassword
    $port = "443"
    $thumbPrint = $existingCertificate.Thumbprint
    $bindingInformation = "*:" + $port + ":" + $hostName
    $certificatePath = ("cert:\localmachine\my\" + $existingCertificate.Thumbprint)
    $securedString = ConvertTo-SecureString -String $password -Force -AsPlainText
    $filePath = Join-Path -Path $env:TEMP -ChildPath 'temp.pfx'
    Export-PfxCertificate -FilePath $filePath -Cert $certificatePath -Password $securedString | Write-Verbose
    Import-PfxCertificate -FilePath $filePath -CertStoreLocation "Cert:\LocalMachine\Root" -Password $securedString | Write-Verbose

    $params = @{
        Name               = $frontendWebsite.Name
        BindingInformation = $bindingInformation
        Protocol           = 'https'
        Confirm            = $false
        WarningAction      = [System.Management.Automation.ActionPreference]::SilentlyContinue
    }
    Remove-IISSiteBinding @params

    $params = @{
        Name                  = $frontendWebsite.Name
        BindingInformation    = $bindingInformation
        CertificateThumbPrint = $thumbPrint
        CertStoreLocation     = $storeLocation
        Protocol              = 'https'
        Force                 = $true
    }
    New-IISSiteBinding @params
}

function Set-OriginWebsiteAdditionalBinding
{
    # Because https://stackoverflow.com/questions/9424362/why-powershells-new-webbinding-commandlet-creates-incorrect-hostheader
    # this must be done via Windows PowerShell.
    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]
            $WebsiteName,
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]
            $ProtocolName
        )

        Import-Module WebAdministration
        $params = @{
            Path  = "IIS:\Sites\$WebsiteName"
            Name  = 'Bindings'
            Value = @{
                protocol           = $ProtocolName
                bindingInformation = 'localhost'
            }
        }
        New-ItemProperty @params
    }

    $configuration.Website | Foreach-Object {
        powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $_.Name, 'net.msmq'
        powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $_.Name, 'net.formathome'
    }
}

function Set-OriginWebApp
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $Module
    )
    process
    {
        $frontendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId
        $Module.AppToCreateOnFrontendWebsite | ForEach-Object {
            $_ |
            Add-Member -MemberType:NoteProperty -Name 'Site' -Value $frontendWebsite.Name -PassThru |
            ForEach-Object { New-OriginWebApplication -WebApp $_ }
        }

        $backendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.BackendWebsiteId
        $Module.AppToCreateOnBackendWebsite | ForEach-Object {
            $_ |
            Add-Member -MemberType:NoteProperty -Name 'Site' -Value $backendWebsite.Name -PassThru |
            ForEach-Object { New-OriginWebApplication -WebApp $_ }
        }
    }
}

function New-OriginWebApplication
{
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $WebApp
    )

    Write-Message "Creating WebApp $($WebApp.Name)..."

    New-Item -Path ([System.Environment]::ExpandEnvironmentVariables($WebApp.PhysicalPath)) -ItemType:Directory -ErrorAction:SilentlyContinue | Write-Verbose
    $fullWebsiteParams = @{
        Name            = $WebApp.Name
        Site            = $WebApp.Site
        PhysicalPath    = $WebApp.PhysicalPath
        ApplicationPool = $configuration.AppPool.Name
        Force           = $true
    }

    $executeInWindowsPowerShellForCompatibilityReasons = {
        param (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [PSCustomObject]
            $Params
        )
        Import-Module WebAdministration
        New-WebApplication @params | Write-Verbose
    }
    powershell -NoLogo -NoProfile $executeInWindowsPowerShellForCompatibilityReasons -Args $fullWebsiteParams
}

function Set-OriginWebconfigToLocalhost
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [PsCustomObject]
        $OriginModule
    )

    begin
    {
        $frontendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.FrontendWebsiteId
        $localhostFrontendHostName = "http://localhost:$($frontendWebsite.Port)"
        $backendWebsite = $configuration.Website | Where-Object -Property Id -EQ $configuration.BackendWebsiteId
        $localhostBackendHostName = "http://localhost:$($backendWebsite.Port)"
    }

    process
    {
        $OriginModule.AppToCreateOnFrontendWebsite | ForEach-Object {
            [System.IO.DirectoryInfo] $pathToWebsiteDirectory = [System.Environment]::ExpandEnvironmentVariables($frontendWebsite.PhysicalPath)
            Get-WebConfig -Path $pathToWebsiteDirectory | Update-FileContent -OldString $configuration.BackendEndpointToSubstitude -NewString $localhostBackendHostName
        }

        $OriginModule.AppToCreateOnFrontendWebsite | ForEach-Object {
            [System.IO.DirectoryInfo] $pathToWebsiteDirectory = [System.Environment]::ExpandEnvironmentVariables($frontendWebsite.PhysicalPath)
            Get-WebConfig -Path $pathToWebsiteDirectory | Update-FileContent -OldString $configuration.FrontendEndpointToSubstitude -NewString $localhostFrontendHostName
        }

        $OriginModule.AppToCreateOnBackendWebsite | ForEach-Object {
            [System.IO.DirectoryInfo] $pathToWebsiteDirectory = [System.Environment]::ExpandEnvironmentVariables($backendWebsite.PhysicalPath)
            Get-WebConfig -Path $pathToWebsiteDirectory | Update-FileContent -OldString $configuration.BackendEndpointToSubstitude -NewString $localhostBackendHostName
        }

        $OriginModule.AppToCreateOnBackendWebsite | ForEach-Object {
            [System.IO.DirectoryInfo] $pathToWebsiteDirectory = [System.Environment]::ExpandEnvironmentVariables($backendWebsite.PhysicalPath)
            Get-WebConfig -Path $pathToWebsiteDirectory | Update-FileContent -OldString $configuration.FrontendEndpointToSubstitude -NewString $localhostFrontendHostName
        }
    }
}

function Set-PortalWebConfigFix
{
    [System.IO.FileInfo] $webconfigFile = [System.Environment]::ExpandEnvironmentVariables($configuration.WebApp.Portal.TargetAbsolutePathToConfig)
    $alreadyCommented = (Get-Content -Path $webconfigFile.FullName) -match '<!.*mimeMap fileExtension=".mp4" mimeType="video/mp4"' # This line causes failure in Dev and must commented in the final Webconfig.
    if ([object]::Equals($alreadyCommented, $null) -or $alreadyCommented.Length -eq 0)
    {
        (Get-Content -Path $webconfigFile.FullName -Raw) -replace '<.*mimeMap fileExtension=".mp4" mimeType="video/mp4".*/>', '<!-- <mimeMap fileExtension=".mp4" mimeType="video/mp4" /> -->' |
        Set-Content -Path $webconfigFile.FullName -Encoding:utf8BOM
    }
}

function Publish-OriginModule
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $Module
    )

    # Workaround for MS Build in CLI
    # https://github.com/dotnet/sdk/issues/15071
    # Fix https://stackoverflow.com/questions/52182158/vs-15-8-2-broke-build-tools-missing-runtimeidentifier
    # Workaround must be placed here because of PowerShell processing pipeline concurrency.
    # If this line is moved into the pipeline where the project are published,
    # some libraries could be missing during build.
    process
    {
        Remove-Item -Path (Get-OriginSourceCodeRootPath) -Include bin, obj -Force -Recurse

        $Module.ProjectsToPublish | ForEach-Object {
            [System.IO.FileInfo] $project = Resolve-OriginRelativePathToAbsolute -RelativePath $_.RelativeProjectPath
            [System.IO.FileInfo] $publishProfile = Resolve-OriginRelativePathToAbsolute -RelativePath $_.RelativePublishProfilePath
            Get-NuGetPackage -Project $project
            Publish-OriginProject -Project $project -PublishProfile $publishProfile
        }

        $Module.SymbolicLinkToCreate | ForEach-Object {
            [System.IO.FileInfo] $publishProfile = Resolve-OriginRelativePathToAbsolute -RelativePath $_.RelativePublishProfilePath
            [System.IO.DirectoryInfo] $sourcePath = [System.Environment]::ExpandEnvironmentVariables($_.SourcePath)
            Set-OriginSymbolicLink -PublishProfile $publishProfile -TargetRelativePath $_.TargetRelativePath -SourcePath $sourcePath | Write-Verbose
        }
    }
}

function Publish-OriginProject
{
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [System.IO.FileInfo]
        $Project,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [System.IO.FileInfo]
        $PublishProfile
    )

    process
    {
        [xml]$publishProfileXML = Get-Content -Path $publishProfile.FullName
        $publishUrl = $publishProfileXML.Project.PropertyGroup.PublishUrl

        # Create a target publish folder if not exists
        if (($publishUrl | Test-Path) -eq $false)
        {
            New-Item -Path $publishUrl -ItemType Directory -Force | Write-Verbose
        }

        # Get the latest installed MSBuild.exe path and
        [System.IO.FileInfo] $msbuildAbsolutePath = Get-MSBuildAbsolutePath
        $msbuildArgumentList = @(
            "`"$($Project.FullName)`"",
            "/p:DeployOnBuild=true",
            "/p:PublishProfile=`"$($PublishProfile.FullName)`"",
            "/p:Configuration=Release-Dev",
            "/p:Platform=AnyCPU",
            "/p:UseSharedCompilation=false",
            "/nodeReuse:false"
        )

        Start-Process -FilePath $msbuildAbsolutePath.FullName -ArgumentList $msbuildArgumentList -NoNewWindow -Wait
    }
}

function Set-OriginSymbolicLink
{
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [System.IO.FileInfo]
        $PublishProfile,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TargetRelativePath,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [System.IO.DirectoryInfo]
        $SourcePath
    )

    process
    {
        [xml]$publishProfileXML = Get-Content -Path $PublishProfile.FullName
        $publishPath = $publishProfileXML.Project.PropertyGroup.PublishUrl
        $targetAbsolutePath = Join-Path -Path $publishPath -ChildPath $TargetRelativePath
        if (($targetAbsolutePath | Test-Path) -eq $false)
        {
            Write-Verbose -Message "Creating a symbolic link $targetAbsolutePath to the source path $SourcePath"
            New-Item -Path $targetAbsolutePath -ItemType SymbolicLink -Value $SourcePath -Force | Write-Verbose
        }
    }
}

function Get-NuGetPackage
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_ | Test-Path })]
        [System.IO.FileInfo]
        $Project
    )

    # Workaround for dotnet restore fail.
    # By 01/2021 Origin used two types of CSPROJ format - the new and the old (obsolete) format.
    # dotnet restore or nuget restore on project with the old nuget format fails to restore all
    # necessary Origin NuGets.
    # Restoration of solution file where the project sits works fine.¨
    process
    {
        [System.IO.FileInfo[]]$matchingSlnFiles = Get-ChildItem -Path (Get-OriginSourceCodeRootPath) -Recurse -File -Filter '*.sln' |
        Where-Object { (Get-Content -Path $_.FullName -Raw) -match $Project.Name }
        $matchingSlnFiles | ForEach-Object {
            nuget restore "$($_.FullName)"
        }
    }
}

function Get-NuGetPackageForProject
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_ | Test-Path })]
        [System.IO.FileInfo]
        $SolutionFile
    )
    process
    {
        nuget restore "$($SolutionFile.FullName)"
    }
}

function Get-OriginEnvironmentConfiguration
{
    Write-Message "Reading configuration JSON..."
    $path = Join-Path -Path $PSScriptRoot -ChildPath 'configuration.json'
    $rawJSONString = Get-Content -Path $path -Raw
    $expandedJSON = $rawJSONString
    $rawJSONString | Get-EnvironmentVariableFromString | ForEach-Object {
        $expandedJSON = $expandedJSON -replace $_, (([System.Environment]::ExpandEnvironmentVariables($_) | ConvertTo-Json) -replace '\"', '') # %USERPROFILE% -> C:\\Users\\JohnDoe
    }
    return $expandedJSON | ConvertFrom-Json
}

function Update-PathVariable
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Test-RuntimePSVersion
{
    if ((Test-PSVersion $configuration.SupportedPSVersion) -eq $false)
    {
        try
        {
            choco upgrade powershell-core -y
        }
        catch [System.Management.Automation.CommandNotFoundException]
        {
            Write-Error 'Your localhost environment hasn''t been configured properly. Run Install-SystemTools.ps1'
        }
        finally
        {
            if ((Test-PSVersion $configuration.SupportedPSVersion) -eq $false)
            {
                Write-Error "The required PS version $($configuration.SupportedPSVersion) can't be obtained. Check the configuration JSON."
            }
        }
    }
}

function Test-PSVersion
{
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
    return ($testedVersion.Major -ge $PSVersionTable.PSVersion.Major) -and ($testedVersion.Minor -ge $PSVersionTable.PSVersion.Minor)
}

function Test-PendingReboot
{
    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore)
    {
        return $true
    }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore)
    {
        return $true
    }
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore)
    {
        return $true
    }
    return $false;
}

function Test-WindowsEdition
{
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Windows10')]
        [switch]
        $Windows10,
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Server')]
        [switch]
        $WindowsServer
    )

    process
    {
        if ($Windows10)
        {
            return (Get-CimInstance Win32_OperatingSystem).Caption -match 'Microsoft Windows 10'
        }
        if ($WindowsServer)
        {
            return (Get-CimInstance Win32_OperatingSystem).Caption -match 'Microsoft Windows Server'
        }
    }
}

function Resolve-OriginRelativePathToAbsolute
{
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RelativePath
    )
    process
    {
        $pathToOriginRoot = Get-OriginSourceCodeRootPath
        return Join-Path -Path $pathToOriginRoot -ChildPath $RelativePath
    }
}

function Resolve-HostFromUNC
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    process
    {
        if ($Path -match '(?<=^\\\\)[^\\]+')
        {
            $hostName = $Matches[0]
        }
        return $hostName ?? $env:COMPUTERNAME
    }
}

function Get-OriginSourceCodeRootPath
{
    return [System.Environment]::ExpandEnvironmentVariables($configuration.SourceCodeLocalPath)
}

function Get-Webconfig
{
    [OutputType([System.IO.FileInfo[]])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('ProjectPath')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [System.IO.DirectoryInfo]
        $Path
    )
    process
    {
        return Get-ChildItem -Path $Path -Recurse -File -Filter 'Web.config'
    }
}

function Get-MSBuildAbsolutePath
{
    [OutputType([System.IO.FileInfo])]

    $msbuildAbsolutePath = &"${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe
    if ([object]::Equals($msbuildAbsolutePath, $null))
    {
        $msbuildAbsolutePath = Get-ChildItem -Path ${env:ProgramFiles(x86)} -File -Recurse -Filter MSBuild.exe -ErrorAction:SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
    }
    return $msbuildAbsolutePath
}

function Get-EnvironmentVariableFromString
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $string
    )
    process
    {
        $matchesResults = $string | Select-String -Pattern '%(.*?)%' -AllMatches
        $uniqueEnvironmentalVariables = $matchesResults.Matches.Value | Select-Object -Unique
        return $uniqueEnvironmentalVariables
    }
}

function Update-FileContent
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [System.IO.FileInfo]
        $FilePath,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $OldString,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NewString
    )
    process
    {
        $content = [System.IO.File]::ReadAllText($FilePath.FullName).Replace($OldString, $NewString)
        [System.IO.File]::WriteAllText($FilePath.FullName, $content)
    }
}

function Write-Message
{
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )
    process
    {
        Write-Host -Object $Message
        $host.UI.RawUI.WindowTitle = $Message
    }
}

enum OriginModule
{
    Portal
    Track
    OriginAPI
    News
    Compose
    Charts
    Order
    Typefaces
    Transport
    PreviewBox
    RenderBox
    Quotes
    Maps
}
####################################################


# Elevate this script to admin privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process pwsh.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args`"" -Verb RunAs; exit }

# Read the configuration to the script scope
$configuration = Get-OriginEnvironmentConfiguration

Test-RuntimePSVersion
Set-OriginLocalhostEnv -Module $Module