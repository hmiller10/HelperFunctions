function global:Test-MyNetConnection
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0)]
		[String]$Server,
		[Parameter(Mandatory = $true,
				 Position = 1)]
		[int32]$Port
	)

	begin
	{}
	process
	{
		try
		{
			Test-NetConnection -ComputerName $Server -Port $port
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}

	}
	end
	{}
}#end function Test-MyNetConnection