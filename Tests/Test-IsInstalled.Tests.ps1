BeforeAll {
	Import-Module -Name HelperFunctions -Force -ErrorAction Stop
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}


Describe 'Test-IsInstalled' {
	
	Context "Program installation verification" {
		BeforeAll {
			$Program = "Github Desktop"
		}
		# Test-IsInstalled Tests, all should pass
		
		It "Test-IsInstalled should have a parameter Program" {
			Get-Command Test-IsInstalled | Should -HaveParameter -ParameterName Program -Type System.String -Mandatory -Because "Test cannot succeed without input parameter to test."
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