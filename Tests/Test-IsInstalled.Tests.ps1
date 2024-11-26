BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-IsInstalled Tests, all should pass
Describe 'Test-IsInstalled parameters' {
	
	Context "Test-IsInstalled Parameter Validation" {
		It "Test-IsInstalled should have a parameter Program" {
			Get-Command Test-IsInstalled | Should -HaveParameter -ParameterName Program -Mandatory
		}
	}
	
}

Describe 'Test-IsInstalled function output' {
	
	Context "Test-IsInstalled output" {
		
		BeforeEach {
			$Program = "Github Desktop"
		}
		
		It "Test-IsInstalled output should be of type [bool]" {
			
			$result = Test-IsInstalled -Program $Program -ErrorAction SilentlyContinue
			$result | Should -BeOfType [bool]
		}
		
		AfterEach {
			$null = $Program
		}
	}
	
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}