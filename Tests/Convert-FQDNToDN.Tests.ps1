BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	
	$FQDN = "my.domain.com"
}

# Convert-FQDNToDN Tests, all should pass
Describe 'Convert-FQDNToDN Parameters' {

	It "Convert-FQDNToDN should have parameter FQDN." {
		Get-Command Convert-FQDNToDN -Module HelperFunctions -CommandType Function  | Should -HaveParameter -ParameterName FQDN -Type System.String -Mandatory
	}

}

Describe 'Convert-FQDNToDN function output' {

	It "Should be of type [System.String]" {
		$result = Convert-FQDNToDN -FQDN $FQDN
		$result | Should -Not -BeNullOrEmpty
		$result | Should -ExpectedType [System.String]
	}
}

AfterAll {
	$null = $FQDN
	Remove-Module -Name HelperFunctions -Force
}