function Convert-SecureStringToPlainText
{
	<#
		.EXTERNALHELP HelperFunctions-Help.xml
	#>

	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0,
				 HelpMessage = 'Enter the secure string to decrypt')]
		[ValidateNotNullOrEmpty()]
		[securestring]$SecureString
	)

	begin {}
	process {
		if ($pscmdlet.ShouldProcess($SecureString, "Reverse secure string"))
		{
			$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($SecureString)
			$result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
			[System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
		}
	}
	end {
		return $result
	}

}#end Convert-SecureStringtoPlainText