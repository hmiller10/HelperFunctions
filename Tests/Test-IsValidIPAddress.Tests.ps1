BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	[string]$IP = "10.0.0.1"
}


Describe "Test-IsValidIPAddress" {
	
	Context "Test function parameter" {
		BeforeEach {
			$cmd = Get-Command -Name Test-IsValidIPAddress -Module HelperFunctions -CommandType Function
		}
		
		It "Should have a parameter named IP" {
			$cmd | Should -HaveParameter -ParameterName IP
		}

		AfterEach {
			$null = $cmd
		}
	}

	Context "Test IP address parameter to validate type" {
		# Test-IsValidIPAddress Tests, all should pass
		BeforeEach {
			$result = Test-IsValidIPAddress -IP $IP
		}

		It "Should return $true" {
			$result | Should -Be -ExpectedValue $true
		}

		It "Should not return $null" {
			$result | Should -Not -Be $null
		}

		AfterEach {
			$null = $result
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
	$null = $IP
}