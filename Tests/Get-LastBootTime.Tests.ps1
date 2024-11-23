BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}


Describe "Get-LastBootTime" {
	
	Context "Test function to get a computers last boot time" {
		# Get-LastBootTime Tests, all should pass
		BeforeEach {
			$cmd = Get-Command -Name Get-LastBootTime -Module HelperFunctions -CommandType Function
		}
		
		It "Should Have Parameter ComputerName" {
			$cmd | Should -HaveParameter -ParameterName ComputerName
		}

		It "Should Have Parameter Credential" {
			$cmd | Should -HaveParameter -ParameterName Credential
		}

		It "Should Have Parameter DaysPast" {
			$cmd | Should -HaveParameter -ParameterName DaysPast
		}

		It "Should Have Parameter Confirm" {
			$cmd | Should -HaveParameter -ParameterName Confirm
		}

		It "Should Have Parameter WhatIf" {
			$cmd | Should -HaveParameter -ParameterName WhatIf
		}

		AfterEach {
			$null = $cmd
		}
		
	}

	Context "Test function output" {
		BeforeEach {
			$Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
			$DaysPast = "14"
		}

		Mock Get-LastBootTime -MockWith {
			$plainTextPwd = "P@ssw0rd1!"
			$password = ConvertTo-SecureString -String $plainTextPwd -AsPlainText -Force
			$Creds = New-Object -TypeName System.Management.Automation.PSCredential ('Administrator', $password)
			$result = Get-LastBootTime -ComputerName $Computer -Credential $creds -DaysPast $DaysPast
		}

		It "If no result, should output a PowerShell Object" {
			if (!($result)) {
				$result | Should -BeNullOrEmpty
			}
		}

		It "If result is found, should output an event log record" {
			if ($result.Count -eq 1) {
				$result | Should -BeOfType EventLogRecord
			}
		}

		It "If result is found, should output an event log record" {
			if ($result.Count -gt 1) {
				$result | Should -BeOfType Array
			}
		}

		AfterEach {
			$null = $Computer
			$null = $DaysPast
		}
	}
}

AfterAll {
	$null = $Computer
	$null = $DaysPast

	Remove-Module -Name HelperFunctions -Force
}