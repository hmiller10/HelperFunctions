Function Get-Uptime
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	
	[CmdletBinding()]
	[OutputType([pscustomobject])]
	Param
	(
		[Parameter(Mandatory = $false)]
		[string]$ComputerName,
		[Parameter(Mandatory = $false)]
		[System.Management.Automation.PsCredential]$Credential
	)
	
	Begin
	{
		#Enable TLS 1.2
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		
		[String]$dtmFormatString = "yyyy-MM-dd HH:mm:ss"
		$ns = 'root\CIMv2'
	}
	Process
	{
		$params = @{
			NameSpace    = $ns
			ErrorAction  = 'Continue'
		}
		
		If (($PSBoundParameters.ContainsKey('ComputerName') -eq $true) -and ($PSBoundParameters['ComputerName'] -ne $null))
		{
			$params.Add('ComputerName', $ComputerName)
		}
		Else
		{
			$ComputerName = [System.Net.Dns]::GetHostByName("LocalHost").HostName
		}
		
		If (($PSBoundParameters.ContainsKey('Credential') -eq $true) -and ($PSBoundParameters['Credential'] -ne $null))
		{
			$params.Add('Credential', $Credential)
		}
		
		Try
		{
			$objOS = Get-CimInstance -ClassName Win32_OperatingSystem @params
			
			If ($null -ne $objOS)
			{
				$uptimeTimespan = New-TimeSpan -Start $objOS.LastBootUpTime.ToUniversalTime() -End $objOS.LocalDateTime.ToUniversalTime()
				$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
			    $lastBootupTime = $objOS.LastBootUpTime.ToString($dtmFormatString)
				$lastBootupTimeUTC = $objOS.LastBootUpTime.ToUniversalTime().ToString($dtmFormatString)
			}
		}
		Catch
		{
			$objOS = Get-WmiObject -Class Win32_OperatingSystem @params
			If ($null -ne $objOS)
			{
				$uptimeTimespan = New-TimeSpan -Start ($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToUniversalTime() -End ($objOS.ConvertToDateTime($objOS.LocalDateTime)).ToUniversalTime()
				$uptime = New-Object System.TimeSpan($uptimeTimespan.Days, $uptimeTimespan.Hours, $uptimeTimespan.Minutes, $uptimeTimespan.Seconds)
				$lastBootupTime = ($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToString($dtmFormatString)
				$lastBootupTimeUTC = (($objOS.ConvertToDateTime($objOS.LastBootUpTime)).ToUniversalTime()).ToString($dtmFormatString)
			}
		}
	}
	End
	{
		Return [PSCustomObject]@{
			Computer	        = $ComputerName
			Uptime		   = $uptime
			LastBootTimeUTC   = $lastBootupTimeUTC
			LastBootTimeLocal = $lastBootupTime
		}
	}
} #End function Get-Uptime