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
	}
	
	process
	{
		switch ($PathType)
		{
			File
			{
				if ((Test-Path -Path $Path -PathType Leaf) -eq $true)
				{
					Write-Output ("File: {0} already exists..." -f $Path)
				}
				else
				{
					Write-Verbose -Message ("File: {0} not present, creating new file..." -f $Path)
					if ($PSCmdlet.ShouldProcess($Path, "Create file"))
					{
						[System.IO.File]::Create($Path)
					}
				}
			}
			Folder
			{
				if ((Test-Path -Path $Path -PathType Container) -eq $true)
				{
					Write-Output ("Folder: {0} already exists..." -f $Path)
				}
				else
				{
					Write-Verbose -Message ("Folder: {0} not present, creating new folder..." -f $Path)
					if ($PSCmdlet.ShouldProcess($Path, "Create folder"))
					{
						[System.IO.Directory]::CreateDirectory($Path)
					}
					
					
				}
			}
		}
	}
	
	end { }
	
}#end function Test-PathExists