function global:Test-Credential
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'LocalUserParamSet',
				SupportsShouldProcess = $true)]
	[OutputType([Boolean], ParameterSetName = 'RemoteUserParamSet')]
	[OutputType([Boolean], ParameterSetName = 'LocalUserParamSet')]
	[OutputType([Boolean], ParameterSetName = 'DomainUserParamSet')]
	param
	(
		[Parameter(ParameterSetName = 'LocalUserParamSet',
				 Mandatory = $true,
				 Position = 0,
				 HelpMessage = 'Enter PS credential object name')]
		[Parameter(ParameterSetName = 'DomainUserParamSet',
				 Mandatory = $true,
				 Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Alias('PSCredential')]
		[pscredential]$Credential,
		[Parameter(ParameterSetName = 'RemoteUserParamSet',
				 Mandatory = $true,
				 Position = 1,
				 HelpMessage = 'Select this parameter if validating a local computer user credential')]
		[Alias('ComputerName')]
		[String]$Computer,
		[Parameter(ParameterSetName = 'DomainUserParamSet',
				 Mandatory = $true,
				 Position = 1,
				 HelpMessage = 'Enter the AD domain FQDN.')]
		[Alias('FQDN', 'Domain', 'ADDomain')]
		[String]$DomainFQDN
	)
	
	begin
	{
		Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	}
	process
	{
		if ($pscmdlet.ShouldProcess($Credential, "ValidateCredential"))
		{
			$passToValidate = $Credential.GetNetworkCredential().Password
			if ($PSBoundParameters.ContainsKey('Computer'))
			{
				Write-Verbose -Message "Searching remote computer sAMAccountDatabase. Please wait... `n"
				$ctx = [System.DirectoryServices.AccountManagement.ContextType]::Machine
				$principalCtx = [System.DirectoryServices.AccountManagement.PrincipalContext]::new($ctx, $Computer)
				$UserIDToValidate = $Credential.GetNetworkCredential().UserName
			}
			elseif (($PSBoundParameters.ContainsKey('DomainFQDN')) -and ($null -ne $PSBoundParameters["DomainFQDN"]))
			{
				Write-Verbose -Message "Searching Active Directory. Please wait... `n"
				$ctx = [System.DirectoryServices.AccountManagement.ContextType]::Domain
				$principalCtx = [System.DirectoryServices.AccountManagement.PrincipalContext]::new($ctx, $DomainFQDN)
				$adUser = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($principalCtx, $Credential.UserName)
				$UserIDToValidate = $adUser.SamAccountName
			}
			else
			{
				Write-Verbose -Message "Searching local computer sAMAccountDatabase. Please wait... `n"
				$ctx = [System.DirectoryServices.AccountManagement.ContextType]::Machine
				$principalCtx = [System.DirectoryServices.AccountManagement.PrincipalContext]::new($ctx, $nv:COMPUTERNAME)
				$UserIDToValidate = $Credential.GetNetworkCredential().UserName
			}
			Write-Verbose -Message "Testing credential. Please wait... `n"
			$result = $principalCtx.ValidateCredentials($UserIDToValidate, $passToValidate)
		}
	}
	end
	{
		return $result
	}
}#end function Test-Credential