BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}


Describe 'Test-IsInstalled' {
	
	Context "Check Test-IsInstalled Parameters" {
		# Test-IsInstalled Tests, all should pass
		
		It "Test-IsInstalled should have a parameter Program" {
			Get-Command Test-IsInstalled | Should -HaveParameter -ParameterName Program -Type System.String -Mandatory
		}
	}
	
	Context "Check Test-IsInstalled function output" {
		BeforeAll {
			$Program = "Github Desktop"
		}
		
		It "Should be of type [bool]" {
			$result = Test-IsInstalled -Program $Program
			$result | Should -BeOfType [bool]
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}