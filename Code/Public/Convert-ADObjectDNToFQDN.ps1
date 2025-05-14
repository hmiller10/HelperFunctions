function global:Convert-ADObjectDNToFQDN
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
		[ValidateNotNullOrEmpty()]
		[string]$DistinguishedName
	)


	begin
	{	
		[array]$ObjectDNArray = $DistinguishedName -Split(“,DC=”)
	     [int]$DomainNameCount = 0
	}
	process
	{
		ForEach ($arrayItem in $ObjectDNArray)
		{
		 	if ($DomainNameCount -gt 0) { [string]$ObjectFullyQualifiedDomainName += $arrayItem + “.” }
		 	$DomainNameCount++
		}
	}
	end
	{
		return $ObjectFullyQualifiedDomainName
	}

}#end function Convert-ADObjectDNToFQDN