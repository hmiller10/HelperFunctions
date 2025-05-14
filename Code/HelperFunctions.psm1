$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

foreach ($import in @($Public + $Private))
{
    try
    {
        Write-Verbose "Importing $($import.FullName)"
        . $import.fullname
    }
    catch
    {
        Write-Error -Message ("Failed to import function {0}" -f $import.FullName) -ErrorAction 'Stop'
    }
}

Export-ModuleMember -Function $Public.BaseName -Alias *