BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-IsAdmin Tests, all should pass
Describe "Test-IsAdmin" {

	It 'Test-IsAdmin should return $True' {
		Get-Command -Name Test-IsAdmin -Module HelperFunctions | Should -Be $True -Because "Test must run with elevated rights."
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}