function Test-IsInstalled
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0)]
		[ValidateNotNullOrEmpty()]
		[String]$Program
	)

	begin { }
	process
	{
		$x86 = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | `
			Where-Object { $_.GetValue("DisplayName") -like "*$program*" }).Length -gt 0;

		$x64 = ((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | `
			Where-Object { $_.GetValue("DisplayName") -like "*$program*" }).Length -gt 0;
	}
	end
	{
		return $x86 -or $x64;
	}
} #End function Test-IsInstalled