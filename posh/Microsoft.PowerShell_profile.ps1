# Array of paths containing additional formatting data
#
# Calling Update-FormatData is *very* expensive. To improve profile load
# performance, functions and settings files should append the path(s) of
# any formatting data files to this array. After sourcing all functions
# and settings we'll call Update-FormatData with all specified paths.
$FormatDataPaths=@()

# Source custom functions
$PoshFunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
if (Test-Path -Path $PoshFunctionsPath -PathType Container) {
    Get-ChildItem -Path $PoshFunctionsPath -File -Recurse -Include '*.ps1' | ForEach-Object { . $_.FullName }
}
Remove-Variable -Name PoshFunctionsPath

# Source custom settings
$PoshSettingsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Settings'
if (Test-Path -Path $PoshSettingsPath -PathType Container) {
    Get-ChildItem -Path $PoshSettingsPath -File -Recurse -Include '*.ps1' | ForEach-Object { . $_.FullName }
}
Remove-Variable -Name PoshSettingsPath

# Update formatting data
if ($FormatDataPaths) {
    Write-Verbose -Message '[dotfiles] Updating formatting data ...'
    Update-FormatData -PrependPath $FormatDataPaths
}
Remove-Variable -Name FormatDataPaths

# Amend the search path to include our scripts directory
$PoshScriptsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts'
if (Test-Path -Path $PoshScriptsPath -PathType Container) {
    $env:Path = '{0};{1}' -f $PoshScriptsPath, $env:Path
}
Remove-Variable -Name PoshScriptsPath
