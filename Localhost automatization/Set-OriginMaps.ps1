# Name: Set-OriginPortal
# author: Radek Zahradník (radek.zahradnik@msn.com)
# Date: 2021-02-07
# Version: 1.0
# Purpose: This script triggers an environment configuration for Maps.
##########################################################################
#Requires -Version 7.0.3

# Elevate this script to admin privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { Start-Process pwsh.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args`"" -Verb RunAs; exit }

$pathToConfigurationScript = Join-Path -Path $PSScriptRoot -ChildPath Set-OriginEnvironment.ps1
Invoke-Expression "& `"$pathToConfigurationScript`" Maps"