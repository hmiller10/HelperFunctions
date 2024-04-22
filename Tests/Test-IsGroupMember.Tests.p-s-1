BeforeAll {
	if ($Error)
	{
		$Error.Clear()
	}
	
	[string]$Me = $env:USERNAME
	$ErrorActionPreference = 'Continue'
	$DOMAIN = [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()
}


Describe "Test-IsGroupMember" {
	
	Context "Test AD user membership in AD group" {
		# Test-IsGroupMember Tests, all should pass
		
		It "Should Have Parameter User" {
			Get-Command Test-IsGroupMember | Should -HaveParameter User -Mandatory -Type System.String
		}
		
		It "Should Have Parameter Group" {
			Get-Command Test-IsGroupMember | Should -HaveParameter Group -Mandatory -Type System.String
		}
		
		It "Should be of type [System.Boolean]" {
			if ($null -ne $DOMAIN )
			{
				$result = Test-IsGroupMember -User $Me -Group 'Administrators'
				$result | Should -Not -BeNullOrEmpty
				$result | Should -BeOfType System.Boolean
			}
		}
	}
}