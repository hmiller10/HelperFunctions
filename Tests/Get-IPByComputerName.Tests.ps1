BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-ComputerNameByIP Tests, all should pass
Describe 'Get-IPByComputerName parameters' {

	It "Get-IPByComputerName should have parameter ComputerName" {
		Get-Command Get-IPByComputerName | Should -HaveParameter ComputerName -Type [System.String[]] -Mandatory -Because "If IP address is valid it should return the assigned device."
	}

}

Describe 'Get-IPByComputerName function output'{
	
	BeforeEach {
		$Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	}
	
	It "Get-IPByComputerName should return the IP address of the computer passed into the function" {
		$result = Get-IPByComputerName -ComputerName $Computer
		$result | Should -Not -BeNullOrEmpty -Because "Cannot resolve an IP address if the computer name is invalid."
		$result | Should -BeOfType [PSCustomObject]
	}
	
	AfterEach {
		$null = $Computer
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}