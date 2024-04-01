function global:Get-IPByComputerName
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

	Begin
	{
		Write-Verbose "`n Checking IP Address . . .`n"
	}
	Process
	{
		$ComputerName | ForEach-Object {
			$HostName = $_

			Try
			{
				$AddressList = @(([net.dns]::GetHostEntry($HostName)).AddressList)
			}
			Catch
			{
				"Cannot determine the IP Address on $HostName"
			}

			IF ($AddressList.Count -ne 0)
			{
				$AddressList | ForEach-Object {
					IF ($IPV6only)
					{
						IF ($_.AddressFamily -eq "InterNetworkV6")
						{
							New-Object PSObject -Property @{
								IPAddress = $_.IPAddressToString
								ComputerName = $HostName
							} | Select-Object -Property ComputerName, IPAddress
						}
					}
					IF ($IPV4only)
					{
						IF ($_.AddressFamily -eq "InterNetwork")
						{
							New-Object PSObject -Property @{
								IPAddress = $_.IPAddressToString
								ComputerName = $HostName
							} | Select-Object -Property ComputerName, IPAddress
						}
					}
					IF (!($IPV6only -or $IPV4only))
					{
						New-Object PSObject -Property @{
							IPAddress = $_.IPAddressToString
							ComputerName = $HostName
						} | Select-Object -Property ComputerName, IPAddress
					}
				} #IF
			} #ForEach-Object(IPAddress)
		} #ForEach-Object(ComputerName)
	}
} #End function Get-IPByComputerName