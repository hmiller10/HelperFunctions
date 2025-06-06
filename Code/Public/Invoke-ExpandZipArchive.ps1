function Invoke-ExpandZipArchive
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[Alias('Expand-ZipArchive')]
	param
	(
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 HelpMessage = 'Name of archive file to expand.')]
		[String]$ZipFileName,
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 HelpMessage = 'Name of directory to decompress archive into.')]
		[String]$DestinationDirectory
	)

	begin
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
	}
	process
	{
		[System.IO.Compression.ZipFile]::ExtractToDirectory($ZipFileName, $DestinationDirectory)
	}
	end
	{}
} #End function Invoke-ExpandZipArchive