BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-FQDNfromDN Tests, all should pass
Describe 'Get-FQDNfromDN parameters' {

	It "Get-FQDNfromDN should have parameter DistinguishedName." {
		Get-Command Get-FQDNfromDN | Should -HaveParameter -ParameterName DistinguishedName -Mandatory
	}

}

Describe 'Get-FQDNfromDN function output' {

	BeforeEach {
		[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
	}
	
	It "Get-FQDNfromDN output should be of type [System.String]" {
		$result = Get-FQDNfromDN -DistinguishedName $ComputerDN #-ErrorAction SilentlyContinue
		$result | Should -Not -BeNullOrEmpty
		$result | Should -ExpectedType [System.String]
	}
	
	AfterEach {
		$null = $ComputerDN
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}