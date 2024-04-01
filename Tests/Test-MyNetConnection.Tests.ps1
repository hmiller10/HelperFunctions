BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	Import-Module -Name NetTcpip -Force
	if ($Error)
	{
		$Error.Clear()
	}
	
	[string]$ServerIP = '8.8.8.8'
	[string]$google = 'google.com'
	[int32]$dnsPort = 53
	[int32]$SecurePort = 443
	[int32]$Port = 80
	[string]$remoteDomain1 = 'yahoo.com'
	[string]$remoteDomain2 = 'microsoft.com'
}

Describe "Test-MyNetConnection" {
	
	Context "Test function parameters" {
		# Test-MyNetConnection Tests, all should pass
		
		It "Should Have Parameter User" {
			Get-Command Test-MyNetConnection | Should -HaveParameter Server -Mandatory -Type System.String
		}
		
		It "Should Have Parameter Group" {
			Get-Command Test-MyNetConnection | Should -HaveParameter Port -Mandatory -Type int32
		}
	}
	
	Context "Testing network connectivity" {
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