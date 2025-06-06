function Get-RandomPassword
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding()]
	[OutputType([System.String])]
	Param
	(
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 Position = 0)]
		[Int32]$Length,
		[Parameter(ValueFromPipeline = $true,
				 Position = 1)]
		[Boolean]$IncludeLCase,
		[Parameter(ValueFromPipeline = $true,
				 Position = 2)]
		[Boolean]$IncludeUCase,
		[Parameter(ValueFromPipeline = $true,
				 Position = 3)]
		[Boolean]$IncludeNumbers,
		[Parameter(ValueFromPipeline = $true,
				 Position = 4)]
		[Boolean]$IncludeSpecialChar,
		[Parameter(ValueFromPipeline = $true,
				 Position = 5)]
		[Boolean]$NoSimilarCharacters
	)

	Begin
	{
		# Validate our parameters
		If ($length -lt 10)
		{
			$exception = New-Object Exception "The minimum password length is 10"
			Throw $exception
		}
		If ($includeLCase -eq $false -and
			$includeUCase -eq $false -and
			$includeNumbers -eq $false -and
			$includeSpecialChar -eq $false)
		{
			$exception = New-Object Exception "At least one set of included characters must be specified"
			Throw $exception
		}
	}
	Process
	{
		#Available characters
		$CharsToSkip = [char]"i", [char]"l", [char]"o", [char]"1", [char]"0", [char]"I"
		$AvailableCharsForPassword = $null;
		$uppercaseChars = $null
		For ($a = 65; $a -le 90; $a++) { If ($noSimilarCharacters -eq $false -or [char][byte]$a -notin $CharsToSkip) { $uppercaseChars += ,[char][byte]$a } }
		$lowercaseChars = $null
		For ($a = 97; $a -le 122; $a++) { If ($noSimilarCharacters -eq $false -or [char][byte]$a -notin $CharsToSkip) { $lowercaseChars += ,[char][byte]$a } }
		$digitChars = $null
		For ($a = 48; $a -le 57; $a++) { If ($noSimilarCharacters -eq $false -or [char][byte]$a -notin $CharsToSkip) { $digitChars += ,[char][byte]$a } }
		$specialChars = $null
		$specialChars += [char]"=", [char]"+", [char]"_", [char]"?", [char]"!", [char]"-", [char]"#", [char]"$", [char]"*", [char]"&", [char]"@"

		$TemplateLetters = $null
		If ($includeLCase) { $TemplateLetters += "L" }
		If ($includeUCase) { $TemplateLetters += "U" }
		If ($includeNumbers) { $TemplateLetters += "N" }
		If ($includeSpecialChar) { $TemplateLetters += "S" }

		$PasswordTemplate = @()
		# Set password template, to ensure that required chars are included
		Do
		{
			$myPassTemplate = @()
			For ($loop = 1; $loop -le $length; $loop++)
			{
				$myPassTemplate += $TemplateLetters.Substring((Get-Random -Maximum $TemplateLetters.Length), 1)
			}
		}
		While ((
				(($includeLCase -eq $false) -or ($myPassTemplate -contains "L")) -and
				(($includeUCase -eq $false) -or ($myPassTemplate -contains "U")) -and
				(($includeNumbers -eq $false) -or ($myPassTemplate -contains "N")) -and
				(($includeSpecialChar -eq $false) -or ($myPassTemplate -contains "S"))) -eq $false
		)

		#$PasswordTemplate now contains an array with at least one of each included character type  (uppercase, lowercase, number and/or special)
		ForEach ($char In $myPassTemplate)
		{
			Switch ($char)
			{
				L { $Password += $lowercaseChars | Get-Random }
				U { $Password += $uppercaseChars | Get-Random }
				N { $Password += $digitChars | Get-Random }
				S { $Password += $specialChars | Get-Random }
			}
		}
	}
	End
	{
		Return $Password
	}
} #End function Get-RandomPassword