BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	$FQDN = "my.domain.com"
}

Describe 'Convert-FQDNToDN' {
	Context "Test Function Parameters" {
		# Convert-FQDNToDN Tests, all should pass

		It "Convert-FQDNToDN should have parameter FQDN." {
		  Get-Command Convert-FQDNToDN | Should -HaveParameter FQDN -Type String -Mandatory
		}

		It "Should be of type [System.String]" {
			$result = Convert-FQDNToDN -FQDN $FQDN
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}