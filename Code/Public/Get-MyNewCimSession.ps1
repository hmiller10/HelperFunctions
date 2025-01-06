function global:Get-MyNewCimSession
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>
	[CmdletBinding()]
	[Alias('fnNew-CimSession')]
	[OutputType([Microsoft.Management.Infrastructure.CimSession])]
	param
	(
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 0,
				 HelpMessage = 'Enter the name of the computer to establish the CimSession to.')]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[ValidateNotNullOrEmpty()]
		[String[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(Mandatory = $false,
				 Position = 1,
				 HelpMessage = 'Enter the name of the PS credential object.')]
		[System.Management.Automation.PSCredential]$Credential,
		[Parameter(Mandatory = $false,
				 Position = 2,
				 HelpMessage = 'Switch statement to enable SkipTestConnection Parameter when starting new CimSession.')]
		[switch]$SkipICMPCheck
	)
	
	begin
	{
		# Enable TLS 1.2 and 1.3
		try
		{
			#https://docs.microsoft.com/en-us/dotnet/api/system.net.securityprotocoltype?view=netcore-2.0#System_Net_SecurityProtocolType_SystemDefault
			if ($PSVersionTable.PSVersion.Major -lt 6 -and [Net.ServicePointManager]::SecurityProtocol -notmatch 'Tls12')
			{
				Write-Verbose -Message 'Adding support for TLS 1.2'
				[Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls12
			}
		}
		catch
		{
			Write-Warning -Message 'Adding TLS 1.2 to supported security protocols was unsuccessful.'
		}
		
		$localComputer = Get-CimInstance -ClassName CIM_ComputerSystem -Namespace 'root\CIMv2' -ErrorAction SilentlyContinue
		$thisHost = "{0}.{1}" -f $localComputer.Name, $localComputer.Domain
		
		if (($localComputer.Caption -match "Windows 11") -eq $true)
		{
			try
			{
				#https://docs.microsoft.com/en-us/dotnet/api/system.net.securityprotocoltype?view=netcore-2.0#System_Net_SecurityProtocolType_SystemDefault
				if ($PSVersionTable.PSVersion.Major -lt 6 -and [Net.ServicePointManager]::SecurityProtocol -notmatch 'Tls13')
				{
					Write-Verbose -Message 'Adding support for TLS 1.3'
					[Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls13
				}
			}
			catch
			{
				Write-Warning -Message 'Adding TLS 1.3 to supported security protocols was unsuccessful.'
			}
		}
		elseif (($localComputer.Caption -match "Server 2022") -eq $true)
		{
			try
			{
				#https://docs.microsoft.com/en-us/dotnet/api/system.net.securityprotocoltype?view=netcore-2.0#System_Net_SecurityProtocolType_SystemDefault
				if ($PSVersionTable.PSVersion.Major -lt 6 -and [Net.ServicePointManager]::SecurityProtocol -notmatch 'Tls13')
				{
					Write-Verbose -Message 'Adding support for TLS 1.3'
					[Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls13
				}
			}
			catch
			{
				Write-Warning -Message 'Adding TLS 1.3 to supported security protocols was unsuccessful.'
			}
		}
		
		if ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -gt 1))
		{
			$ComputerName = $ComputerName -split (",")
		}
		elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -eq 1))
		{
			$ComputerName = $PSBoundParameters["ComputerName"]
		}
		
		$so = New-CimSessionOption -Protocol Dcom
		
		<#
			NOTE: Reasons to use 'Negotiate' instead of Kerberos authentication:
			Peer-to-Peer Network: maybe you are not working in a network domain and want to test-drive remote access in a lab, or at home in your private network. Kerberos requires a network domain.
			Cross-Domain: maybe the target computer belongs to a different domain, and there are no trust relationships. Kerberos requires trust relationships.
			IP Address: or maybe you must use IP addresses. Kerberos requires computer names.
		#>
		
		$Params = @{
			Authentication = 'Negotiate'
			ErrorAction    = 'Stop'
			ErrorVariable  = 'CimSessionError'
		}
		
		if (($PSBoundParameters.ContainsKey('Credential')) -and ($null -ne ($PSBoundParameters["Credential"])))
		{
			$Params.Add('Credential', $Credential)
		}
		
		if ($PSBoundParameters.ContainsKey('SkipICMPCheck'))
		{
			$Params.Add('SkipTestConnection', $True)
		}
	}
	process
	{
		foreach ($Server in $ComputerName)
		{
			$Params.Add('ComputerName', $Server)
			if ((Test-WSMan -ComputerName $Server -ErrorAction SilentlyContinue).productversion -match 'Stack: ([3-9]|[1-9][0-9]+)\.[0-9]+')
			{
				try
				{
					Write-Verbose -Message ("Attempting connection to {0} using the default protocol." -f $Server)
					New-CimSession @Params
					if ($CIMSessionError.Count)
					{
						Write-Warning -Message ("Unable to connect to {0}" -f $Server)
					}
				}
				catch
				{
					$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
					Write-Error -Message $errorMessage -ErrorAction Continue
				}
			}
			else
			{
				$Params.Add('SessionOption', $so)
				
				try
				{
					Write-Verbose -Message ("Attempting connection to {0} using DCOM." -f $Server)
					New-CimSession @Params
				}
				catch
				{
					$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
					Write-Error -Message $errorMessage -ErrorAction Continue
				}
				$Params.Remove('SessionOption')
			}
			
			$Params.Remove('ComputerName')
		}
	}
	end { }
} #end Get-MyNewCimSession