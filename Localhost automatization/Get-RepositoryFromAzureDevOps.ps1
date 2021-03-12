# Name: Get-RepositoryFromAzureDevOps
# author: Radek Zahradník (radek.zahradnik@msn.com)
# Date: 2020-10-29
# Version: 1.0
# Purpose: This script performs a git clone operation
# of Origin repository or repositories from Azure DevOps.
##########################################################################


####################################################
# Technical section - Do not modify unless you know
# what you are doing.
####################################################
enum Repository
{
    origin
    originapi
    compose
    deployment
    charts
    maps
    news
    order
    portal
    previewbox
    quotes
    renderbox
    shared
    track
    transport
    typefaces
}

# Do not change the key. You can change value to whatever you like.
$repositorySetup = @{
    origin          = 'origin'
    originapi       = 'originapi'
    charts        = 'charts'
    compose       = 'compose'
    maps          = 'maps'
    news          = 'news'
    order         = 'order'
    portal        = 'portal'
    previewbox    = 'previewbox'
    quotes        = 'quotes'
    renderbox     = 'renderbox'
    shared        = 'shared'
    track         = 'track'
    transport     = 'transport'
    typefaces     = 'typefaces'
    deployment    = 'deployment'
}

function Get-OriginRepository
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RepoName,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_ | Test-Path })]
        [System.IO.DirectoryInfo]
        $LocalFolder,
        [Switch]
        $Parallel
    )
    process
    {
        $argumentList = 'clone', "https://chyronhego@dev.azure.com/chyronhego/Origin/_git/$RepoName","$($LocalFolder.FullName)"
        if ($Parallel)
        {
            Start-Process -FilePath git -ArgumentList $argumentList
        }
        else
        {
            Write-Host "Starting to cloning $RepoName into local folder $($LocalFolder.FullName)"
            git $argumentList
        }
    }

}

function Set-OriginRepository
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RepoName,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [System.IO.DirectoryInfo]
        $LocalFolder,
        [Switch]
        $Parallel
    )
    process
    {
        $childPath = $repositorySetup[$RepoName]
        if ([object]::Equals($childPath, $null))
        {
            throw [System.ArgumentException]::new("Unknown repository name: $RepoName. Check configuration of this script.")
        }
        [System.IO.DirectoryInfo] $localClonePath = Join-Path -Path $LocalFolder.FullName -ChildPath $childPath
        New-Item -Path $localClonePath.FullName -ItemType:Directory -ErrorAction:SilentlyContinue | Write-Verbose
        Get-OriginRepository -RepoName $childPath -LocalFolder $localClonePath -Parallel:$Parallel
    }

}
####################################################

function Get-RepositoryFromAzureDevops
{
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Single Repo')]
        [ValidateNotNullOrEmpty()]
        [Repository]
        $RepoName,
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [System.IO.DirectoryInfo]
        $LocalFolder = "$env:USERPROFILE\source\CompanyName\Origin",
        [Parameter(Mandatory, ParameterSetName = 'All')]
        [Parameter(Mandatory, ParameterSetName = 'All Parallel')]
        [Switch]
        $All,
        [Parameter(Mandatory, ParameterSetName = 'All Parallel')]
        [Switch]
        $Parallel,
        [Switch]
        $Force
    )

    if($Force)
    {
        Remove-Item -Path $LocalFolder -Recurse -Force
    }

    if ($all)
    {
        $repositorySetup.Values | ForEach-Object { Set-OriginRepository -LocalFolder $LocalFolder -RepoName $_ -Parallel:$Parallel }
        return
    }
    Set-OriginRepository -LocalFolder $LocalFolder -RepoName $RepoName
}
Get-RepositoryFromAzureDevops -All -LocalFolder $args[0]