BeforeAll {

	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	
}

# Get-DNfromFQDN Tests, all should pass
Describe 'Get-DNfromFQDN Parameters' {

	BeforeEach {
		$cmd = Get-Command -Name Get-DNfromFQDN -Module HelperFunctions -CommandType Function
	}
	
	It "Get-DNfromFQDN should have parameter DomainFQDN." {
		$cmd | Should -HaveParameter -ParameterName FQDN -Because "The function must have a secure string to process." -Mandatory
		$cmd | Should -Not -BeNullOrEmpty
		$cmd | Should -ExpectedType [System.Management.Automation.FunctionInfo]
	}

	AfterEach {
		$null = $cmd
	}
}

Describe 'Get-DNfromFQDN function output' {
		
	BeforeEach {
		$ComputerFQDN = "computer1.my.domain.com"
	}
	
	It "Get-DNfromFQDN output should be type String" {
		$result = Get-DNfromFQDN -FQDN $ComputerFQDN -ErrorAction SilentlyContinue
		$result | Should -BeOfType [System.String]
		$result | Should -Not -BeNullOrEmpty
	}
	
	AfterEach {
		$null = $ComputerFQDN
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions
}