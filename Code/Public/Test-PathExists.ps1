function Test-PathExists
{
<#
	.SYNOPSIS
		Checks if a path to a file or folder exists, and creates it if it does not exist.
	
	.DESCRIPTION
		This function examines the contents of the 'Path' variable for the presence of the file or folder string that has been passed into the function.
		
		If no file or folder exists, the function creates it.
	
	.PARAMETER Path
		File or Folder path
	
	.PARAMETER PathType
		Specify whether the 'Path' variable is a file or folder.
	
	.PARAMETER Force
		Force the creation of the folder structure in the $Path variable.
	
	.EXAMPLE
		PS C:\> .\Test-PathExists.ps1 -Path 'Value1'
	
	.OUTPUTS

	.NOTES
		THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
		THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>
	
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
		           Position = 0,
		           HelpMessage = 'Type the file system where the folder or file to check should be verified.')]
		[string]
		$Path,
		[Parameter(Mandatory = $true,
		           Position = 1,
		           HelpMessage = 'Specify path content as file or folder')]
		[string]
		$PathType,
		[Parameter(Mandatory = $false,
		           Position = 2,
		           HelpMessage = 'Force create folder or file')]
		[Switch]
		$Force
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
					if ($PSBoundParameters.ContainsKey('Force'))
					{
						try
						{
							Write-Verbose -Message "File: $Path not present, creating new file..."
							if ($PSCmdlet.ShouldProcess($Path,"Create new file"))
							{
								New-Item -Path $Path -ItemType File -Force -Confirm:$false -ErrorAction Stop
							}
							else
							{
								New-Item -Path $Path -ItemType File -Force -WhatIf -ErrorAction Stop
							}
							
						}
						catch
						{
							$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
							Write-Error $errorMessage -ErrorAction Continue
						}
					}
					else
					{
						try
						{
							Write-Verbose -Message "File: $Path not present, creating new file..."
							if ($PSCmdlet.ShouldProcess($Path,"Create new file"))
							{
								New-Item -Path $Path -ItemType File -Confirm:$false -ErrorAction Stop
							}
							else
							{
								New-Item -Path $Path -ItemType File -WhatIf -ErrorAction Stop
							}
						}
						catch
						{
							$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
							Write-Error $errorMessage -ErrorAction Continue
						}	
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
					if ($PSBoundParameters.ContainsKey('Force'))
					{
						try
						{
							if ($PSCmdlet.ShouldProcess($Path,"Create new folder"))
							{
								mkdir $Path
							}
							Write-Verbose -Message "Folder: $Path not present, creating new folder."
						}
						catch
						{
							$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
							Write-Error $errorMessage -ErrorAction Continue
						}
					}
					else
					{
						try
						{
							if ($PSCmdlet.ShouldProcess($Path,"Create new folder"))
							{
								New-Item -Path $Path -ItemType Directory -Confirm:$false
								Write-Verbose -Message "Folder: $Path not present, creating new folder."
							}
							else
							{
								New-Item -Path $Path -ItemType Directory -WhatIf
							}
						}
						catch
						{
							$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
							Write-Error $errorMessage -ErrorAction Continue
						}
					}
				}
			}
		}
	}
	
	end { }
}#end function Test-PathExists