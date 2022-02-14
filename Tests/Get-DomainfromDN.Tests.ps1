BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
    if ($Error) { $Error.Clear()

	$Computer = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
}

Describe 'Get-DomainfromDN' {
	
	Context "Return Get-DomainfromDN" {
		# Get-DomainfromDN Tests, all should pass

        It "Get-DomainfromDN should have parameter DistinguishedName." {
            Get-Command Get-DomainfromDN | Should -HaveParameter DistinguishedName -Type String
            Get-Command Get-DomainfromDN | Should -HaveParameter DistinguishedName -Mandatory
        }

		It "Should be of type [System.String]" {
			$result = Get-DomainfromDN -DistinguishedName $Computer
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}