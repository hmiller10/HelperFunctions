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
				 Position = 0)]
		[ValidateNotNullOrEmpty()]
		$Path,
		[Parameter(Mandatory = $true,
				 Position = 1)]
		[ValidateNotNullOrEmpty()]
		$Value
	)
	
	begin{}
	process
	{
		try
		{
			Get-ItemProperty -Path $Path -Name $Value -ErrorAction Stop | Out-Null
			return $true
		}
		catch
		{
			return $false
		}
	}
	end {}
} #End function Test-RegistryValue