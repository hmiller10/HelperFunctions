BeforeAll {
	if ($Error)
	{
		$Error.Clear()
	}
}

Describe 'Get-DomainfromDN' {

	Context "Return Get-DomainfromDN" {
		# Get-DomainfromDN Tests, all should pass
		BeforeEach {
			[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
			$cmd = Get-Command -Name Get-DomainfromDN -Module HelperFunctions -CommandType Function
		}

		It "Get-DomainfromDN should have parameter DistinguishedName." {
			$cmd | Should -HaveParameter DistinguishedName -Type String -Mandatory
		}

		It "Should be of type [System.String]" {
			$result = Get-DomainfromDN -DistinguishedName $ComputerDN
			$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType [System.String]
		}

		AfterEach {
			$null = $ComputerDN
			$null = $cmd
		}
	}
}