BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	. $PSCommandPath.Replace('.Tests.ps1','.ps1')
	
}

Describe 'Convert-SecureStringToPlainText' {

	Context "Convert-SecureStringToPlainText is called, it must have parameter SecureString" {
		# Get-ComputerNameByIP Tests, all should pass
		BeforeEach {
			$cmd = Get-Command -Name Convert-SecureStringToPlainText -Module HelperFunctions -CommandType Function
			$securePass = ("P@ssw0rd1!!" | ConvertTo-SecureString -AsPlainText -Force)
		}

		It "Convert-SecureStringToPlainText should have SecureString as a mandatory parameter." {
			$cmd | Should -HaveParameter -ParameterName SecureString -Because "The function must have a secure string to process."
			$cmd | Should -Not -BeNullOrEmpty
		}

        It "Convert-SecureStringToPlainText should have output type of string." {
			$cmd | Should -BeOfType PSCustomObject
		}

		AfterEach {
			$null = $securePass
			$null = $cmd
		}
	}
}

AfterAll {
    Remove-Module -Name HelperFunctions -Force
}