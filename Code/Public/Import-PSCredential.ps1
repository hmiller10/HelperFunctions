function global:Import-PSCredential
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
				PositionalBinding = $true,
				SupportsShouldProcess = $true)]
	[OutputType([pscredential])]
	param
	(
		[Parameter(Mandatory = $true, Position = 0,
				 HelpMessage = "Enter the filesystem path to the CliXML file.")]
		[ValidateScript({ Test-Path $_ })]
		[string[]]$Path
	)

	begin
	{
		try
		{
			$objCredential = Import-Clixml -Path $Path -ErrorAction 'Stop'
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
	}
	process
	{
		if ($pscmdlet.ShouldProcess($Path, "Create PSCredential from $Path file."))
		{
			$objCredential.Password = $objCredential.Password | ConvertTo-SecureString
			$Credential = New-Object System.Management.Automation.PSCredential($objCredential.UserName, $objCredential.Password)
		}
	}
	end
	{
		return $Credential
	}
}#end function Import-PSCredential