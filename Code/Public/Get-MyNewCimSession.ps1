function Get-MyNewCimSession
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	[CmdletBinding()]
	[OutputType([Microsoft.Management.Infrastructure.CimSession])]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$ServerName,
		[Parameter(Mandatory = $true)]
		[pscredential]$Credential
	)

	begin
	{
		$VerbosePreference = 'Continue'
		$WarningPreference = 'Continue'
		
		$so = New-CimSessionOption -Protocol Dcom
		
		$Params = @{
			Authentication = 'Negotiate'
			ErrorAction    = 'Continue'
			ErrorVariable  = 'CIMSessionError'
		}
		
		if ($PSBoundParameters.ContainsKey('Credential'))
		{
			$Params.Add('Credential', $Credential)
		}
	}
	process
	{
		foreach ($server in $ServerName)
		{
			$Params.Add('ComputerName', $server)
			if ((Test-WSMan -ComputerName $Server -ErrorAction SilentlyContinue).productversion -match 'Stack: ([3-9]|[1-9][0-9]+)\.[0-9]+')
			{
				try
				{
					Write-Verbose -Message ("Attempting connection to {0} using the default protocol." -f $ServerName) -Verbose
					New-CimSession @Params
					if ($CIMSessionError.Count)
					{
						Write-Warning -Message "Unable to connect to {0}" -f $CIMSessionError.OriginInfo.PSComputerName
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
					Write-Verbose -Message ("Attempting connection to {0} using DCOM." -f $Server) -Verbose
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
	end
	{
		
	}
}