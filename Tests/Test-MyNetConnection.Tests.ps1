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

# Test-MyNetConnection Tests, all should pass
Describe 'Test-MyNetConnection function parameters' {
	
	BeforeEach {
		$cmd = Get-Command Test-MyNetConnection -Module HelperFunctions -CommandType Function
	}
	
	It "Should Have Parameter ComputerName" {
		$cmd | Should -HaveParameter -ParameterName "ComputerName" -Mandatory
	}
	
	It "Should Have Parameter Credential" {
		$cmd | Should -HaveParameter -ParameterName "Port" -Mandatory
	}
	
	AfterEach {
		$null = $cmd
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