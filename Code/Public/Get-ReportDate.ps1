function global:Get-ReportDate
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	Param ()

	Begin {}
	Process {
		try
		{
			Get-Date -Format 'yyyy-MM-dd' -ErrorAction Stop
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}
	End {}

}#end function Get-ReportDate