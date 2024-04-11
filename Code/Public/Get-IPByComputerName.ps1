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
				 Position = 1)]
		[Switch]$IPV6only,
		[Parameter(Mandatory = $false,
				 Position = 2)]
		[Switch]$IPV4only
	)

	Begin
	{
		Write-Verbose "`n Checking IP Address . . .`n"
	}
	Process
	{
		foreach ($Computer in $ComputerName)
		{
			Try
			{
				$AddressList = @(([net.dns]::GetHostEntry($Computer)).AddressList)
			}
			Catch
			{
				Write-Error "Cannot determine the IP Address on $($Computer)"
			}

			IF ($AddressList.Count -ne 0)
			{
				$AddressList | ForEach-Object {
					IF ($PSBoundParameters.ContainsKey('IPV6only'))
					{
						IF ($_.AddressFamily -eq "InterNetworkV6")
						{
							New-Object PSObject -Property @{
								IPAddress = $_.IPAddressToString
								ComputerName = $HostName
							} | Select-Object -Property ComputerName, IPAddress
						}
					}
					IF ($PSBoundParamters.ContainsKey('IPV4only'))
					{
						IF ($_.AddressFamily -eq "InterNetwork")
						{
							New-Object PSObject -Property @{
								IPAddress = $_.IPAddressToString
								ComputerName = $HostName
							} | Select-Object -Property ComputerName, IPAddress
						}
					}
					IF (-Not($PSBoundParameters.ContainsKey('IPv4Only')) -or ($PSBoundParameters.ContainsKey('IPv6Only')))
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