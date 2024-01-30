function global:Invoke-CreateZipFile
{
<#
	.EXTERNALHELP HelperFunctions.psm1-Help.xml
		
#>
	
	[CmdletBinding()]
	param
	(
	[Parameter(Mandatory = $true)]
	[String]$CompressedFileName,
	[Parameter(Mandatory = $true)]
	[String]$FileToCompress,
	[Parameter(Mandatory = $true)]
	[String]$EntryName,
	[Parameter(Mandatory = $true)]
	[ValidateSet('Create', 'Read', 'Update')]
	[String]$ArchiveMode
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
		$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
	}
	process
	{
		switch ($ArchiveMode)
		{
			"Create" { $objCompressedFile = [System.IO.Compression.ZipFile]::Open($CompressedFileName, [System.IO.Compression.ZipArchiveMode]::Create) }
			"Read" { $objCompressedFile = [System.IO.Compression.ZipFile]::Open($CompressedFileName, [System.IO.Compression.ZipArchiveMode]::Read) }
			"Update" { $objCompressedFile = [System.IO.Compression.ZipFile]::Open($CompressedFileName, [System.IO.Compression.ZipArchiveMode]::Update) }
		}
		
		$archiveEntry = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($objCompressedFile, $FileToCompress, $EntryName, $compressionLevel)
	}
	end
	{
		$objCompressedFile.Dispose()
	}
} #End function Invoke-CreateZipFile