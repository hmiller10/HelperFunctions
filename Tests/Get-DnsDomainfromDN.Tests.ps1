BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe 'Get-DnsDomainfromDN' {

	Context "Verify Get-DomainfromDN parameters" {
		# Get-DomainfromDN Tests, all should pass

		It "Get-DnsDomainfromDN should have parameter DistinguishedName." {
			Get-Command Get-DnsDomainfromDN -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName DistinguishedName -Type String
		}
	}
}

Describe 'Get-DnsDomainFromDN function output' {

	Context "Test Get-DnsDomainfromDN output" {
		BeforeAll {
			[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
		}
		
		It "Should be of type [System.String]" {
			$result = Get-DomainfromDN -DistinguishedName $ComputerDN
			$result | Should -BeOfType [System.String]
			$result | Should -Not -BeNullOrEmpty
		}
	}
}
AfterAll {
	Remove-Module -Name HelperFunctions -Force
	$null = $ComputerDN
	$null = $result
}