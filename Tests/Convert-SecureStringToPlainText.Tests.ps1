BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-ComputerNameByIP Tests, all should pass
Describe 'Convert-SecureStringToPlainText Parameters' {
	
	It "Convert-SecureStringToPlainText should have SecureString as a mandatory parameter." {
		Get-Command -Name Convert-SecureStringToPlainText -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName SecureString -Mandatory -Because "The function must have an input to process."
	}
	
}

Describe 'Convert-SecureStringToPlainText function output' {
	
	BeforeEach {
		$securePass = ("P@ssw0rd1!!" | ConvertTo-SecureString -AsPlainText -Force)
	}
	It "Convert-SecureStringToPlainText should have output type of string." {
		$cmd = Convert-SecureStringToPlainText -SecureString $securePass
		$cmd | Should -Not -BeNullOrEmpty
		$cmd | Should -ExpectedType [System.String]
	}

	AfterEach {
		$null = $cmd = $securePass
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}