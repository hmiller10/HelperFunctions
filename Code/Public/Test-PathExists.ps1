function global:Test-PathExists
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0)]
		[String]$Path,
		[Parameter(Mandatory = $true,
				 Position = 1)]
		[Object]$PathType
	)
	
	Begin
	{
		$VerbosePreference = 'Continue';
	}
	
	Process
	{
		Switch ($PathType)
		{
			File
			{
				If ((Test-Path -Path $Path -PathType Leaf) -eq $true)
				{
					Write-Output ("File: {0} already exists..." -f $Path)
				}
				Else
				{
					Write-Verbose -Message ("File: {0} not present, creating new file..." -f $Path)
					[System.IO.File]::Create($Path)
				}
			}
			Folder
			{
				If ((Test-Path -Path $Path -PathType Container) -eq $true)
				{
					Write-Output ("Folder: {0} already exists..." -f $Path)
				}
				Else
				{
					Write-Verbose -Message ("Folder: {0} not present, creating new folder..." -f $Path)
					[System.IO.Directory]::CreateDirectory($Path)
					
				}
			}
		}
	}
	
	End { }
	
}#end function Test-PathExists