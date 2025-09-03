function Get-MyInvocation
{
	<#
		.EXTERNALHELP HelperFunctions-Help.xml
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