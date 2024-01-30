function Get-TimeStamp
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	[CmdletBinding()]
	param ()
	begin {}
	process { (Get-Date).ToString('yyyy-MM-dd_hh-mm-ss') }
	end {}
} #End function Get-TimeStamp