BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-DnsDomainfromDN Tests, all should pass
Describe 'Get-DnsDomainfromDN should have parameter' {
	
	It "Get-DnsDomainfromDN should have parameter DistinguishedName." {
		Get-Command Get-DnsDomainfromDN -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName DistinguishedName -Type String
	}

}

Describe 'Get-DnsDomainFromDN function output' {
	
	BeforeEach {
		[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
	}
	
	It "Should be of type [System.String]" {
		
		$result = Get-DnsDomainfromDN -DistinguishedName $ComputerDN
		$result | Should -Not -BeNullOrEmpty
	}
	
	AfterEach {
		$null = $ComputerDN
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}