BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-IsInstalled Tests, all should pass
Describe 'Test-IsInstalled parameters' {
	
	BeforeEach {
		$Program = "Github Desktop"
	}
	
	It "Test-IsInstalled should have a parameter Program" {
		Get-Command Test-IsInstalled | Should -HaveParameter -ParameterName Program -Type System.String -Mandatory
	}
	
	AfterEach {
		$null = $Program
	}
}

Describe 'Test-IsInstalled function output' {
	
	BeforeEach {
		$Program = "Github Desktop"
	}
	
	It "Test-IsInstalled output should be of type [bool]" {
		
		$result = Test-IsInstalled -Program $Program
		$result | Should -BeOfType [bool]
	}
		
	AfterEach {
		$null = $Program
	}
	
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}