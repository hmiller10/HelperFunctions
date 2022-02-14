BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
    if ($Error) { $Error.Clear() }

	$Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
}

Describe 'Get-DNfromFQDN' {
	
	Context "Return Get-DNfromFQDN" {
		# Get-DNfromFQDN Tests, all should pass

        It "Get-DNfromFQDN should have parameter DomainFQDN." {
            Get-Command Get-DNfromFQDN | Should -HaveParameter DomainFQDN -Type String
            Get-Command Get-DNfromFQDN | Should -HaveParameter DomainFQDN -Mandatory
        }

		It "Should be of type [System.String]" {
			$result = Get-DNfromFQDN -DomainFQDN $Computer
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}