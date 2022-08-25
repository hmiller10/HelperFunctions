function Test-RegistryValue
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
		[Switch]$PassThru
	)
	
	begin { }
	process
	{
		if ((Test-Path -Path $Path -PathType Container) -eq $true)
		{
			$Key = Get-Item -LiteralPath $Path
			if ($null -ne $Key.GetValue($Name, $null))
			{
				if ($PassThru)
				{
					Get-ItemProperty -Path $Path -Name $Name | Select-Object -ExpandProperty Name
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