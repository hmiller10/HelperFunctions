function Export-PSCredential
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
				PositionalBinding = $true,
				SupportsShouldProcess = $true)]
	[OutputType([System.IO.FileInfo])]
	param
	(
		[Parameter(Mandatory = $true, Position = 0,
				 HelpMessage = "Specify the filesystem path where the output file should be saved to.")]
		[string]$OutputFile,
		[Parameter(Mandatory = $true, Position = 1,
				 HelpMessage = "Specify the PSCredential object.")]
		[pscredential]$Credential
	)

	begin
	{
		$ErrorActionPreference = 'stop'
		try
		{
			$objCredential = $Credential | Select-Object *
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}
	process
	{
		if ($pscmdlet.ShouldProcess($Credential, "Create CliXML file with encrypted credentials."))
		{
			$objCredential.Password = $objCredential.Password | ConvertFrom-SecureString
		}
	}
	end
	{
		$objCredential | Export-Clixml $OutputFile -Confirm:$false
	}
}#end function Export-PSCredential