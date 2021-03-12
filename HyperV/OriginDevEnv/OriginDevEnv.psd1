@{
RootModule = 'OriginDevEnv'
ModuleVersion = '1.0.0.0'
GUID = '11c5f17f-6851-4b91-9cf8-ca0ce53745b6'
Author = 'Radek Zahradník'
CompanyName = 'CompanyName'
Copyright = '(c) 2020 Company Hego. All rights reserved.'
Description = 'A collection of tools used to deploy Origin'
PowerShellVersion = '5.0'
FunctionsToExport = @('Set-OriginDevEnv','Remove-OriginDevEnv', 'Open-OriginDevEnvConfig','Remove-OriginDevEnvTargetIsoFile')
AliasesToExport = '*'
FileList = @('configuration.json')
PrivateData = @{
    PSData = @{
        ReleaseNotes = @'
v1.0.0: (2020-10-18)
- Initial commit
'@
    }
}
}

