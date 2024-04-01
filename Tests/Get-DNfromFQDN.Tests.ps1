BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }

	#$ComputerFQDN = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	$ComputerFQDN = "computer1.my.domain.com"
}

Describe 'Get-DNfromFQDN' {

	Context "Return Get-DNfromFQDN" {
		# Get-DNfromFQDN Tests, all should pass

		It "Get-DNfromFQDN should have parameter DomainFQDN." {
			Get-Command Get-DNfromFQDN | Should -HaveParameter FQDN -Type String -Mandatory -Because "Function must have object FQDN to process."
			Get-Command Get-DNfromFQDN | Should -Not -BeNullOrEmpty
		}

		It "Should be of type [System.String]" {
			$result = Get-DNfromFQDN -FQDN $ComputerFQDN
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}