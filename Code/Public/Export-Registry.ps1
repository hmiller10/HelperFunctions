function Export-Registry
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				 HelpMessage = 'Enter the path to start from, for example HKLM:SOFTWARE\Microsoft\Policies')]
		[ValidateScript({ Test-Path -Path $_ })]
		[string[]]$Path,
		[Parameter(Mandatory = $true,
				 HelpMessage = 'Enter the path where the registry key should be exported to.')]
		[System.IO.FileInfo]$OutputFile
	)

	begin
	{
		[PSObject[]]$regObject = @()
		if ($OutputFile.Extension -eq '.xlsx')
		{
			try
			{
				Import-Module -Name ImportExcel -Force -ErrorAction Stop
			}
			catch
			{
				try
				{
					$moduleName = 'ImportExcel'
					$ErrorActionPreference = 'Stop';
					$module = Get-Module -ListAvailable | Where-Object { $_.Name -eq $moduleName };
					$ErrorActionPreference = 'Continue';
					$modulePath = Split-Path $module.Path;
					$psdPath = "{0}\{1}" -f $modulePath, "ImportExcel.psd1"
					Import-Module $psdPath -ErrorAction Stop
				}
				catch
				{
					Write-Error "ImportExcel PS module could not be loaded. $($_.Exception.Message)" -ErrorAction SilentlyContinue
				}
			}

			if ($null -eq (Get-Module -Name ImportExcel))
			{
				Install-Module -Name ImportExcel -Repository "PSGallery" -Scope CurrentUser -Force -Confirm:$false
				Import-Module -Name ImportExcel -Force
			}
		}
	}
	process
	{
		$regKeys = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue

		foreach ($regKey in $regKeys)
		{
			foreach ($property in $regKey)
			{
				Write-Verbose ("Processing {0}" -f $property)
				foreach ($name in $regKey.Property)
				{
					try
					{
						$regObject += New-Object -TypeName PSCustomObject -Property ([ordered] @{
								Name     = $property.Name
								Property = "$($name)"
								Value    = Get-ItemPropertyValue -Path $regKey.PSPath -Name $name
								Type     = $regKey.GetValueKind($name)
							})
					}
					catch
					{
						Write-Error ("Error processing {0} in {1}" -f $property, $regKey.name) -ErrorAction Continue
					}
				}
			}
		}

		switch ($OutputFile.Extension)
		{
			".xlsx" {
				try
				{
					#Export results to path
					$params = @{
						AutoSize = $true
						BoldTopRow = $true
						FreezeTopRow = $true
						AutoFilter = $true
						Path = $OutputFile
						ErrorAction = 'Stop'
					}
					if ((Test-Path -Path $OutputFile -PathType Leaf) -eq $true)
					{
						$params.Add("Append",$true)
					}
					$regObject | Sort-Object Name, Property | Export-Excel @params
				}
				catch
				{
					Write-Error ("Unable to export results to {0}, check path and permissions" -f $OutputFile)
					return
				}
			}
			".xml" {
				try
				{
					#Export results to path
					$regObject | Sort-Object Name, Property | Export-Clixml -Path $OutputFile -Depth 99 -Force -ErrorAction Stop
				}
				catch
				{
					Write-Error ("Unable to export results to {0}, check path and permissions" -f $OutputFile)
					return
				}
			}
			".txt"{
				try
				{
					#Export results to path
					$params = @{
						FilePath = $OutputFile
						ErrorAction = 'Stop'
					}
					if ((Test-Path -Path $OutputFile -PathType Leaf) -eq $true)
					{
						$params.Add("Append",$true)
					}
					else
					{
						$params.Add("Force",$true)
					}
					$regObject | Sort-Object Name, Property | Out-FIle @params
				}
				catch
				{
					Write-Error ("Unable to export results to {0}, check path and permissions" -f $OutputFile)
					return
				}
			}
			Default {
				try
				{
					#Export results to path
					$params = @{
						Path = $OutputFile
						Encoding = 'UTF8'
						Delimiter = ";"
						NoTypeInformation = $true
						ErrorAction = 'Stop'
					}
					if ((Test-Path -Path $OutputFile -PathType Leaf) -eq $true)
					{
						$params.Add("Append",$true)
					}
					$regObject | Sort-Object Name, Property | Export-Csv @params
				}
				catch
				{
					Write-Error ("Unable to export results to {0}, check path and permissions" -f $OutputFile)
					return
				}
			}
		} #end Switch
	}
	end {}
} #end Export-Registry