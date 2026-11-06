function Get-WinComputerUptime
{
	<#
		.EXTERNALHELP HelperFunctions-Help.xml
	#>

	[CmdletBinding(DefaultParameterSetName = 'ComputerParamSet',
	               SupportsShouldProcess = $true)]
	[OutputType([System.Object[]], ParameterSetName='ComputerParamSet')]
	[OutputType([System.Object[]], ParameterSetName = 'CimParamSet')]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWMICmdlet', '', Justification = 'Legacy WMI cmdlet is required for this specific environment.')]
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

		begin {
		[String]$dtmFormatString = "yyyy-MM-dd HH:mm:ss"
		$ns = 'root\CIMv2'

		$params = @{
			NameSpace   = $ns
			ErrorAction = 'Stop'
		}

		$results = New-Object -TypeName System.Collections.Generic.List[pscustomobject] -ErrorAction Stop
	}
	process {
		switch ($PSCmdlet.ParameterSetName) {
			"ComputerParamSet" {

				if ($PSBoundParameters.ContainsKey('ComputerName') -and ($null -ne $PSBoundParameters["ComputerName"]) -and ($PSBoundParameters["ComputerName"].Count -gt 1)) {
					$ComputerName = $ComputerName -split (",")
				} elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($null -ne $PSBoundParameters["ComputerName"]) -and ($PSBoundParameters["ComputerName"].Count -eq 1)) {
					$ComputerName = $PSBoundParameters["ComputerName"]
				} else {
					$ComputerName = [System.Net.Dns]::GetHostByName("LocalHost").HostName
				}

				$Query = "Select * from Win32_OperatingSystem"
				foreach ($Computer in $ComputerName) {
					$params.Add('ComputerName', $Computer)

					if ($PSCmdlet.ShouldProcess($Computer)) {
						try {
							$objOS = Get-CimInstance -Query $Query @params

							if ($null -ne $objOS) {
								$uptimeTimespan = New-TimeSpan -Start $objOS.LastBootUpTime.ToUniversalTime() -End $objOS.LocalDateTime.ToUniversalTime()
								$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
								$lastBootupTime = $objOS.LastBootUpTime.ToString($dtmFormatString)
								$lastBootupTimeUTC = $objOS.LastBootUpTime.ToUniversalTime().ToString($dtmFormatString)
							}
						} catch {
							if (($PSBoundParameters.ContainsKey('Credential') -eq $true) -and ($null -ne $PSBoundParameters['Credential'])) {
								$params.Add('Credential', $Credential)
							}

							try {
								$objOS = Get-WmiObject -Query $Query @params
								if ($null -ne $objOS) {
									if (($objOS.LastBootUpTime.GetType()).Name -eq "String") { $computerBootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($objOS.LastBootUpTime) }
									if (($objOS.LocalDateTime.GetType()).Name -eq "String") { $computerDateTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($objOS.LocalDateTime) }
									$uptimeTimespan = New-TimeSpan -Start $computerBootTime -End $computerDateTime
									$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
									$lastBootupTime = $objOS.LastBootUpTime.ToString($dtmFormatString)
									$lastBootupTimeUTC = $objOS.LastBootUpTime.ToUniversalTime().ToString($dtmFormatString)
								}
							} catch {
								$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
								Write-Error $errorMessage -ErrorAction Continue
							}
						}
					}

					$result += New-Object -TypeName PSCustomObject @{
						Computer	        = $Computer
						Uptime		   = $uptime
						LastBootTimeUTC   = $lastBootupTimeUTC
						LastBootTimeLocal = $lastBootupTime
					}
					
					$results.Add($result)
					$params.Remove('ComputerName')
					if ($params.ContainsKey('Credential')) {$params.Remove('Credential')}
				}
			}
			"CimParamSet" {

				for ($i = 0; $i -lt $Session.Count; $i++) {
					$params.Add('CimSession', $Session[$i])
					$Query = "Select * from CIM_OperatingSystem"

					if ($PSCmdlet.ShouldProcess($Session[$i])) {
						try {
							$objOS = Get-CimInstance -Query $Query @params

							if ($null -ne $objOS) {
								$uptimeTimespan = New-TimeSpan -Start $objOS.LastBootUpTime.ToUniversalTime() -End $objOS.LocalDateTime.ToUniversalTime()
								$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
								$lastBootupTime = $objOS.LastBootUpTime.ToString($dtmFormatString)
								$lastBootupTimeUTC = $objOS.LastBootUpTime.ToUniversalTime().ToString($dtmFormatString)
							}
						} catch {
							$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
							Write-Error -Message $errorMessage -ErrorAction Continue
						}

						$result += New-Object -TypeName PSCustomObject @{
							Computer	        = $Session[$i].ComputerName
							Uptime		   = $uptime
							LastBootTimeUTC   = $lastBootupTimeUTC
							LastBootTimeLocal = $lastBootupTime
						}
					}
					
					$results.Add($result)
					$params.Remove('CimSession')
				}
			}
		} #end Switch
	}
	end {
		return $results
	}
} #End function Get-WinComputerUptime