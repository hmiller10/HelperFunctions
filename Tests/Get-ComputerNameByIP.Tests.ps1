BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force	
	if ($Error)
	{
		$Error.Clear()
	}
	
}

Describe 'Get-ComputerNameByIP' {

	Context "Get-ComputerNameByIP is called, it must have parameter IPAddress" {
		# Get-ComputerNameByIP Tests, all should pass
		BeforeEach {
			$cmd = Get-Command -Name Get-ComputerNameByIP -Module HelperFunctions -CommandType Function
			$IPAddress = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Namespace 'root\CIMv2' -Filter "IPEnabled = 'True'" | Where { $_.DefaultIPGateway -ne $null } | Select-Object -Property IPAddress).IPAddress
			[IPAddress]$IPAddress = $IPAddress[0]
		}
		It "Get-ComputerNameByIP should have IPAddress as a mandatory parameter." {
			$cmd | Should -HaveParameter IPAddress -Because "IPAddress is required to render result."
			$cmd | Should -Not -BeNullOrEmpty
		}

		It "Should return a string value" {
			$result = Get-ComputerNameByIP -IPAddress $IPAddress
			$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType [System.String]
		}

		AfterEach {
			$null = $IPAddress
			$null = $cmd
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}