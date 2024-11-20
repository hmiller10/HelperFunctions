BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	#$ComputerFQDN = "computer1.my.domain.com"
	if ((Get-CimInstance -ClassName CIM_ComputerSystem -NameSpace 'root\CIMv2').partOfDomain -eq $false)
	{
		exit
	}
	else
	{
		$ComputerFQDN = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	}
	
}

Describe 'Get-DNfromFQDN' {
	Context "Test function parameters" {
		# Get-DNfromFQDN Tests, all should pass
		BeforeEach {
			$cmd = Get-Command -Name Get-DNfromFQDN -Module HelperFunctions -CommandType Function
		}
		
		It "Get-DNfromFQDN should have parameter DomainFQDN." {
			$cmd | Should -HaveParameter -ParameterName FQDN -Because "The function must have a secure string to process."
			$cmd | Should -Not -BeNullOrEmpty
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
			$result | Should -BeOfType [System.String]
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions
}