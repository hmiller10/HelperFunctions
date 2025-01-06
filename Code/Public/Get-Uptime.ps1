function global:Get-Uptime
{
<#
	.EXTERNALHELP HelperFunctions.psm1-Help.xml
		
#>
	
	[CmdletBinding()]
	[OutputType([pscustomobject])]
	param
	(
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true)]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(Mandatory = $false)]
		[System.Management.Automation.PsCredential]$Credential
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
		
		[String]$dtmFormatString = "yyyy-MM-dd HH:mm:ss"
		$ns = 'root\CIMv2'
	}
	process
	{
		foreach ($Computer in $ComputerName)
		{
			$params = @{
				ComputerName = $Computer
				NameSpace    = $ns
				ErrorAction  = 'Continue'
			}
			
			$cimParams = @{
				ServerName  = $Computer
				ErrorAction = 'Stop'
			}
			
			if ($Computer -ne $thisHost)
			{
				if (($PSBoundParameters.ContainsKey('Credential') -eq $true) -and ($null -ne $PSBoundParameters['Credential']))
				{
					$cimParams.Add('Credential', $Credential)
				}
				
				$cimS = Get-MyNewCimSession @cimParams
			}
			
			try
			{
				if ($null -ne $cimS.Name)
				{
					$params.Add('CimSession', $cimS)
				}
				
				$objOS = Get-CimInstance -ClassName Win32_OperatingSystem @params
				
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
				if ($Computer -ne $thisHost)
				{
					if (($PSBoundParameters.ContainsKey('Credential') -eq $true) -and ($null -ne $PSBoundParameters['Credential']))
					{
						$params.Add('Credential', $Credential)
					}
				}
				
				$objOS = Get-WmiObject -Class Win32_OperatingSystem @params
				if ($null -ne $objOS)
				{
					$uptimeTimespan = New-TimeSpan -Start ($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToUniversalTime() -End ($objOS.ConvertToDateTime($objOS.LocalDateTime)).ToUniversalTime()
					$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
					$lastBootupTime = ($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToString($dtmFormatString)
					$lastBootupTimeUTC = (($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToUniversalTime()).ToString($dtmFormatString)
				}
			}
		}
	}
	end
	{
		return [PSCustomObject]@{
			Computer	        = $ComputerName
			Uptime		   = $uptime
			LastBootTimeUTC   = $lastBootupTimeUTC
			LastBootTimeLocal = $lastBootupTime
		}
	}
} #End function Get-Uptime