function Test-IsLocalGroupMember
{
	<#
		.EXTERNALHELP HelperFunctions-Help.xml
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
		[String]$GroupName,
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 2,
				 HelpMessage = 'Enter the computer name or FQDN.')]
		[ValidateNotNullOrEmpty()]
		[Alias('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[String]$ComputerName,
		[Parameter(Position = 3,
				 HelpMessage = 'Enter PS credential to connecct to AD forest with.')]
		[ValidateNotNull()]
		[System.Management.Automation.PsCredential][System.Management.Automation.Credential()]
		$Credential = [System.Management.Automation.PSCredential]::Empty
	)

	begin
	{
		if ($PSBoundParameters["ComputerName"])
		{
			$objGroup = [ADSI]"WinNT://$ComputerName/$GroupName,group"
		}
		else
		{
			$objGroup = [ADSI]"WinNT://./$GroupName,group"
		}
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