function Invoke-CreateZipFile
{
	<#
		.EXTERNALHELP HelperFunctions-Help.xml
	#>

	[CmdletBinding(SupportsShouldProcess = $true)]
	[Alias('Create-ZipFile')]
	[OutputType([System.IO.Compression.ZipArchiveEntry])]
	param
	(
		[Parameter(Mandatory = $true)]
		[String]
		$CompressedFileName,
		[Parameter(Mandatory = $true)]
		[String]
		$FileToCompress,
		[String]
		$EntryName,
		[Parameter(Mandatory = $true)]
		[ValidateSet('Create', 'Read', 'Update')]
		[String]
		$ArchiveMode
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

		if ($PSCmdlet.ShouldProcess($CompressedFileName))
		{
			try
			{
				[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($objCompressedFile, $FileToCompress, $EntryName, $compressionLevel)
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
		$objCompressedFile.Dispose()
	}
} #End function Invoke-CreateZipFile