BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }

	[string]$ServerIP = '8.8.8.8'
	[string]$google = 'google.com'
	[int32]$dnsPort = 53
	[int32]$SecurePort = 443
	[string]$remoteDomain2 = 'microsoft.com'

}

# Test-MyNetConnection Tests, all should pass
Describe 'Test-MyNetConnection function parameters' {

	BeforeEach {
		$params = @{
			ComputerName = 'yahoo.com'
			Port         = 80
		}
	}
	It "Should accept a ComputerName and Port paramter" {
		$result = Test-MyNetConnection @params
		$result.ComputerName | Should -Be 'yahoo.com'
		$result.Port | Should -Be '80'
	}

	AfterEach {
		$params = @{}
	}

}

Describe 'Test-MyNetConnection function output' {

	It "Test-MyNetConnection should resolve DNS name 'google.com'" {
		$result = Test-MyNetConnection -Server $google -Port $SecurePort
		$result | Should -Not -BeNullOrEmpty
		$result.TcpTestSucceeded | Should -Be $true
	}

	Context "Test-MyNetConnection specific port tests" {
	
		It "Test-MyNetConnection should check if port 80 (HTTP) is open on yahoo.com" {
			$result = Test-MyNetConnection -Server $remoteDomain2 -Port $securePort
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