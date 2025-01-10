﻿function global:Get-Uptime
{
<#
	.EXTERNALHELP HelperFunctions.psm1-Help.xml
		
#>
	
	[CmdletBinding(DefaultParameterSetName = 'ComputerParamSet',
	               SupportsShouldProcess = $true)]
	[OutputType([pscustomobject], ParameterSetName='ComputerParamSet')]
	[OutputType([pscustomobject], ParameterSetName='CimParamSet')]
	param
	(
		[Parameter(ParameterSetName = 'ComputerParamSet',
		           Mandatory = $false,
		           ValueFromPipeline = $true,
		           ValueFromPipelineByPropertyName = $true,
		           HelpMessage = 'Enter the FQDN of the computer to get uptime for')]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[ValidateNotNullOrEmpty()]
		[string[]]
		$ComputerName,
		[Parameter(ParameterSetName = 'ComputerParamSet',
		           Mandatory = $false,
		           HelpMessage = 'Enter the name of the PS credential object')]
		[ValidateNotNullOrEmpty()]
		[System.Management.Automation.PsCredential]
		[System.Management.Automation.Credential()]
        	$Credential = [System.Management.Automation.PSCredential]::Empty,
		[Parameter(ParameterSetName = 'CimParamSet',
		           Mandatory = $true,
		           HelpMessage = 'Enter the CimSession variable name')]
		[ValidateNotNullOrEmpty()]
		[Alias ('CimSession')]
		[Microsoft.Management.Infrastructure.CimSession[]]
		$Session
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
		
		[String]$dtmFormatString = "yyyy-MM-dd HH:mm:ss"
		$ns = 'root\CIMv2'
		
		$params = @{
			NameSpace    = $ns
			ErrorAction  = 'Continue'
		}
		
		$results = @()
	}
	process
	{
		switch ($PSCmdlet.ParameterSetName)
		{
			"ComputerParamSet" {
				
				if ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -gt 1))
				{
					$ComputerName = $ComputerName -split (",")
				}
				elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -eq 1))
				{
					$ComputerName = $PSBoundParameters["ComputerName"]
				}
				else
				{
					$ComputerName = [System.Net.Dns]::GetHostByName("LocalHost").HostName
				}

				$Query = "Select * from Win32_OperatingSystem"
				foreach ($Computer in $ComputerName)
				{
					$params.Add('ComputerName', $Computer)

					if ($PSCmdlet.ShouldProcess($Computer))
					{
						try
						{
							$objOS = Get-CimInstance -Query $Query @params
							
							if ($null -ne $objOS)
							{
								$uptimeTimespan = New-TimeSpan -Start $objOS.LastBootUpTime.ToUniversalTime() -End $objOS.LocalDateTime.ToUniversalTime()
								$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
								$lastBootupTime = $objOS.LastBootUpTime.ToString($dtmFormatString)
								$lastBootupTimeUTC = $objOS.LastBootUpTime.ToUniversalTime().ToString($dtmFormatString)
							}
						}
						catch
						{
							if (($PSBoundParameters.ContainsKey('Credential') -eq $true) -and ($null -ne $PSBoundParameters['Credential']))
							{
								$params.Add('Credential', $Credential)
							}
							
							$objOS = Get-WmiObject -Query $Query @params
							if ($null -ne $objOS)
							{
								$uptimeTimespan = New-TimeSpan -Start ($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToUniversalTime() -End ($objOS.ConvertToDateTime($objOS.LocalDateTime)).ToUniversalTime()
								$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
								$lastBootupTime = ($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToString($dtmFormatString)
								$lastBootupTimeUTC = (($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToUniversalTime()).ToString($dtmFormatString)
							}
						}
					}
					
					$result = [PSCustomObject]@{
						Computer	        = $Computer
						Uptime		   = $uptime
						LastBootTimeUTC   = $lastBootupTimeUTC
						LastBootTimeLocal = $lastBootupTime
					}
					
					$results += $result
					
					$params.Remove('ComputerName')
				}
			}
			"CimParamSet" {
				
				for ($i = 0; $i -lt $Session.Count; $i++)
				{
					Write-Output ("Session Name is: {0}" -f $Session[$i].Name)
					$params.Add('CimSession', $Session[$i])
					$Query = "Select * from CIM_OperatingSystem"
				
					if ($PSCmdlet.ShouldProcess($Session[$i]))
					{
						try
						{
							$objOS = Get-CimInstance -Query $Query @params
							
							if ($null -ne $objOS)
							{
								$uptimeTimespan = New-TimeSpan -Start $objOS.LastBootUpTime.ToUniversalTime() -End $objOS.LocalDateTime.ToUniversalTime()
								$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
								$lastBootupTime = $objOS.LastBootUpTime.ToString($dtmFormatString)
								$lastBootupTimeUTC = $objOS.LastBootUpTime.ToUniversalTime().ToString($dtmFormatString)
							}
						}
						catch
						{
							$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
							Write-Error -Message $errorMessage -ErrorAction Continue
						}
						
						$result = [PSCustomObject]@{
							Computer	        = $Session[$i].ComputerName
							Uptime		   = $uptime
							LastBootTimeUTC   = $lastBootupTimeUTC
							LastBootTimeLocal = $lastBootupTime
						}
						
						$results += $result
					}
					$params.Remove('CimSession')
				}
				
			}
		} #end Switch
	}
	end
	{
		return $results
	}
} #End function Get-Uptime