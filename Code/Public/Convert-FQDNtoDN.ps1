function Convert-FQDNtoDN
{
	<#
		.EXTERNALHELP HelperFunctions-Help.xml
	#>

	[CmdletBinding()]
	[OutputType([string])]
	[Alias('Get-DNfromFQDN')]
	param
	(
		[Parameter(Mandatory = $true,
				 HelpMessage = 'Enter domain FQDN')]
		[ValidateNotNullOrEmpty()]
		[string]$FQDN
	)

	begin
	{
		$DomainFQDNArray = $FQDN -Split ("\.")
	}
	process
	{
		[int]$FQDNCount = 0

		foreach ($Item in $DomainFQDNArray)
		{
			if ($FQDNCount -eq 0)
			{ [string]$objDNArrayItem += "DC=" + $Item }
			else
			{ [string]$objDNArrayItem += ",DC=" + $Item }
			$FQDNCount++
		}
	}
	end
	{
		return $objDNArrayItem
	}
}#end function Convert-FQDNtoDN