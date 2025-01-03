BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-ComputerNameByIP Tests, all should pass
Describe 'Convert-SecureStringToPlainText Parameters' {
	
	It "Convert-SecureStringToPlainText should have SecureString as a mandatory parameter." {
		Get-Command -Name Convert-SecureStringToPlainText -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName "SecureString" -Because "The function must have a secure string to process." -Mandatory
	}
	
}

Describe 'Convert-SecureStringToPlainText function output' {
	
	BeforeEach {
		$securePass = ("P@ssw0rd1!!" | ConvertTo-SecureString -AsPlainText -Force)
	}
	It "Convert-SecureStringToPlainText should have output type of string." {
		$cmd = Convert-SecureStringToPlainText -SecureString $securePass #-ErrorAction SilentlyContinue
		$cmd | Should -BeOfType PSCustomObject
		$cmd | Should -Not -BeNullOrEmpty
	}

	AfterEach {
		$null = $cmd
		$null = $securePass
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}