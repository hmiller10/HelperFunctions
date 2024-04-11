BeforeAll {
	if ($Error) { $Error.Clear() }
}

Describe 'Get-IPByComputerName' {

	Context "When Get-IPByComputerName is called" {
		# Get-ComputerNameByIP Tests, all should pass
		BeforeEach {
			$Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
			$cmd = Get-Command -Name Get-IPByComputerName -Module HelperFunctions -CommandType Function
		}

		It "Get-IPByComputerName should have parameter ComputerName" {
			$cmd | Should -HaveParameter ComputerName -BeOfType [String] -Mandatory -Because "If IP address is valid it should return the assigned device."
			$cmd | Should -Not -BeNullOrEmpty
		}

		It "Get-IPByComputerName should return the IP address of the computer passed into the function" {
			$result = Get-IPByComputerName -ComputerName $Computer -ErrorAction Stop
			$result | Should -BeOfType [PSCustomObject] -Because "A networked computer object should have an IP address."
			$result | Should -Not -BeNullOrEmpty -Because "Cannot resolve an IP address if the computer name is invalid."
		}

		AfterEach {
			$null = $Computer
			$null = $cmd
		}
	}
}