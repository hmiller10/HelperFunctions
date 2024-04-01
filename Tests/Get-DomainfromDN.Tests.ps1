BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error)
	{
		$Error.Clear()

		[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
	}
}

Describe 'Get-DomainfromDN' {

	Context "Return Get-DomainfromDN" {
		# Get-DomainfromDN Tests, all should pass

		It "Get-DomainfromDN should have parameter DistinguishedName." {
			Get-Command Get-DomainfromDN | Should -HaveParameter DistinguishedName -Type String -Mandatory
		}

		It "Should be of type [System.String]" {
			$result = Get-DomainfromDN -DistinguishedName $ComputerDN
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}