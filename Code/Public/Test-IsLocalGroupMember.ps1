function global:Test-IsLocalGroupMember
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>
	
	[CmdletBinding()]
	[OutputType([boolean])]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0,
				 HelpMessage = 'Enter the name of the user account to check group membership against.')]
		[Alias('UserName')]
		[String]$User,
		[Parameter(Mandatory = $true,
				 Position = 1,
				 HelpMessage = 'Enter the name(s) of the built-in groups to test.')]
		[String]$GroupName
	)
	
	begin
	{
		$objGroup = [ADSI]"WinNT://./$GroupName,group"
		$objMembers = @($objGroup.Psbase.Invoke("Members"))
	}
	process
	{
		$Members = ($objMembers | ForEach-Object { $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) })
	}
	end
	{
		if ($Members -contains $user)
		{
			return [bool]$true
		}
		else
		{
			return [bool]$false
		}
	}
	
} #end function Test-IsLocalGroupMember