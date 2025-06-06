function Test-Credential
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'LocalUserParamSet',
	               SupportsShouldProcess = $true)]
	[OutputType([Boolean], ParameterSetName='LocalUserParamSet')]
	[OutputType([Boolean], ParameterSetName='RemoteUserParamSet')]
	[OutputType([Boolean], ParameterSetName='DomainUserParamSet')]
	param
	(
		[Parameter(ParameterSetName = 'RemoteUserParamSet',
		           Mandatory = $true,
		           ValueFromPipeline = $true,
		           ValueFromPipelineByPropertyName = $true,
		           Position = 0,
		           HelpMessage = 'Select this parameter if validating a remote computer user credential')]
		[Parameter(ParameterSetName = 'DomainUserParamSet',
		           Mandatory = $true,
		           ValueFromPipeline = $true,
		           ValueFromPipelineByPropertyName = $true,
		           Position = 0,
		           HelpMessage = 'Select this parameter if validating an AD domain user credential')]
		[Parameter(ParameterSetName = 'LocalUserParamSet',
		           Mandatory = $true,
		           ValueFromPipeline = $true,
		           ValueFromPipelineByPropertyName = $true,
		           Position = 0,
		           HelpMessage = 'Select this parameter if validating a local computer user credential')]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[ValidateNotNullOrEmpty()]
		[string[]]
		$ComputerName = $env:COMPUTERNAME,
		[Parameter(ParameterSetName = 'LocalUserParamSet',
		           Mandatory = $true,
		           Position = 1,
		           HelpMessage = 'Enter PS credential object name')]
		[Parameter(ParameterSetName = 'DomainUserParamSet',
		           Mandatory = $true,
		           Position = 1,
		           HelpMessage = 'Enter PS credential object name')]
		[Parameter(ParameterSetName = 'RemoteUserParamSet',
		           Mandatory = $true,
		           Position = 1,
		           HelpMessage = 'Enter PS credential object name')]
		[ValidateNotNullOrEmpty()]
		[Alias('PSCredential')]
		[pscredential]
		$Credential,
		[Parameter(ParameterSetName = 'DomainUserParamSet',
		           Mandatory = $true,
		           Position = 2,
		           HelpMessage = 'Enter the AD domain FQDN.')]
		[Alias('FQDN' ,'Domain' ,'ADDomain')]
		[String]
		$DomainFQDN
	)
	
	begin
	{
		Add-Type -AssemblyName System.DirectoryServices.AccountManagement
		if ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -gt 1))
		{
		    $ComputerName = $ComputerName -split (",")
		}
		elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -eq 1))
		{
			$ComputerName = $PSBoundParameters["ComputerName"]
		}
		
		$colResults = @()
	}
	process
	{
		foreach ($C in $ComputerName)
		{
			if ($pscmdlet.ShouldProcess($Credential, "ValidateCredential"))
			{
				$passToValidate = $Credential.GetNetworkCredential().Password
				if ($PSBoundParameters.ContainsKey('ComputerName'))
				{
					Write-Verbose -Message "Searching remote computer sAMAccountDatabase. Please wait... `n"
					$ctx = [System.DirectoryServices.AccountManagement.ContextType]::Machine
					$principalCtx = [System.DirectoryServices.AccountManagement.PrincipalContext]::new($ctx, $C)
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
					$principalCtx = [System.DirectoryServices.AccountManagement.PrincipalContext]::new($ctx, $env:COMPUTERNAME)
					$UserIDToValidate = $Credential.GetNetworkCredential().UserName
				}
				Write-Verbose -Message "Testing credential. Please wait... `n"
				$result = $principalCtx.ValidateCredentials($UserIDToValidate, $passToValidate)
				$colResults += $result
			}
		}
	}
	end
	{
		return $colResults
	}
}#end function Test-Credential