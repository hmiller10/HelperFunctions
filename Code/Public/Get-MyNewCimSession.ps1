function global:Get-MyNewCimSession
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('fnNew-CimSession')]
	[OutputType([Microsoft.Management.Infrastructure.CimSession])]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
		[ValidateNotNullorEmpty()]
		[String[]]$ServerName,
		[Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 1)]
		[System.Management.Automation.PSCredential]$Credential
	)

	begin
	{
		$ServerName = $ServerName -split (",")
		
		$so = New-CimSessionOption -Protocol Dcom

		<#
			NOTE: Reasons to use 'Negotiate' instead of Kerberos authentication:
			Peer-to-Peer Network: maybe you are not working in a network domain and want to test-drive remote access in a lab, or at home in your private network. Kerberos requires a network domain.
			Cross-Domain: maybe the target computer belongs to a different domain, and there are no trust relationships. Kerberos requires trust relationships.
			IP Address: or maybe you must use IP addresses. Kerberos requires computer names.
		#>

		$Params = @{
			Authentication = 'Negotiate'
			ErrorAction    = 'Stop'
			ErrorVariable  = 'CIMSessionError'
		}

		if (($PSBoundParameters.ContainsKey('Credential')) -and ($null -ne ($PSBoundParameters["Credentail"])))
		{
			$Params.Add('Credential', $Credential)
		}
	}
	process
	{
		foreach ($Server in $ServerName)
		{
			$Params.Add('ComputerName', $Server)
			if ((Test-WSMan -ComputerName $Server -ErrorAction SilentlyContinue).productversion -match 'Stack: ([3-9]|[1-9][0-9]+)\.[0-9]+')
			{
				try
				{
					Write-Verbose -Message ("Attempting connection to {0} using the default protocol." -f $Server)
					New-CimSession @Params
					if ($CIMSessionError.Count)
					{
						Write-Warning -Message "Unable to connect to $Server"
					}
				}
				catch
				{
					$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
					Write-Error -Message $errorMessage -ErrorAction Continue
				}
			}
			else
			{
				$Params.Add('SessionOption', $so)

				try
				{
					Write-Verbose -Message "Attempting connection to $Server using DCOM."
					New-CimSession @Params
				}
				catch
				{
					$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
					Write-Error -Message $errorMessage -ErrorAction Continue
				}
				$Params.Remove('SessionOption')
			}

			$Params.Remove('ComputerName')
		}
	}
	End {}
} #end Get-MyNewCimSession