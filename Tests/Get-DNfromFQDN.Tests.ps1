BeforeAll {
	if ($Error) { $Error.Clear() }
	$ComputerFQDN = "computer1.my.domain.com"
	#$ComputerFQDN = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	#Import-Module -Name ActiveDirectory -Force
}

Describe 'Get-DNfromFQDN' {
	Context "Test function parameters" {
		# Get-DNfromFQDN Tests, all should pass
		
		It "Get-DNfromFQDN should have parameter DomainFQDN." {
			Get-Command -Name Get-DomainDNfromFQDN -FQDN $ComputerFQDN -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName FQDN
			Get-Command -Name Get-DomainDNfromFQDN -FQDN $ComputerFQDN -Module HelperFunctions -CommandType Function | Should -Not -BeNullOrEmpty
		}
	}
	
	Context "When Get-DNfromFQDN is called" {
		It "Should return the object DN" {
			$result = Get-DNfromFQDN -FQDN $ComputerFQDN
			$result | Should -BeOfType System.String
			$result | Should -Not -BeNullOrEmpty
		}
	}
}

AfterAll {
	$null = $result
	#Remove-Module -Name ActiveDirectory
}