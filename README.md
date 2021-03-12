# Origin Deployment

> This is a large, real-life example how to write a clean code in PowerShell. It is an automation deployment of very complicated product called Origin. I removed all private information and substituted them by random strings. The original Readme follows.

# Origin localhost environment configuration

> This document describes details about an environment configuration done by PowerShell (PS) and the order of installation steps necessary to run Origin modules locally.
> In addition, these configuration scripts can be used for configuring non-localhost environments (*e.g. remote test environment*). To achieve this, you have to set `Localenvironment` to `false`.
> Origin is consisted from various modules. These modules has to be configured separately in the given order.

## Supported modules

| Module | Web tier | App tier | Is tested? |
|-|-|-|-|
| Portal | ✔ | ✔ | ✔ |
| Track | ✔ | ✔ | ✔ |
| OriginAPI | ✔ | ❎ | ❌ (1) |
| News | ✔ | ✔ | ✔ |
| Compose | ✔ | ❎ | ✔ |
| Charts | ✔ | ❎ | ✔ |
| Order | ✔ | ❎ | ✔ |
| PreviewBox | ✔ | ✔ | ❓ (2) |
| RenderBox | ✔ | ✔ | ❓ (2) |
| Transport | ✔ | ❎ | ✔ |
| Typefaces | ✔ | ❎ | ✔ |
| Quotes | ✔ | ❎ | ✔ |
| Maps | ✔ | ❎ | ❌ |

### Legend

✔ - Implemented  
❌- Failed  
❗ - Blocked  
❓ - Not implemented  
❎ - Not applicable

### Listed problems

1. OriginAPI doesn't respond with a generated URL for DEMEO like it should.  
(The button Edit API settings in organization administration under God user)
2. There was no consensus how to properly test if Previewbox or Renderbox is deployed successfully on localhost.  
It is highly possible that a hardware dongle with a license of the Lyric engine is required to run these modules.

## Supported OS

|OS Name | Is supported?| Is tested? |
|-|-|-|
| Windows 10 Pro 20H2 | ✔ | ✔ |
| Windows Server 2019 | ✔ | ✔ |

## 1. Localhost system pre-configuration

> In order to facilitate localhost configuration for Origin, the target localhost system must be pre-configured first with Windows PowerShell script.

### List of prerequisites

| Package | Localhost (Dev machine) | Other |
|-|-|-|
| Chocolatey | ✔ (latest) | ✔ (latest) |
| PowerShell (a.k.a PowerShell >v7.x.x) | ✔ (latest) | ✔ (latest) |
| Git | ✔ (latest) | ✔ (latest) |
| Microsoft Edge based on Chromium | ✔ (latest) | ✔ (latest) |
| .NET SDK | ✔ (latest) | ✔ (latest) |
| Microsoft Redistribute package 2017 | ✔ (latest revision) | ✔ (latest revision) |
| Visual Studio Build Tools (2019, MBuild > 16.8.3) | ✔ (latest revision) | ✔ (latest revision) |
| NuGet package manager | ✔ (latest) | ✔ (latest) |
| Visual Studio Remote Debugger | ✔ (2019) | ✔ (2019) |
| OpenConnect GUI VPN Client | ✔ (1.5.3) | ✔ (1.5.3) |
| System execution policy set to RemoteSigned | ✔ | ✔ |

### Achieved by

Executing this command

```powershell
PowerShell.exe -ExecutionPolicy Bypass -File .\Install-SystemTools.ps1
```

in any PowerShell console or CMD with the path pointed to the target folder (*a folder where PS scrips are located*).

### Notes

An additional user interaction with the target computer during installation is **is not recommended**. The script installs most of the feature silently but some features are installed in an interactive mode. The required input for the installations of these feature are handled by the script. The user interaction may break scripted input handling.

An user supervision of the script run **is recommended**.

## 2. Common localhost configuration for all Origin modules

> Based on the existing environment setup in USA, at least two website must be configured on the target localhost system. One for frontend applications, one for backend applications.
> A setup of `FrontendWebsiteId` and `BackendWebsiteId` must correspond to the `Website` array in the configuration JSON. This requirement is tested within the script.

### List of prerequisites

| Package | Localhost (Dev machine) | Other |
|-|-|-|
| Origin source code | ✔ (latest) | ✔ (latest) |
| Microsoft SQL Server 2019 Express | ✔ (latest revision) | ❎ |
| Microsoft Report Viewer 2010 SP1 | ✔ (latest revision) | ✔ (latest revision) |
| Microsoft SQL Server Management Studio | ✔ (latest revision) | ❎ |
| Windows optional modules/roles | ✔ | ✔ |
| Set Azure NuGet feed | ✔ | ✔ |
| Remote debugger configuration | ❎ | ✔ |
| Store network credentials for shared UNC | ✔ | ✔ |

### Achieved by

Automatically when try to deploy any Origin module.

## 3. Localhost configuration for Portal

> In future releases, the need for a specification of the Origin module will be removed. So far, only **Portal** module is supported.

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Install URL Rewrite Extension | ✔ (latest) | ✔ (latest) |
| Install Application Request Routing Extension | ✔ (latest) | ✔ (latest) |
| Install Node.js | ✔ (latest) | ✔ (latest) |
| Install Vue.js CLI | ✔ (latest revision) | ❎ |
| Configure Origin user | ✔ | ✔ |
| Turn on Server proxy in IIS ARR | ✔ | ✔ |
| Create Origin App Pool | ✔ | ✔ |
| Create Origin Web site | ✔ | ✔ |
| Apply HTTPS binding to Origin Web site | ✔ | ✔ |
| Create Origin App site | ✔ | ✔ |
| Apply additional bindings to Origin Web & App site | ✔ | ✔ |
| Create Origin Web app for Portal | ✔ | ✔ |
| Create Origin Web app for PortalApi | ✔ | ✔ |
| Create Origin Web app for Portal Application WebService | ✔ | ✔ |
| Deploy Web.config | ✔ | ✔ |
| Apply Web.config fix | ✔ | ✔ |
| Creates HomePageFiles virtual directory in Portal WebApp | ✔ | ✔ |
| Publish Company.Portal.Web project | ✔ | ✔ |
| Publish Company.Portal.API project | ✔ | ✔ |
| Publish Company.Portal.Application.WebService project | ✔ | ✔ |
| Update Company.Portal.Web Web.config to use localhost | ✔ | ✔ |
| Update Company.Portal.API Web.config to use localhost | ✔ | ✔ |
| Update Company.Portal.Application.WebService Web.config to use localhost | ✔ | ✔ |

### Achieved by

There are three options how to run the configuration. The configuration script **requires** PowerShell v7.0.3 and above.

The **first** option is an execution of the `Set-OriginPortal.ps1` script by the right-mouse-button click on the file.

The **second** option is an execution of this command

```powershell
pwsh.exe -ExecutionPolicy Bypass -File .\Set-OriginPortal.ps1
```

in PowerShell console (*incl. Windows PS and PS*) or CMD with the path pointed to the target folder (*a folder where PS scrips are located*).

The **third** option is an execution of the `Set-OriginPortal.ps1` script directly from PowerShell.

### Windows 10 optional modules required by Origin

This list was created as union of several lists from developers who have run Origin locally in the past.

* IIS-ApplicationDevelopment
* IIS-ApplicationInit
* IIS-ASP  
* IIS-ASPNET
* IIS-ASPNET45
* IIS-CGI  
* IIS-CommonHttpFeatures
* IIS-DefaultDocument
* IIS-DirectoryBrowsing
* IIS-HealthAndDiagnostics
* IIS-HttpCompressionStatic
* IIS-HttpErrors
* IIS-HttpLogging
* IIS-IIS6ManagementCompatibility
* IIS-ISAPIExtensions
* IIS-ISAPIFilter
* IIS-ManagementConsole  
* IIS-Metabase
* IIS-NetFxExtensibility
* IIS-NetFxExtensibility45
* IIS-Performance
* IIS-RequestFiltering
* IIS-Security
* IIS-ServerSideIncludes
* IIS-StaticContent
* IIS-WebServer
* IIS-WebServerManagementTools
* IIS-WebServerRole
* IIS-WebSockets
* Microsoft-Windows-Client-EmbeddedExp-Package
* MSMQ-Container
* MSMQ-Server
* MSRDC-Infrastructure
* NetFx3
* NetFx4-AdvSrvs
* NetFx4Extended-ASPNET45
* SmbDirect
* WAS-ConfigurationAPI
* WAS-NetFxEnvironment
* WAS-ProcessModel
* WAS-WindowsActivationService
* WCF-HTTP-Activation
* WCF-HTTP-Activation45
* WCF-MSMQ-Activation45
* WCF-Services45
* WCF-TCP-PortSharing45
* WorkFolders-Client

### Windows Server roles required by Origin

This list was created by reverse-engineering DEV and QA environment machines in USA with addition of some features identified on the developers machines and translated from Win10 feature name into Windows Server role.

* File-Services
* FS-FileServer
* Web-WebServer
* Web-Common-Http
* Web-Static-Content
* Web-Default-Doc
* Web-Dir-Browsing
* Web-Http-Errors
* Web-App-Dev
* Web-Asp-Net
* Web-Net-Ext
* Web-ISAPI-Ext
* Web-ISAPI-Filter
* Web-Health
* Web-Http-Logging
* Web-Log-Libraries
* Web-Request-Monitor
* Web-Security
* Web-Filtering
* Web-Performance
* Web-Stat-Compression
* Web-Dyn-Compression
* Web-Mgmt-Tools
* Web-Mgmt-Console
* Web-Scripting-Tools
* Web-Mgmt-Service
* NET-Framework
* NET-Framework-Core
* NET-Win-CFAC
* NET-HTTP-Activation
* NET-Non-HTTP-Activ
* MSMQ
* MSMQ-Services
* MSMQ-Server
* RSAT
* RSAT-Role-Tools
* RSAT-Web-Server
* WAS
* WAS-Process-Model
* WAS-NET-Environment
* WAS-Config-APIs
* Web-Asp-Net45
* Web-Net-Ext45
* Web-WebSockets
* NET-Framework-45-ASPNET
* NET-WCF-HTTP-Activation45
* NET-WCF-MSMQ-Activation45
* NET-WCF-Pipe-Activation45
* NET-WCF-Services45
* NET-WCF-TCP-Activation45
* NET-WCF-TCP-PortSharing45

### Notes

An additional user interaction with the target computer during installation is **is not recommended**. The script installs most of the feature silently but some features are installed in an interactive mode. The required input for the installations of these feature are handled by the script. The user interaction may break scripted input handling.

An user supervision of the script run **is recommended**.

On Windows Server, reboot is required in the middle of configuration. User must logon after reboot to complete the configuration. The script restart is handled via Task Scheduler in Windows. If this breaks, user have to restart the script manually.

A beep indicates the necessary interaction with the user.

## 4. Localhost configuration for Track

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Track | ✔ | ✔ |
| Create Origin Web app for TrackApi | ✔ | ✔ |
| Create Origin Web app for ConfigurationDomain | ✔ | ✔ |
| Create Origin Web app for Track WebService | ✔ | ✔ |
| Track Cache setup | ✔ | ✔ |
| Publish Track Vue.js component project | ✔ | ✔ |
| Publish Company.Track.Web project | ✔ | ✔ |
| Publish Company.Track.API project | ✔ | ✔ |
| Publish Company.Track.Application.WebService project | ✔ | ✔ |
| Publish Company.Track.ConfigurationDomain project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Update Company.Track.Web Web.config to use localhost | ✔ | ✔ |
| Update Company.Track.API Web.config to use localhost | ✔ | ✔ |
| Update Company.Track.Application.WebService Web.config to use localhost | ✔ | ✔ |
| Update Company.Track.ConfigurationDomain Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginTrack.ps1`. The options how to invoke this script are the same as for the Portal.

## 5. Localhost configuration for OriginAPI

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for OriginApi | ✔ | ✔ |
| Publish OriginAPI project | ✔ | ✔ |
| Update OriginAPI Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginAPI.ps1`. The options how to invoke this script are the same as for the Portal.

## 6. Localhost configuration for News

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for News | ✔ | ✔ |
| Publish Company.News.Web project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Create symbolic link to Track Shared directory | ✔ | ✔ |
| Update Company.News.Web Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginNews.ps1`. The options how to invoke this script are the same as for the Portal.

## 7. Localhost configuration for Compose

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Compose | ✔ | ✔ |
| Publish Company.Compose.Web project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Create symbolic link to Track Shared directory | ✔ | ✔ |
| Update Company.Compose.Web Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginCompose.ps1`. The options how to invoke this script are the same as for the Portal.

## 8. Localhost configuration for Charts

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Charts | ✔ | ✔ |
| Publish Company.Charts.Web project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Create symbolic link to Track Shared directory | ✔ | ✔ |
| Update Company.Charts.Web Web.config to use localhost | ✔ | ✔ |
| Publish Charts Vue.js component project | ✔ | ✔ |

### Achieved by

Executing `Set-OriginCharts.ps1`. The options how to invoke this script are the same as for the Portal.

## 9. Localhost configuration for Order

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Order | ✔ | ✔ |
| Create Origin Web app for Order2 | ✔ | ✔ |
| Publish Company.Order.Web project | ✔ | ✔ |
| Publish Company.Order2.Web project | ✔ | ✔ |
| Create symbolic link to Portal bin directory for Order | ✔ | ✔ |
| Create symbolic link to Portal bin directory for Order2 | ✔ | ✔ |
| Create symbolic link to Portal Shared directory for Order | ✔ | ✔ |
| Create symbolic link to Portal Shared directory for Order2 | ✔ | ✔ |
| Create symbolic link to Shared directory MediaFormatImage for Order | ✔ | ✔ |
| Update Company.Order.Web Web.config to use localhost | ✔ | ✔ |
| Update Company.Order2.Web Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginOrder.ps1`. The options how to invoke this script are the same as for the Portal.

## 10. Localhost configuration for Typefaces

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Typefaces | ✔ | ✔ |
| Publish Company.Typefaces.Web project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Update Company.Typefaces.Web Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginTypefaces.ps1`. The options how to invoke this script are the same as for the Portal.

## 11. Localhost configuration for Transport

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Transport | ✔ | ✔ |
| Publish Company.Transport.Web project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Update Company.Transport.Web Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginTransport.ps1`. The options how to invoke this script are the same as for the Portal.

## 12. Localhost configuration for Order

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Order | ✔ | ✔ |
| Create Origin Web2 app for Order | ✔ | ✔ |
| Publish Company.Order.Web project | ✔ | ✔ |
| Publish Company.Order.Web2 project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Update Company.Order.Web Web.config to use localhost | ✔ | ✔ |
| Update Company.Order.Web2 Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginOrder.ps1`. The options how to invoke this script are the same as for the Portal.

## 13. Localhost configuration for PreviewBox

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for PreviewBox | ✔ | ✔ |
| Create Origin Web app for PreviewBox WebService | ✔ | ✔ |
| Publish Company.PreviewBox.Web project | ✔ | ✔ |
| Publish Company.PreviewBox.WebService project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Update Company.PreviewBox.Web Web.config to use localhost | ✔ | ✔ |
| Update Company.PreviewBox.WebService Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginPreviewBox.ps1`. The options how to invoke this script are the same as for the Portal.

## 14. Localhost configuration for RenderBox

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for RenderBox | ✔ | ✔ |
| Create Origin Web app for RenderBox Application WebService | ✔ | ✔ |
| Publish Company.RenderBox.Application.Web project | ✔ | ✔ |
| Publish Company.RenderBox.WebService project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Update Company.RenderBox.Web Web.config to use localhost | ✔ | ✔ |
| Update Company.RenderBox.Application.WebService Web.config to use localhost | ✔ | ✔ |

### Achieved by

Executing `Set-OriginRenderBox.ps1`. The options how to invoke this script are the same as for the Portal.

## 15. Localhost configuration for Maps

### List of installation and configuration steps

| Step | Localhost (Dev machine) | Other |
|-|-|-|
| Create Origin Web app for Maps | ✔ | ✔ |
| Create Origin Web app for MapsAdmin | ✔ | ✔ |
| Publish Company.Maps.Web project | ✔ | ✔ |
| Publish Company.Maps.Admin.Web project | ✔ | ✔ |
| Create symbolic link to Portal bin directory | ✔ | ✔ |
| Create symbolic link to Portal Shared directory | ✔ | ✔ |
| Update Company.Maps.Web Web.config to use localhost | ✔ | ✔ |
| Update Company.Maps.Admin.Web Web.config to use localhost | ✔ | ✔ |
| Copy CMD tools to %SystemRoot%\\_maps from network share | ✔ | ✔ |
| Set URL rewrite rule | ✔ | ✔ |
| Create %SystemRoot%\\Company.Maps.Runtime | ✔ | ✔ |
| Create symbolic link %SystemRoot%\\Company.Maps.Runtime\\EarthCache | ✔ | ✔ |
| Create symbolic link %SystemRoot%\\Company.Maps.Runtime\\TileServer | ✔ | ✔ |
| Create symbolic link %SystemRoot%\\Company.Maps.Runtime\\Static to static assets | ✔ | ✔ |
| Test target OS culture setup | ✔ | ✔ |
| Build MapsConsole application | ✔ | ✔ |
| Run MapsConsole application with initial setup | ✔ | ✔ |

### Achieved by

Executing `Set-OriginMaps.ps1`. The options how to invoke this script are the same as for the Portal.
