function Test-IsRemoteGroupMember
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding(DefaultParameterSetName = 'LocalComputerParamSet')]
	[OutputType([boolean], ParameterSetName = 'LocalComputerParamSet')]
	[OutputType([boolean], ParameterSetName = 'RemoteComputerParamSet')]
	[OutputType([boolean])]
	param
	(
		[Parameter(ParameterSetName = 'LocalComputerParamSet',
				 Mandatory = $true,
				 Position = 0,
				 HelpMessage = 'Enter the name of the user account to check group membership against.')]
		[Parameter(ParameterSetName = 'RemoteComputerParamSet',
				 HelpMessage = 'Enter local user name to verify')]
		[Alias('UserName')]
		[String]$User,
		[Parameter(ParameterSetName = 'LocalComputerParamSet',
				 Mandatory = $true,
				 Position = 1,
				 HelpMessage = 'Enter the name(s) of the built-in groups to test.')]
		[Parameter(ParameterSetName = 'RemoteComputerParamSet')]
		[String]$GroupName,
		[Parameter(ParameterSetName = 'LocalComputerParamSet',
				 Position = 2,
				 HelpMessage = 'Enter computer name to check group on.')]
		[Parameter(ParameterSetName = 'RemoteComputerParamSet')]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[String]$ComputerName,
		[Parameter(ParameterSetName = 'RemoteComputerParamSet',
				 Position = 3)]
		[pscredential]$Credential
	)

	begin
	{
		$objGroup = [ADSI]"WinNT://$ComputerName/$GroupName,group"
		if (($PSBoundParameters.ContainsKey('Credential')) -and ($null -ne $PSBoundParameters["Credential"]))
		{
			$objGroup.Psbase.UserName = $Credential.UserName
			$objGroup.Psbase.Password = $Credential.GetNetworkCredential().Password
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
} #end function Test-IsRemoteGroupMember