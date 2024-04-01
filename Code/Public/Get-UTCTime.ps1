function global:Get-UTCTime
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>
	
	[CmdletBinding()]
	Param ()
	
	Begin {}
	Process {
		$ErrorActionPreference = 'Stop'
		try
		{
			[System.DateTime]::UtcNow
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		} 
	}

}#End function Get-UTCTime