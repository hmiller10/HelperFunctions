function global:Test-IsGroupMember
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>
		
	[CmdletBinding()]
	param
	(
	[Parameter(Mandatory = $true,
			 Position = 0,
			 HelpMessage = 'Enter User sAMAccountName')]
	[ValidateNotNullOrEmpty()]
	[String]$User,
	[Parameter(Mandatory = $true,
			 Position = 1,
			 HelpMessage = 'Enter the AD group name in sAMAccountName format')]
	[ValidateNotNullOrEmpty()]
	[Alias('grp','Grp')]
	[String]$Group
	)
	
	begin
	{
		$strFilter = "(&(objectClass=Group)(name=" + $Group + "))"
		$objDomain = New-Object System.DirectoryServices.DirectoryEntry
		$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
	}
	process
	{
		$objSearcher.SearchRoot = $objDomain
		$objSearcher.PageSize = 1000
		$objSearcher.Filter = $strFilter
		$objSearcher.SearchScope = "Subtree"
		
		$colResults = $objSearcher.FindOne()
		
		$objItem = $colResults.Properties
	}
	end
	{
		([string]$objItem.member).contains($User)
	}
} #end function Test-IsGroupMember