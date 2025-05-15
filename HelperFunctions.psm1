$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction Continue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction Continue )

foreach ($import in @($Public + $Private))
{
    try
    {
        . $import.fullname
    }
    catch
    {
        throw "Failed to import function {0}" -f $import.FullName
    }
}

Export-ModuleMember -Function $Public.BaseName

