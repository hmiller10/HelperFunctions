BeforeAll {
	Import-Module -Name HelperFunctions -Force
	if ($Error)
	{
		$Error.Clear()
	}
	
	[string]$Me = $env:USERNAME
	[string]$Group = "Administrators"
}


Describe "Test-IsGroupMember" {
	
	Context "Test AD user membership in AD group" {
		# Test-IsGroupMember Tests, all should pass
		
		It "Should Have Parameter User" {
			Get-Command Test-IsGroupMember | Should -HaveParameter -ParameterName User -Mandatory -Type System.String
		}
		
		It "Should Have Parameter GroupName" {
			Get-Command Test-IsGroupMember | Should -HaveParameter -ParameterName GroupName -Mandatory -Type System.String
		}

		It "Should be of type [System.Boolean]" {
			$result = Test-IsGroupMember -User $Me -GroupName $Group
			$result | Should -Not -BeNullOrEmpty
			$result | Should -Not -Be $false
			$result | Should -Be $true
		} 
	}
}

AfterAll {
	$null = $Me
	$null = $Group
	Remove-Module -Name HelperFunctions -Force
}