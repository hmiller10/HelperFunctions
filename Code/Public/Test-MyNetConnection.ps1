function global:Test-MyNetConnection
{
<#
	.EXTERNALHELP HelperFunctions.psm1-Help.xml
		
#>
	
	[CmdletBinding()]
	[Alias('fnTest-NetConnection')]
	param
	(
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 0)]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[String[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(Mandatory = $true,
				 Position = 1)]
		[int32]$Port
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
		
	}
	process
	{
		foreach ($C in $ComputerName)
		{
			try
			{
				Test-NetConnection -ComputerName $C -Port $Port
			}
			catch
			{
				$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
				Write-Error $errorMessage -ErrorAction Continue
			}
		}
		
		
	}
	end
	{ }
}#end function Test-MyNetConnection