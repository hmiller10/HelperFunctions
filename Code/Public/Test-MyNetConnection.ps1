function Test-MyNetConnection
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
		Test-NetConnection -ComputerName $Server -Port $port
	}
	end
	{}
}
