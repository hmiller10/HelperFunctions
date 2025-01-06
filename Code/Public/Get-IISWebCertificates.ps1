function global:Get-IISWebCertificates
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[OutputType([pscustomobject])]
	param
	(
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Enter list of computer(s)')]
		[Alias('CN', 'Computer', 'ServerName', 'Server', 'IP', 'WebServers')]
		[string[]]$ComputerName,
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 HelpMessage = 'Enter credentials')]
		[ValidateNotNull()]
		[Alias('Creds')]
		[System.Management.Automation.PSCredential][System.Management.Automation.Credential()]
		$Credential
	)

	begin
	{
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


		$localComputer = Get-CimInstance -ClassName CIM_ComputerSystem -Namespace 'root\CIMv2' -Property *
		$fqdn = "{0}.{1}" -f $localComputer.DnsHostName, $localComputer.Domain

		if ($ComputerName.Count -gt 1)
		{
			$ComputerName = $ComputerName -split ','
		}
		elseif ($ComputerName.Count -eq 1)
		{
			$ComputerName = $PSBoundParameters["ComputerName"]
		}
	}
	process
	{
		foreach ($Computer in $ComputerName)
		{

			if ($Computer -ne $fqdn)
			{
				$Params = @{
					ComputerName = $Computer
					ErrorAction  = 'Stop'
				}

				if ($PSBoundParameters.ContainsKey('Credential') -and ($null -ne $PSBoundParameters["Credential"]))
				{
					$Params.Add('Credential', $Credential)
				}

				try
				{
					Invoke-Command @Params -ScriptBlock {
						try
						{
							Import-Module -Name WebAdministration -Force -ErrorAction Stop
						}
						catch
						{
							try
							{
								Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1 -ErrorAction Stop
							}
							catch
							{
								throw "WebAdministration module could not be loaded. $($_.Exception.Message)"
							}

						}

						try
						{
							$SSLBindings = Get-ChildItem IIS:SSLBindings | Sort-Object thumbprint -unique
						}
						catch
						{
							$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
							Write-Error $errorMessage -ErrorAction Continue
						}

						if ($SSLBindings.Count -ge 1)
						{
							try
							{
								$SSLBindings | Foreach-Object {
									$cert = Get-ChildItem Cert:\LocalMachine\My | `
									Where-Object thumbprint -Match $_.thumbprint | `
									Select-Object Issuer, SignatureAlgorithm, PublicKey, Subject, SerialNumber, NotBefore, NotAfter
									[PSCustomObject]@{
										Site		        = $_.sites.value
										CertificateHash   = $_.thumbprint
										Subject		   = $cert.Subject
										Serial		   = $cert.SerialNumber
										NotBefore	        = $cert.NotBefore
										NotAfter	        = $cert.NotAfter
										CertDaysRemaining = (New-TimeSpan -Start (Get-Date) -End $cert.NotAfter).Days
										Issuer		   = $cert.Issuer
										KeyLength	        = $cert.PublicKey.Key.Length
										SignatureAlgorithm = $cert.SignatureAlgorithm.FriendlyName
										CertificateKeyAlgorithm = $cert.PublicKey.Key.SignatureAlgorithm
										CertificateKeyLength = $cert.PublicKey.Key.Length
									}
								} #end foreach
							}
							catch
							{
								$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
								Write-Error $errorMessage -ErrorAction Continue
							}
						}
						else
						{
							try
							{
								[PSCustomObject]@{
									Site			         = $_.sites.value
									CertificateHash	    = "There are no certificates bound to port 443 on this site."
									Subject			    = ""
									Serial			    = ""
									NotBefore		         = ""
									NotAfter			    = ""
									CertDaysRemaining	    = ""
									Issuer			    = ""
									KeyLength		         = ""
									SignatureAlgorithm	    = ""
									CertificateKeyAlgorithm = ""
									CertificateKeyLength    = ""
								}
							}
							catch
							{
								$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
								Write-Error $errorMessage -ErrorAction Continue
							}
						}

					} #end scriptblock
				}
				catch
				{
					$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
					Write-Error $errorMessage -ErrorAction Continue
				}
			}
			else
			{
				try
				{
					Import-Module -Name WebAdministration -Force -ErrorAction Stop
				}
				catch
				{
					try
					{
						Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1 -ErrorAction Stop
					}
					catch
					{
						throw "WebAdministration module could not be loaded. $($_.Exception.Message)"
					}

				}

				try
				{
					$SSLBindings = Get-ChildItem IIS:SSLBindings | Sort-Object thumbprint -unique
				}
				catch
				{
					$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
					Write-Error $errorMessage -ErrorAction Continue
				}

				if ($SSLBindings.Count -ge 1)
				{
					$SSLBindings | Foreach-Object {
						$cert = Get-ChildItem Cert:\LocalMachine\My | `
						Where-Object thumbprint -Match $_.thumbprint | `
						Select-Object Issuer, SignatureAlgorithm, PublicKey, Subject, SerialNumber, NotBefore, NotAfter
						[PSCustomObject]@{
							Site		        = $_.sites.value
							CertificateHash   = $_.thumbprint
							Subject		   = $cert.Subject
							Serial		   = $cert.SerialNumber
							NotBefore	        = $cert.NotBefore
							NotAfter	        = $cert.NotAfter
							CertDaysRemaining = (New-TimeSpan -Start (Get-Date) -End $cert.NotAfter).Days
							Issuer		   = $cert.Issuer
							KeyLength	        = $cert.PublicKey.Key.Length
							SignatureAlgorithm = $cert.SignatureAlgorithm.FriendlyName
							CertificateKeyAlgorithm = $cert.PublicKey.Key.SignatureAlgorithm
							CertificateKeyLength = $cert.PublicKey.Key.Length
						}
					} #end foreach
				}
				else
				{
					[PSCustomObject]@{
						Site			         = $_.sites.value
						CertificateHash	    = "There are no certificates bound to port 443 on this site."
						Subject			    = ""
						Serial			    = ""
						NotBefore		         = ""
						NotAfter			    = ""
						CertDaysRemaining	    = ""
						Issuer			    = ""
						KeyLength		         = ""
						SignatureAlgorithm	    = ""
						CertificateKeyAlgorithm = ""
						CertificateKeyLength    = ""
					}
				}
			}
		} #end foreach webserver

	}
	end
	{ }
}#end function Get-IISWebCertificate