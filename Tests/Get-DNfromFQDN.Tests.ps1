BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	#$ComputerFQDN = "computer1.my.domain.com"
	$ComputerFQDN = [System.Net.Dns]::GetHostByName("LocalHost").HostName
}

Describe 'Get-DNfromFQDN' {
	Context "Test function parameters" {
		# Get-DNfromFQDN Tests, all should pass
		BeforeEach {
			$cmd = Get-Command -Name Get-DNfromFQDN -Module HelperFunctions -CommandType Function
		}
		
		It "Get-DNfromFQDN should have parameter DomainFQDN." {
			$cmd | Should -Not -BeNullOrEmpty
			$cmd | Should -HaveParameter FQDN -Type String -Mandatory -Because "Function must have object FQDN to process."
		}

		AfterEach {
			$null = $cmd
		}
	}

	Context "Test function output" {
		Mock Get-DNfromFQDN -MockWith {
			$result = Get-DNfromFQDN -FQDN $ComputerFQDN
		}
		
		It "Should be type String" {
			#$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType [System.String]
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions
}