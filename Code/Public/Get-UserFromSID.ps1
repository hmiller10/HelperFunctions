function Get-UserFromSID
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	
	[CmdletBinding()]
	[OutputType([System.Security.Principal.NTAccount])]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0,
				 HelpMessage = 'Enter the SID to query.')]
		[string]$ObjectSID
	)
	
	begin
	{
		$objSID = New-Object System.Security.Principal.SecurityIdentifier($ObjectSID)
	}
	process
	{
		$objUser = $objSID.Translate([System.Security.Principal.NTAccount])
	}
	end
	{
		$objUser.Value
	}
}