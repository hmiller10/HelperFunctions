#Requires -Module CimCmdlets
function global:Invoke-Shutdown
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>
	
	[CmdletBinding(SupportsShouldProcess = $true)]
	[OutputType([int])]
	param
	(
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 HelpMessage = 'Provide the FQDN of the computer you wish to shut down')]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[ValidateScript({
				$ComputerName | ForEach-Object {
					if ((Test-NetConnection -ComputerName $_ -CommonTCPPort WINRM -ErrorAction SilentlyContinue).TcpTestSucceeded -eq $true)
					{
						return $true
					}
					else
					{
						Write-Error "Cannot connect to $_."
					}
				}
			})]
		[ValidateNotNullOrEmpty()]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(Mandatory = $true,
				 HelpMessage = 'Select the Shutdown Type.')]
		[ValidateSet('Logoff', 'Shutdown', 'Reboot', 'PowerOff')]
		[ShutdownType]$ShutdownType,
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Add this switch to force a reboot or shutdown or logoff')]
		[switch]$Force,
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Enter the $Timeout value in seconds')]
		[uint32]$Wait,
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Enter the reason for this action')]
		[Alias('Message')]
		[string]$Comment = "A remote shutdown was initiated by $([Environment]::UserName).",
		[Parameter(Mandatory = $true,
				 HelpMessage = 'Enter a valued value from within the NOTES section')]
		[ShutDown_MajorReason]$MajorReasonCode,
		[Parameter(Mandatory = $true,
				 HelpMessage = 'Enter the Minor value from the NOTES section')]
		[ShutDown_MinorReason]$MinorReasonCode,
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Select this switch if this was an unplanned action')]
		[switch]$Unplanned,
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Specify administrator credentials for the computer.')]
		[System.Management.Automation.PsCredential]$Credential
	)
	
	begin
	{
		$ns = 'root\CIMv2'
		
		if ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -gt 1))
		{
			$ComputerName = $ComputerName -split (",")
		}
		elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -eq 1))
		{
			$ComputerName = $PSBoundParameters["ComputerName"]
		}
		
		if ($PSBoundParameters.ContainsKey('Force'))
		{
			$Flags = ([ShutDownType]$ShutdownType).value__ + 4
		}
		else
		{
			$Flags = ([ShutDownType]$ShutdownType).value__
		}
		
		$PlannedReasonCode = (0x80000000) * -1
		if ($PSBoundParameters.ContainsKey('Unplanned'))
		{
			$ReasonCode = $MajorReasonCode.value__ + $MinorReasonCode.value__
		}
		else
		{
			$ReasonCode = $MajorReasonCode.value__ + $MinorReasonCode.value__ + $PlannedReasonCode
		}
		
		$params = @{
			Flags	 = $Flags
			Comment    = $Comment
			ReasonCode = $ReasonCode
		}
		
		if ($PSBoundParameters.ContainsKey("Wait"))
		{
			$params.Add("Timeout", $Wait)
		}
		else
		{
			$params.Add("Timeout", [uint32]30)
		}
		
	}
	process
	{
		foreach ($computer in $ComputerName)
		{
			try
			{
				Write-Verbose ("Testing Connection to {0}..." -f $computer)
				
				$tcParams = @{
					ComputerName = $computer
					Count	   = 1
					Quiet	   = $true
				}
				
				if (($PSBoundParameters.ContainsKey("Credential")) -and ($null -ne $PSBoundParameters["Credential"])) { $tcParams.Add("Credential", $Credential) }
				if ((Test-Connection @tcParams) -eq $true)
				{
					
					if ($computer -eq ([System.Net.Dns]::GetHostByName("LocalHost").HostName))
					{
						try
						{
							try
							{
								$osParams = @{
									Class		     = "Win32_OperatingSystem"
									Namespace		     = $ns
									EnableAllPrivileges = $true
									ErrorAction	     = 'Stop'
								}
								
								if (($PSBoundParameters.ContainsKey("Credential")) -and ($null -ne $PSBoundParameters["Credential"])) { $osParams.Add("Credential", $Credential) }
								$OS = Get-WmiObject $osParams
								if ($PSCmdlet.ShouldProcess($computer, "Execute shutdown/reboot process on $($computer)"))
								{
									$result = $OS.Win32ShutdownTracker($Timeout, $Comment, $ReasonCode, $Flags)
								}
								
							}
							catch
							{
								$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
								Write-Error $errorMessage -ErrorAction Continue
							}
							
							if ($PSBoundParameters.ContainsKey('Verbose'))
							{
								switch ($result.ReturnValue)
								{
									
									0 {
										Write-Verbose "$($MyInvocation.InvocationName) on $computer processed successfully."
									}
									1190 {
										Write-Verbose "$($MyInvocation.InvocationName) on $computer returned error code 1190. A system shutdown has already been scheduled."
									}
									1191 {
										Write-Verbose "$($MyInvocation.InvocationName) on $computer returned error code 1191.  A user is still logged into the system.  Use the -Force parameter if necessary."
									}
									default {
										Write-Verbose "$($MyInvocation.InvocationName) on $computer returned error code $result.  System Error Codes can be found here:  https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes"
									}
									
								}
							}
							
							return $result.ReturnValue
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
							if (($PSBoundParameters.ContainsKey('Credential')) -and ($null -ne $PSBoundParameters["Credential"]))
							{
								$session = New-CimSession -ComputerName $computer -Credential $Credential -Authentication Negotiate -SkipTestConnection -ErrorAction Stop
							}
							else
							{
								$session = New-CimSession -ComputerName $computer -SkipTestConnection -ErrorAction Stop
							}
							
						}
						catch
						{
							try
							{
								Write-Information ("Unable to connect to {0} using WSMan, attempting to use DCOM protocol instead" -f $computer)
								if (($PSBoundParameters.ContainsKey('Credential')) -and ($null -ne $PSBoundParameters["Credential"]))
								{
									$session = New-CimSession -ComputerName $computer -Credential $Credential -Authentication Negotiate -SessionOption (New-CimSessionOption -Protocol Dcom) -SkipTestConnection -ErrorAction Stop
								}
								else
								{
									$session = New-CimSession -ComputerName $computer -SessionOption (New-CimSessionOption -Protocol Dcom) -SkipTestConnection -ErrorAction Stop
								}
							}
							catch
							{
								$errorMessage = "Unable to connect to {0} with WSMan or DCOM protocols" -f $computer
								Write-Error -Message $errorMessage -ErrorAction Continue
							}
						}
						
						if ($null -ne $session.Name)
						{
							try
							{
								$OS = Get-CimInstance -ClassName Win32_OperatingSystem -Namespace $ns -CimSession $session -ErrorAction Stop
								
								if ($PSCmdlet.ShouldProcess($computer, "Execute shutdown method on $($computer)"))
								{
									if ($PSBoundParameters.ContainsKey('Force'))
									{
										Invoke-CimMethod -CimInstance $OS -MethodName Win32ShutdownTracker -Arguments $params -CimSession $session
										if ($? -eq $true)
										{
											$result = "0"
											if ($result -eq 0)
											{
												[PSCustomObject]@{
													ComputerName = $computer
													ShutdownType = $ShutdownType
													ReasonCode   = "$($MajorReasonCode): $MinorReasonCode"
													CommandSuccessful = $true
												}
											}
										}
									}
									else
									{
										$result = (Invoke-CimMethod -CimInstance $OS -MethodName Win32ShutdownTracker -Arguments $params -CimSession $session).ReturnValue
										if ($result -eq 0)
										{
											[PSCustomObject]@{
												ComputerName = $computer
												ShutdownType = $ShutdownType
												ReasonCode   = "$($MajorReasonCode): $MinorReasonCode"
												CommandSuccessful = $true
											}
										}
									}
								}
								
							}
							catch
							{
								$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
								Write-Error $errorMessage -ErrorAction Continue
							}
							
							Remove-CimSession -CimSession $session
						}
						
					}
					
				}
				else
				{
					Write-Error ("{0} is not currently available.  No shutdown request processed" -f $computer) -Category ConnectionError -ErrorVariable +connectionErrors
					return -1
				}
				
			}
			catch [System.Management.Automation.MethodInvocationException]
			{
				
				Write-Verbose "Generic Failure may be caused if 'ShutdownType' of 'Logoff' was used and no users were logged in at the time."
				Write-Error $_
				return -2
				
			}
			catch
			{
				
				Write-Verbose "Error Type is $($_.Exception.GetType().FullName)"
				Write-Error $_
				return -256
				
			}
			
		}
		
	}
	end
	{
		Write-Verbose ("Invoke-Shutdown processing complete.  There were {0} connection errors." -f $connectionErrors.Count)
	}
} #end Invoke-Shutdown