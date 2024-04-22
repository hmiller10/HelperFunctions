function global:Test-PathExists
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding(SupportsShouldProcess = $true)]
	[Alias('Check-Path','fnCheck-Path')]
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