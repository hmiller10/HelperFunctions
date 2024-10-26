﻿BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error)
	{
		$Error.Clear()
	}
	
	[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
}

Describe 'Get-FQDNfromDN' {

	Context "Return Get-FQDNfromDN" {
		# Get-FQDNfromDN Tests, all should pass

        It "Get-FQDNfromDN should have parameter DistinguishedName." {
            Get-Command Get-FQDNfromDN | Should -HaveParameter DistinguishedName -Type String -Mandatory
        }

		It "Should be of type [System.String]" {
			$result = Get-FQDNfromDN -DistinguishedName $ComputerDN
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}