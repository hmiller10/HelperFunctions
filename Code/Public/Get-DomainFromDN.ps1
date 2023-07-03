function global:Get-DomainFromDN
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	
	[CmdletBinding()]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0)]
		[string]$DistinguishedName
	)
	
	begin
	{}
	process
	{
		$Domain = $DistinguishedName -Split "," | Where-Object { $_ -like "DC=*" }
		$Domain = $Domain -join "." -replace ("DC=", "")
	}
	end
	{
		return $Domain
	}
}