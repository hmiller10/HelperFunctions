$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

$buildVersion = $env:BUILDDIR
$manifestPath = ".\code\HelperFunctions.psd1"
$publicFuncFolderPath = '.\code\public'
$privateFuncFolderPath = '.\code\private'


if ($null -eq (Get-PackageProvider -ListAvailable -Name NuGet)) {
    Install-PackageProvider -Name NuGet -Scope AllUsers -Force | Out-Null
}
Import-PackageProvider -Name NuGet -Force | Out-Null

if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

$manifestContent = (Get-Content -Path $manifestPath -Raw) -replace '2.2.27', $buildVersion

#if ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
#   $funcStrings = "'$($publicFunctionNames -join "','")'"
#} else {
#    $funcStrings = $null
#}

#$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath
