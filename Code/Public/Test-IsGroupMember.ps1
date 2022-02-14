function global:Test-IsGroupMember
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$user,
		[Parameter(Mandatory = $true)]
		$grp
	)
	
	begin
	{
		$strFilter = "(&(objectClass=Group)(name=" + $grp + "))"
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
		([string]$objItem.member).contains($user)
	}
	
} #end function Test-IsGroupMember