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
		[String]$ServerName,
		[Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 1)]
		[System.Management.Automation.PSCredential]$Credential
	)

	begin
	{
		$so = New-CimSessionOption -Protocol Dcom
		
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

		<#
			NOTE: Reasons to use 'Negotiate' instead of Kerberos authentication:
			Peer-to-Peer Network: maybe you are not working in a network domain and want to test-drive remote access in a lab, or at home in your private network. Kerberos requires a network domain.
			Cross-Domain: maybe the target computer belongs to a different domain, and there are no trust relationships. Kerberos requires trust relationships.
			IP Address: or maybe you must use IP addresses. Kerberos requires computer names.
		#>

		
	}
	process
	{
		$Params = @{
			ComputerName   = $ServerName
			Authentication = 'Negotiate'
			ErrorAction    = 'Stop'
			ErrorVariable  = 'CIMSessionError'
		}

		if (($PSBoundParameters.ContainsKey('Credential')) -and ($null -ne ($PSBoundParameters["Credential"])))
		{
			$Params.Add('Credential', $Credential)
		}
		
		if ((Test-WSMan -ComputerName $PSBoundParameters["ServerName"] -ErrorAction SilentlyContinue).ProductVersion -match 'Stack: ([3-9]|[1-9][0-9]+)\.[0-9]+')
		{
			try
			{
				Write-Verbose -Message "Attempting connection to $ServerName using the default protocol."
				New-CimSession @Params
				if ($CIMSessionError.Count)
				{
					Write-Warning -Message "Unable to connect to $ServerName"
				}
			}
			catch
			{
				$errorMessage = "{ 0 }: { 1 }" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
				Write-Error -Message $errorMessage -ErrorAction Continue
			}
		}
		else
		{
			$Params.Add('SessionOption', $so)

			try
			{
				Write-Verbose -Message "Attempting connection to $ServerName using DCOM."
				New-CimSession @Params
			}
			catch
			{
				$errorMessage = "{ 0 }: { 1 }" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
				Write-Error -Message $errorMessage -ErrorAction Continue
			}
			$Params.Remove('SessionOption')
		}

		$Params.Remove('ComputerName')
	}
	End {}
} #end Get-MyNewCimSession