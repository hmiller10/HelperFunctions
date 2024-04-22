function global:Get-ReportDate
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('fnGet-ReportDate')]
	Param ()

	Begin {}
	Process {
		try
		{
			(Get-Date -ErrorAction Stop).ToString("yyyy-MM-dd")
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}
	End {}

}#end function Get-ReportDate