BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	
	[string]$ServerIP = '8.8.8.8'
	[string]$google = 'google.com'
	[int32]$dnsPort = 53
	[int32]$SecurePort = 443
	[int32]$Port = 80
	[string]$remoteDomain1 = 'yahoo.com'
	[string]$remoteDomain2 = 'microsoft.com'
}

Describe "Test-MyNetConnection" {
	
	Context "Test parameters" {
		It "Should have verified parameters" {
			Get-Command Test-MyNetConnection -Server $ServerIP -Port $Port -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName Server -Type System.String -Because "The function requires a destination to test."
			Get-Command Test-MyNetConnection -Server $ServerIP -Port $Port -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName Port -Type int32 -Because "This function is intended to test port connectivity."
		}
	}

	Context "Testing network connectivity and parameters" {
		It "Should resolve DNS name 'google.com'" {
			$result = Test-MyNetConnection -Server $google -Port $SecurePort
			$result | Should -Not -BeNullOrEmpty
			$result.TcpTestSucceeded | Should -Be $true
		}
	}
	
	Context "Testing specific ports" {
		It "Should check if port 80 (HTTP) is open on yahoo.com" {
			$result = Test-MyNetConnection -Server $remoteDomain1 -Port $Port
			$result | Should -Not -BeNullOrEmpty
			$result.TcpTestSucceeded | Should -Be $true
		}
		
		It "Should check if port 443 (HTTPS) is open on microsoft.com" {
			$result = Test-MyNetConnection -Server $remoteDomain2 -Port $SecurePort
			$result | Should -Not -BeNullOrEmpty
			$result.TcpTestSucceeded | Should -Be $true
		}
	}
}

AfterAll {
	$null = $ServerIP
	$null = $google
	$null = $dnsPort
	$null = $SecurePort
	$null = $Port
	$null = $remoteDomain1
	$null = $remoteDomain2
	Remove-Module -Name HelperFunctions -Force
}