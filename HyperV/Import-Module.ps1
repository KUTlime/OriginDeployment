$moduleName = 'OriginDevEnv'
$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'User')
$newpath = $path + ";$PSScriptRoot\$moduleName"
[Environment]::SetEnvironmentVariable('PSModulePath', $newpath, 'User')