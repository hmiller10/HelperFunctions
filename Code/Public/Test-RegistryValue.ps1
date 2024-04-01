function global:Test-RegistryValue
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
	[Parameter(Mandatory = $true,
			 ValueFromPipeline = $true,
			 ValueFromPipelineByPropertyName = $true,
			 Position = 0)]
	[Alias('RegistryKey')]
	[String]$Path,
	[Parameter(Mandatory = $true,
			 Position = 1)]
	[String]$Name,
	[Parameter(Mandatory = $false,
			 Position = 2)]
	[Switch]$PassThru,
	[Parameter(Mandatory = $false,
			 Position = 3)]
	[System.Management.Automation.PSCredential]$Credential
	)

	begin { }
	process
	{
		if ((Test-Path -Path $Path -PathType Container) -eq $true)
		{
			if ($PSBoundParameters.ContainsKey("Credential"))
			{
				$Key = Get-Item -LiteralPath $Path -Credential $Credential
			}
			else
			{
				$Key = Get-Item -LiteralPath $Path
			}

			if ($null -ne $Key.GetValue($Value, $null))
			{
				if ($PSBoundParameters.ContainsKey("PassThru"))
				{
					if ($PSBoundParameters.ContainsKey("Credential"))
					{
						Get-ItemProperty -Path $Path -Name $Value -Credential $Credential
					}
					else
					{
						Get-ItemProperty -Path $Path -Name $Value
					}
				}
				else
				{
					$true
				}
			}
			else
			{
				$false
			}
		}
		else
		{
			$false
		}
	}
	end { }
} #End function Test-RegistryValue