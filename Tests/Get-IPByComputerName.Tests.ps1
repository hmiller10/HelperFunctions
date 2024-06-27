BeforeAll {
	if ($Error) { $Error.Clear() }
	$Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
}

Describe 'Get-IPByComputerName' {
	Context "When Get-IPByComputerName is called" {
		# Get-ComputerNameByIP Tests, all should pass
		It "Get-IPByComputerName should have parameter ComputerName" {
			Get-Command -Name Get-IPByComputerName -ComputerName $Computer -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName ComputerName
		}
	}
	Context "Test Get-IPByComputerName output" {
		It "Get-IPByComputerName should return the IP address of the computer passed into the function" {
			
			$result = Get-IPByComputerName -ComputerName $Computer -ErrorAction Stop
			$result | Should -BeOfType PSCustomObject -Because "A networked computer object should have an IP address."
			$result | Should -Not -BeNullOrEmpty -Because "Cannot resolve an IP address if the computer name is invalid."
		}
	}
}

AfterAll {
	#Remove-Module -Name HelperFunctions -Force
}