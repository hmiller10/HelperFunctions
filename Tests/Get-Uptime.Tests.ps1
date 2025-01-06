BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-Uptime Tests, all should pass
Describe 'Get-Uptime parameter tests' {
	
	BeforeEach {
		$cmd = Get-Command -Name Get-UpTime -Module HelperFunctions -CommandType Function
	}
	
	It 'Get-Uptime should have parameter ComputerName' {
		$cmd | Should -HaveParameter -ParameterName ComputerName
	}
	
	It ' Get-Uptime should have parameter Credential' {
		$cmd | Should -HaveParameter -ParameterName Credential
	}
	
	AfterEach {
		$null = $cmd
	}
}

Describe 'Get-Uptime function output' {

	It 'Get-Uptime should be of type [PSCustomObject]' {
		$result = Get-Uptime
		$result | Should -Not -BeNullOrEmpty
		$result | Should -ExpectedType [PSCustomObject]
	}
}

AfterAll {
	$null = $result
	Remove-Module -Name HelperFunctions -Force
}