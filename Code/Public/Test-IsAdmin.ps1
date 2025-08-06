function Test-IsAdmin
{
	<#
		.EXTERNALHELP HelperFunctions-Help.xml
	#>

	BEGIN
	{
		$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
	}
	PROCESS
	{
		$principal = New-Object Security.Principal.WindowsPrincipal $identity
	}
	END
	{
		$principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
	}

} #End function Test-IsAdmin