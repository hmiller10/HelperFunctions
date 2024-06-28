BeforeAll {
	Import-Module -Name HelperFunctions -Force
	if ($Error)
	{
		$Error.Clear()
	}
	
	[string]$Me = $env:USERNAME
}


Describe "Test-IsGroupMember" {
	
	Context "Test AD user membership in AD group" {
		# Test-IsGroupMember Tests, all should pass
		
		It "Should Have Parameter User" {
			Get-Command Test-IsGroupMember | Should -HaveParameter User -Mandatory -Type System.String
		}
		
		It "Should Have Parameter GroupName" {
			Get-Command Test-IsGroupMember | Should -HaveParameter GroupName -Mandatory -Type System.String
		}

		It "Should be of type [System.Boolean]" {
			$result = Test-IsGroupMember -User $Me -GroupName 'Administrators'
			$result | Should -Not -BeNullOrEmpty
			$result | Should -Not -Be $false
			$result | Should -Be $true
		} 
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}