function Get-SIDforDomainUser
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml		
	#>
	
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				 Position = 0)]
		[String]$Domain,
		[Parameter(Mandatory = $true,
				 Position = 1)]
		[String]$UserName
	)
	
	begin
	{}
	process
	{
		$sid = (New-Object System.Security.Principal.NTAccount "$($Domain)\$($UserName)").Translate([System.Security.Principal.SecurityIdentifier])
	}
	end
	{
		return $sid.Value
	}
}