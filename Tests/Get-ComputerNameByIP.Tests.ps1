BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force	
	if ($Error) { $Error.Clear() }
	
}

# Get-ComputerNameByIP Tests, all should pass
Describe 'Get-ComputerNameByIP parameters' {

	BeforeEach {
		$cmd = Get-Command -Name Get-ComputerNameByIP -Module HelperFunctions -CommandType Function
	}
	
	It "Get-ComputerNameByIP should have IPAddress as a mandatory parameter." {
		$cmd | Should -HaveParameter -ParameterName IPAddress -Because "IPAddress is required to render result."
		$cmd | Should -Not -BeNullOrEmpty
		$cmd | Should -ExpectedType [System.String]
	}
	
	AfterEach {			
		$null = $cmd
	}

}

Describe 'Get-ComputerNameByIP function output' {
	
	BeforeEach {
		$IPAddress = (Get-NetIPConfiguration -ErrorAction Stop | Where-Object { ($null -ne $_.IPv4DefaultGateway) -and ($_.NetAdapter.status -ne "Disconnected") }).IPv4Address.IPAddress
	}
	
	It "Get-ComputerNameByIP output should return a string value" {
		$result = Get-ComputerNameByIP -IPAddress $IPAddress -ErrorAction SilentlyContinue
		$result | Should -Not -BeNullOrEmpty
		$result | Should -BeOfType [System.String]
	}
	
	AfterEach {
		$null = $result
		$null = $IPAddress
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}