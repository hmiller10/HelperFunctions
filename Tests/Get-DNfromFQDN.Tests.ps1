BeforeAll {

	if ($Error) { $Error.Clear() }
	$ComputerFQDN = "computer1.my.domain.com"
	#$ComputerFQDN = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	
}

Describe 'Get-DNfromFQDN' {

	Context "Return Get-DNfromFQDN" {
		# Get-DNfromFQDN Tests, all should pass
		BeforeEach {
			$cmd = Get-Command -Name Get-DNfromFQDN -Module HelperFunctions -CommandType Function
		}
		
		It "Get-DNfromFQDN should have parameter DomainFQDN." {
			#$cmd | Should -Not -BeNullOrEmpty
			$cmd | Should -HaveParameter FQDN -Type String -Mandatory -Because "Function must have object FQDN to process."
		}

		It "Should be type String" {
			$result = Get-DNfromFQDN -FQDN $ComputerFQDN
			$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType [System.String]
		}

		AfterEach {
			$null = $ComputerFQDN
			$null = $cmd
		}
	}
}