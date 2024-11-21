BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-IsInstalled Tests, all should pass
Describe 'It should have parameter' {

	It "Test-IsInstalled should have a parameter Program" {
		Get-Command Test-IsInstalled | Should -HaveParameter -ParameterName Program -Type System.String -Mandatory
	}
}

Describe 'Test-IsInstalled function output' {
	It "Should be of type [bool]" {
		$Program = "Github Desktop"
		$result = Test-IsInstalled -Program $Program
		$result | Should -BeOfType [bool]
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}