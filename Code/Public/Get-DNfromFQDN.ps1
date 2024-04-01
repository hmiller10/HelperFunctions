function global:Get-DNfromFQDN
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[OutputType([String])]
	param
	(
	[Parameter(Mandatory = $true,
			 ValueFromPipeline = $false,
			 Position = 0,
			 HelpMessage = 'Enter the fully qualified domain name to convert')]
	[ValidateNotNullOrEmpty()]
	[string]$FQDN,
	[Parameter(Position = 1,
			 HelpMessage = 'Enter the name of PS credential object')]
	[ValidateNotNullOrEmpty()]
	[pscredential]$Credential
	)

	begin
	{
		$Error.Clear()
		try
		{
			Import-Module -Name ActiveDirectory -Force -ErrorAction Stop
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}
	process
	{
		foreach ($index in $FQDN)
		{
			$Dot = $index.IndexOf('.')
			$Object = [pscustomobject]@{
				Hostname = $index.Substring(0, $Dot)
				Domain   = $index.Substring($Dot + 1)
			}

		}

		if (($PSBoundParameters.ContainsKey("Credential")) -and ($null -ne $PSBoundParameters["Credential"]))
		{
			try
			{
				$DN = Get-ADObject -Identity $Object.HostName -Properties distinguishedName -Server $Object.Domain -Credential $Credential -ErrorAction Stop | Select-Object -ExpandProperty distinguishedName
			}
			catch
			{
				$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
				Write-Error $errorMessage -ErrorAction Continue
			}
		}
		else
		{
			try
			{
				$DN = Get-ADObject -Identity $Object.HostName -Properties distinguishedName -Server $Object.Domain -ErrorAction Stop | Select-Object -ExpandProperty distinguishedName
			}
			catch
			{
				$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
				Write-Error $errorMessage -ErrorAction Continue
			}
		}

	}
	end
	{
		if ($null -ne $DN)
		{
			return $DN
		}
	}

} #End function Get-DNfromFQDN