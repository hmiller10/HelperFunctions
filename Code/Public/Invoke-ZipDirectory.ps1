Function global:Invoke-ZipDirectory
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	[CmdletBinding()]
	Param
	(
		
		[Parameter(Mandatory = $true,
				 Position = 0,
				 ValueFromPipeline = $true,
				 HelpMessage = 'Name of archive file to create.')]
		[String]$ZipFileName,
		[Parameter(Mandatory = $true,
				 Position = 1,
				 ValueFromPipeline = $true,
				 HelpMessage = 'Name of directory containing files to zip.')]
		[String]$SourceDirectory
		
	)
	
	Begin
	{
		$Net45Check = Get-ChildItem "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" | Get-ItemPropertyValue -Name Release | ForEach-Object { $_ -ge 378389 }
		if ($Net45Check)
		{
			Add-Type -AssemblyName "System.IO.Compression", "System.IO.Compression.FileSystem"
		}
		else
		{
			Write-Warning ".NET 4.5 or later is required. Please install a compatible version before attempting further operations."
		}
		$CompressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
	}
	Process
	{
		[System.IO.Compression.ZipFile]::CreateFromDirectory($SourceDirectory, $ZipFileName, $CompressionLevel, $false)
	}
	End
	{
		If ($?)
		{
			Write-Output  ("{0} was successfully zipped from {1}" -f $ZipFileName, $SourceDirectory)
		}
	}
} #End function Invoke-ZipDirectory