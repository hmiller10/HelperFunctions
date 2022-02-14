Before All {
    Import-Module -Name HelperFunctions -Force
    if ($Error) { $Error.Clear() }
}

Describe "Test-IsAdmin" {
	Context "when function Test-IsAdmin is called" {
		It "should return $True" {
			Test-IsAdmin | Should -Be $True -Because "Test must run with elevated rights."
		}
	}
}