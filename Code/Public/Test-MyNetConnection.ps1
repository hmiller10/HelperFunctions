function Test-MyNetConnection
{
<#
	.EXTERNALHELP HelperFunctions.psm1-Help.xml
		
#>
	
	[CmdletBinding()]
	[Alias('fnTest-NetConnection')]
	param
	(
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 0)]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[String[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(Mandatory = $true,
				 Position = 1)]
		[int32]$Port
	)
	
	begin
	{
		
		if ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -gt 1))
		{
			$ComputerName = $ComputerName -split (",")
		}
		elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -eq 1))
		{
			$ComputerName = $PSBoundParameters["ComputerName"]
		}
		
	}
	process
	{
		foreach ($C in $ComputerName)
		{
			try
			{
				Test-NetConnection -ComputerName $C -Port $Port
			}
			catch
			{
				$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
				Write-Error $errorMessage -ErrorAction Continue
			}
		}
		
		
	}
	end
	{ }
}#end function Test-MyNetConnection