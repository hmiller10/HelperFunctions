function global:Get-MyInvocation
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	param
	( )
	Begin {}
	Process {
		return $MyInvocation
	}
	End {}
}#end function Get-MyInvocation