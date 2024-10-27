BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	[string]$ComputerDN = "CN=Computer1,OU=Computers,DC=my,DC=domain,DC=com"
}

Describe 'Get-DomainfromDN' {

	Context "Return Get-DomainfromDN" {
		# Get-DomainfromDN Tests, all should pass

		It "Get-DomainfromDN should have parameter DistinguishedName." {
			Get-Command Get-DomainfromDN -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName DistinguishedName -Type String
		}

		It "Should be of type [System.String]" {
			$result = Get-DomainfromDN -DistinguishedName $ComputerDN
			$result | Should -BeOfType System.String
			$result | Should -Not -BeNullOrEmpty
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
	$null = $ComputerDN
	$null = $result
}