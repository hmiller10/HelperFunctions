function global:Test-PathExists
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml		
	#>
	
	
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0,
				 HelpMessage = 'Type the file system where the folder or file to check should be verified.')]
		[string]$Path,
		[Parameter(Mandatory = $true,
				 Position = 1,
				 HelpMessage = 'Specify path content as file or folder')]
		[string]$PathType
	)
	
	begin
	{
		$VerbosePreference = 'Continue';
		try
		{
			Add-Type -AssemblyName "System.IO.FileSystem" -ErrorAction Stop	
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Stop
		}
	}
	
	process
	{
		switch ($PSBoundParamterts["PathType"])
		{
			File
			{
				if (([System.IO.File]::Exists($Path)) -eq $false)
				{
					Write-Verbose -Message ("File: {0} not present, creating new file..." -f $Path)
					if ($PSCmdlet.ShouldProcess($Path, "Create file"))
					{
						[System.IO.File]::Create($Path)
					}
					
				}
				else
				{
					Write-Output ("File: {0} already exists..." -f $Path)
				}
			}
			Folder
			{
				if (([System.IO.Directory]::Exists($Path)) -eq $false)
				{
					Write-Verbose -Message ("Folder: {0} not present, creating new folder..." -f $Path)
					if ($PSCmdlet.ShouldProcess($Path, "Create folder"))
					{
						[System.IO.Directory]::CreateDirectory($Path)
					}
					
				}
				else
				{
					Write-Output ("Folder: {0} already exists..." -f $Path)
				}
			}
		}
	}
	
	end { }
	
}#end function Test-PathExists