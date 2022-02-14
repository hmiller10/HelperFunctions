function Test-IsValidIPAddress
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	
	[CmdletBinding()]
	[OutputType([boolean])]
	param
	(
		[Parameter(Mandatory = $true)]
		[String]$IP
	)

	begin
	{
	}
	process
	{
		[System.Net.IPAddress]$IPAddressObject = $null
		if ([System.Net.IPAddress]::TryParse($IP, [ref]$IPAddressObject) -and $IP -eq $IPAddressObject.tostring())
		{
			$true
		}
		else
		{
			$false
		}
	}
	end
	{
	}

}