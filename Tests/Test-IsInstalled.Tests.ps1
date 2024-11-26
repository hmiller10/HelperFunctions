BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-IsInstalled Tests, all should pass
Describe 'Test-IsInstalled parameters' {
	BeforeEach {
		$cmd = Get-Command Test-IsInstalled | Should -HaveParameter -ParameterName Program
	}
	
	It "Test-IsInstalled should have Program as a mandatory parameter." {
		$cmd | Should -HaveParameter -ParameterName Program -Because "Program is required to render result." -Mandatory
		$cmd | Should -Not -BeNullOrEmpty
		$cmd | Should -ExpectedType [System.Management.Automation.FunctionInfo]
	}
	
	AfterEach {
		$null = $cmd
	}
	
}

Describe 'Test-IsInstalled function output' {
	
	Context "Test-IsInstalled output" {
		
		BeforeEach {
			$Program = "Github Desktop"
		}
		
		It "Test-IsInstalled output should be of type [bool]" {
			
			$result = Test-IsInstalled -Program $Program -ErrorAction SilentlyContinue
			$result | Should -Not -BeNullOrEmpty
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