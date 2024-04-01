BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe "Test-IsAdmin" {
	Context "when function Test-IsAdmin is called" {
		It "should return $True" {
			Test-IsAdmin | Should -Be $True -Because "Test must run with elevated rights."
		}
	}
}