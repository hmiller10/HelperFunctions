BeforeAll {
	if ($Error) { $Error.Clear() }
	Import-Module -Name HelperFunctions -Force
}

Describe "Test-IsAdmin" {
	Context "when function Test-IsAdmin is called" {
		It "should return $True" {
			Get-Command -Name Test-IsAdmin -Module HelperFunctions | Should -Be $True -Because "Test must run with elevated rights."
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}