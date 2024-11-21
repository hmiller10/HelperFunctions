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

	It "Should be of type [System.String]" {
		[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
		$result = Get-DnsDomainfromDN -DistinguishedName $ComputerDN
		$result | Should -BeOfType [System.String]
		$result | Should -Not -BeNullOrEmpty
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}