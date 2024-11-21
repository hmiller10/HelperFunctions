BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-LastBootTime Tests, all should pass
Describe "Get-LastBootTime parameter tests" {
	
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

Describe "Get-LastBootTime function output" {

	BeforeEach {
		$Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
		$DaysPast = "14"
		$plainTextPwd = "P@ssw0rd1!"
		$password = ConvertTo-SecureString -String $plainTextPwd -AsPlainText -Force
		$Creds = New-Object -TypeName System.Management.Automation.PSCredential ('Administrator', $password)
		$result = Get-LastBootTime -ComputerName $Computer -Credential $creds -DaysPast $DaysPast -ErrorAction SilentlyContinue
	}

		
	It "If no result, should output a PowerShell Object" {
		if (!($result)) {
			$result | Should -BeNullOrEmpty
		}
	}

	It "If result is found, should output an event log record" {
		if ($result.Count -eq 1) {
			$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType EventLogRecord
		}
	}

	It "If result is found, should output an event log record" {
		if ($result.Count -gt 1) {
			$result | Should -BeOfType Array
		}
	}

	AfterEach {
		$null = $result
		$null = $Computer
		$null = $DaysPast
		$null = $Creds
		$null = $plainTxtPwd
		$null = $password
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}