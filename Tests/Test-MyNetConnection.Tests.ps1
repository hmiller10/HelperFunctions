﻿BeforeAll {
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
			Server = 'www.yahoo.com'
			Port = 80
		}
		
	}
	
	Mock Test-NetConnection {
		$return = @{
			ComputerName = 'yahoo.com'
			RemotePort         = 80
			TcpTestSucceeded  = $true
		}
	}
	
	It 'Should return a result' {
		$result = Test-MyNetConnection @params
		$result.ComputerName | Should -Be 'www.yahoo.com'
		$result.RemotePort | Should -Be 80
		$result.TcpTestSucceeded | Should -Be $true
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