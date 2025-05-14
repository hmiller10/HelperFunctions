function global:Get-TimeStamp
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml
		#>
	[CmdletBinding()]
	[Alias('Get-FileDate')]
	param ()
	begin {}
	process
	{
		try
		{
			(Get-Date -ErrorAction Stop).ToString('yyyy-MM-dd_hh-mm-ss')
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}
	end {}
} #End function Get-TimeStamp