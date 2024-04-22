function global:Test-IsValidIPAddress
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('fnTest-IsValidIPAddress')]
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
			[bool]$result = $true
		}
		else
		{
			[bool]$result = $false
		}
	}
	end
	{
		return $result
	}

}#end function Test-IsValidIPAddress