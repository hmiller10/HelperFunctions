function global:Get-DNfromFQDN
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[OutputType([String])]
	param
	(
	[Parameter(Mandatory = $true,
			 ValueFromPipeline = $false,
			 Position = 0,
			 HelpMessage = 'Enter the fully qualified domain name to convert')]
	[ValidateNotNullOrEmpty()]
	[string]$FQDN
	)

	begin
	{
		$Error.Clear()
		$arrFQDN = $FQDN -split ("\.")
		[int]$DomainNameCount = 0
	}
	process
	{
		foreach ($item in $arrFQDN)
		{
			if ($DomainNameCount -eq 0)
			{
				[string]$ADObjectArrayItem += "DC" + $item
			}
			else
			{
				[string]$ADObjectArrayItem += ",DC" + $item
			}
			$DomainNameCount++
		}

	}
	end
	{
		return $ADObjectArrayItem
	}

} #End function Get-DNfromFQDN