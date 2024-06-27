BeforeAll {
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
			Get-Command -Name Test-MyNetConnection -Module HelperFunctions -CommandType Function | Should -HaveParameter ServerName -Mandatory -Type System.String
		}
		
		It "Should Have Parameter Group" {
			Get-Command -Name Test-MyNetConnection -Module HelperFunctions -CommandType Function | Should -HaveParameter Port -Mandatory -Type int32
		}
	}
	
	Context "Testing network connectivity" {

          BeforeEach {
               $result1 = Test-MyNetConnection -ServerName $google -Port $SecurePort
          }

		It "Should resolve DNS name 'google.com'" {
			$result1 | Should -Not -Be $null
			$result1.TcpTestSucceeded | Should -Be $true
		}

          AfterEach {
               $null = $result1
          }
	}
	
	Context "Testing specific ports" {

          BeforeEach {
               $result2 = Test-MyNetConnection -ServerName $remoteDomain1 -Port $Port
               $result3 = Test-MyNetConnection -ServerName $remoteDomain2 -Port $SecurePort
          }

		It "Should check if port 80 (HTTP) is open on yahoo.com" {
			$result2 | Should -Not -Be $null
			$result2.TcpTestSucceeded | Should -Be $true
		}
		
		It "Should check if port 443 (HTTPS) is open on microsoft.com" {
			$result3 | Should -Not -Be $null
			$result3.TcpTestSucceeded | Should -Be $true
		}

          AfterEach {
               $null = $result2
               $null = $result3
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
     $null = $result1
}