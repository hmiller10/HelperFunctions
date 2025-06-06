function Get-IPByComputerName
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml		
	#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 0)]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[String[]]$ComputerName,
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 1)]
		[Switch]$IPV6only,
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 Position = 2)]
		[Switch]$IPV4only
	)
	
	begin
	{
		Write-Verbose "`n Checking IP Address . . .`n"
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
		$ComputerName | ForEach-Object {
			$HostName = $_
			
			try
			{
				$AddressList = @(([net.dns]::GetHostEntry($HostName)).AddressList)
			}
			catch
			{
				"Cannot determine the IP Address on $HostName"
			}
			
			if ($AddressList.Count -ne 0)
			{
				$AddressList | ForEach-Object {
					if ($IPV6only)
					{
						if ($_.AddressFamily -eq "InterNetworkV6")
						{
							New-Object PSObject -Property @{
								IPAddress    = $_.IPAddressToString
								ComputerName = $HostName
							} | Select-Object -Property ComputerName, IPAddress
						}
					}
					if ($IPV4only)
					{
						if ($_.AddressFamily -eq "InterNetwork")
						{
							New-Object PSObject -Property @{
								IPAddress    = $_.IPAddressToString
								ComputerName = $HostName
							} | Select-Object -Property ComputerName, IPAddress
						}
					}
					if (!($IPV6only -or $IPV4only))
					{
						New-Object PSObject -Property @{
							IPAddress    = $_.IPAddressToString
							ComputerName = $HostName
						} | Select-Object -Property ComputerName, IPAddress
					}
				} #IF
			} #ForEach-Object(IPAddress)
		} #ForEach-Object(ComputerName)
	}
	end {}
} #End function Get-IPByComputerName