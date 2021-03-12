# Name: Start-OriginVPN
# author: Radek Zahradník (radek.zahradnik@msn.com)
# Date: 2021-01-18
# Version: 1.0
# Purpose: This script serves as VPN auto launch.
# The original purpose is to use this script as argument in the Task scheduler
# but it can be use standalone.
##########################################################################
#Requires -Version 7.0.3

# Elevate this script to admin privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process pwsh.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args`"" -Verb RunAs; exit }

enum ShowStates
{
    Hide = 0
    Normal = 1
    Minimized = 2
    Maximized = 3
    ShowNoActivateRecentPosition = 4
    Show = 5
    MinimizeActivateNext = 6
    MinimizeNoActivate = 7
    ShowNoActivate = 8
    Restore = 9
    ShowDefault = 10
    ForceMinimize = 11
}

$Host.UI.RawUI.WindowTitle = 'Starting VPN... Please, wait until this window closes itself.'
Write-Host 'Starting VPN...'
Write-Host 'Please, wait with no computer interaction until this window closes itself.'
$runningConnection = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and ($_.InterfaceDescription -like '*TAP*Windows*') }
if ([object]::Equals($runningConnection, $null))
{
    $code = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $type = Add-Type -MemberDefinition $code -Name myAPI -PassThru

    [System.IO.FileInfo] $pathToClient = Get-ChildItem -Path ${env:ProgramFiles(x86)} -Recurse -File -Filter openconnect-gui.exe
    Get-Process -Name $pathToClient.BaseName -ErrorAction:SilentlyContinue | Stop-Process
    Start-Process -FilePath $pathToClient.FullName
    while ($true)
    {
        $windowTitle = Get-Process -Name $pathToClient.BaseName -ErrorAction:SilentlyContinue | Select-Object -ExpandProperty MainWindowTitle
        if ([string]::IsNullOrWhiteSpace($windowTitle))
        {
            "Waiting for $($pathToClient.BaseName)..." | Write-Verbose
            Start-Sleep 1
            continue
        }
        break;
    }

    $wshell = New-Object -ComObject wscript.shell
    [void]$wshell.AppActivate($windowTitle)
    Start-Sleep 1
    $wshell.SendKeys('{TAB}')
    Start-Sleep 0.1
    $wshell.SendKeys('{TAB}')
    Start-Sleep 0.1
    $wshell.SendKeys('{TAB}')
    Start-Sleep 1
    Write-Verbose 'Initiating connection'
    $wshell.SendKeys(' ')
    Write-Verbose 'The connection initiated.'
    Start-Sleep 1
    # apply a new window size to the handle, i.e. hide the window completely
    [void]$type::ShowWindowAsync((Get-Process -Name $pathToClient.BaseName).MainWindowHandle, [ShowStates]::Hide)
    Start-Sleep 0.5
}

