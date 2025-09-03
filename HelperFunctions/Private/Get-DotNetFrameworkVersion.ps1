function Get-DotNetFrameworkVersion
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml
		#>
	[CmdletBinding()]
	[OutputType([pscustomobject])]
	param
	(
		[Parameter(Mandatory = $false,
				 Position = 0)]
		[String]$ComputerName = $env:COMPUTERNAME
	)

	Begin
	{
		$dotNetRegistry = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP'
		[PSObject[]]$objVersions = @()

	}
	Process
	{
		foreach ($Computer in $ComputerName)
		{
			$netVersions = Get-ChildItem -Path $dotNetRegistry -Recurse | Get-ItemProperty -Name Version -EA 0 | Where-Object { $_.PSChildName -Match '^(?!S)\p{L}' } | Select-Object PSChildName, Version
			If ($netVersions.Count -ge 1)
			{
				ForEach ($netVersion In $netVersions)
				{
					$objVersions += New-Object -TypeName PSCustomObject -Property ([Ordered] @{
							ComputerName = $Computer
							NetFXVersion = $netVersion.Version
						}) | Select-Object ComputerName, NetFXVersion
				}

			}
			else
			{
				$objVersions += New-Object -TypeName PSCustomObject -Property ([Ordered] @{
					ComputerName = $Computer
					NetFXVersion = "Error retrieving information."
				}) | Select-Object ComputerName, NetFXVersion
			}
		}
	}
	end
	{
		return $objVersions
	}
}#end function Get-DotNetFrameworkVersion