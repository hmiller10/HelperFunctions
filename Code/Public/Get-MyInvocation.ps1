function global:Get-MyInvocation
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('fnGet-MyInvocation')]
	param
	( )
	Begin {}
	Process {
		return $MyInvocation
	}
	End {}
}#end function Get-MyInvocation