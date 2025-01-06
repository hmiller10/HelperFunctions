BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	$Program = "Github Desktop"
}

# Test-IsInstalled Tests, all should pass
Describe 'Test-IsInstalled parameters' {
	
	It "Test-IsInstalled should have a parameter Program" {
		Get-Command -Name Test-IsInstalled -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName Program -Type System.String -Mandatory
	}
}

Describe 'Test-IsInstalled function output' {

	It "Test-IsInstalled output should be of type [bool]" {
		
		$result = Test-IsInstalled -Program $Program
		$result | Should -BeOfType [bool]
	}
	
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}