function global:Get-TodaysDate
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('fnGet-TodaysDate')]
	Param ()
	Begin {}
	Process {
		try
		{
			Get-Date -Format 'MM-dd-yyyy' -ErrorAction Stop
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}
	End {}
}#end function