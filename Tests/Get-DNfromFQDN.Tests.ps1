BeforeAll {

	if ($Error) { $Error.Clear() }
	#$ComputerFQDN = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	
}

Describe 'Get-DNfromFQDN' {

	Context "Return Get-DNfromFQDN" {
		# Get-DNfromFQDN Tests, all should pass
		BeforeEach {
			$ComputerFQDN = "computer1.my.domain.com"
		}
		
		It "Get-DNfromFQDN should have parameter DomainFQDN." {
			Get-Command Get-DNfromFQDN | Should -Not -BeNullOrEmpty
			Get-Command Get-DNfromFQDN | Should -HaveParameter FQDN -Type String -Mandatory -Because "Function must have object FQDN to process."
		}

		It "Should be of type [System.String]" {
			$result = Get-DNfromFQDN -FQDN $ComputerFQDN
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}