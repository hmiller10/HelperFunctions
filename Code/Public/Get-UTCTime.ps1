function Get-UTCTime
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('UTC-Now','fnUTC-Now')]
	Param ()

	Begin {}
	Process {
		$ErrorActionPreference = 'Stop'
		try
		{
			(Get-Date).ToUniversalTime()
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}

}#End function Get-UTCTime