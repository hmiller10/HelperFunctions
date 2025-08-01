function Invoke-ZipDirectory
{
<#
	.EXTERNALHELP HelperFunctions.psm1-Help.xml
#>

	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
	[Parameter(Mandatory = $true,
			 ValueFromPipeline = $true,
			 Position = 0)]
	[String]$ZipFileName,
	[Parameter(Mandatory = $true,
			 ValueFromPipeline = $true,
			 Position = 1)]
	[String]$SourceFolder,
	[Parameter(ValueFromPipeline = $true,
			 Position = 2)]
	[ValidateSet('Fast', '1', 'Normal', '2', 'Optimal', '0')]
	[String]$ArchiveMode
	)

	begin
	{
		try
		{
			Add-Type -Assembly System.IO.Compression.FileSystem -ErrorAction Stop
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Stop
		}

		switch ($ArchiveMode)
		{
			"Fast"{ $compressionLevel = [System.IO.Compression.CompressionLevel]::Fastest; break }
			"None"{ $compressionLevel = [System.IO.Compression.CompressionLevel]::NoCompression; break }
			default{ $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal; break }
		}
	}
	process
	{
		if ($PSCmdlet.ShouldProcess($ZipFileName,'Zipping directory'))
		{
			[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFolder, $zipFileName, $compressionLevel, $false)
		}
	}
	end
	{
	}
}#end function Invoke-ZipDirectory