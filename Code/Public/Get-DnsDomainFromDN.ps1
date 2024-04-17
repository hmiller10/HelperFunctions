function global:Get-DnsDomainFromDN
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('Get-DomainFromDN')]
	[OutputType([string])]
	param
	(
	[Parameter(Mandatory = $true,
			 Position = 0)]
	[ValidateNotNullOrEmpty()]
	[string]$DistinguishedName
	)

	begin
	{ }
	process
	{
		$Domain = $DistinguishedName -Split "," | Where-Object { $_ -like "DC=*" }
		$Domain = $Domain -join "." -replace ("DC=", "")
	}
	end
	{
		return $Domain
	}
}#end function Get-DnsDomainFromDN