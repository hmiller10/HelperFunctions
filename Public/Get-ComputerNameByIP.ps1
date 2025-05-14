function global:Get-ComputerNameByIP
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 0)]
		[IPAddress]$IPAddress
	)

	BEGIN
	{ }
	PROCESS
	{
		If ($IPAddress -and $_)
		{
			Throw 'Please use either pipeline or input parameter'
			Break
		}
		ElseIf ($IPAddress)
		{
			([System.Net.Dns]::GetHostbyAddress($IPAddress)).HostName
		}
		ElseIf ($_)
		{
			[System.Net.Dns]::GetHostbyAddress($_).HostName
		}
		Else
		{
			$IPAddress = Read-Host "Please supply the IP Address"
			[System.Net.Dns]::GetHostbyAddress($IPAddress).HostName
		}
	}
	END
	{ }
} #End function Get-ComputerNameByIP