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
		try
		{
			#https://docs.microsoft.com/en-us/dotnet/api/system.net.securityprotocoltype?view=netcore-2.0#System_Net_SecurityProtocolType_SystemDefault
			if ($PSVersionTable.PSVersion.Major -lt 6 -and [Net.ServicePointManager]::SecurityProtocol -notmatch 'Tls12')
			{
				Write-Verbose -Message 'Adding support for TLS 1.2'
				[Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls12
			}
		}
		catch
		{
			Write-Warning -Message 'Adding TLS 1.2 to supported security protocols was unsuccessful.'
		}
		
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