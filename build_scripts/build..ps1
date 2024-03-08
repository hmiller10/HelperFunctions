$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

$buildVersion = '2.2.28'
$manifestPath = "./code/HelperFunctions.psd1"
$publicFuncFolderPath = './code/public'
$privateFuncFolderPath = './code/private'


if (!(Get-PackageProvider | Where-Object { $_.Name -eq 'NuGet' })) {
    Install-PackageProvider -Name NuGet -force | Out-Null
}
Import-PackageProvider -Name NuGet -force | Out-Null

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
