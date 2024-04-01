BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error)
	{
		$Error.Clear()
		[string]$IP = '10.0.0.1'
	}
}


Describe "Test-IsValidIPAddress" {
	
	Context "Test IP address parameter to validate type" {
		# Test-IsValidIPAddress Tests, all should pass
		
		It "Should Have Parameter Path" {
			Get-Command Test-IsValidIPAddress | Should -HaveParameter IP -Mandatory -Type System.String
		}
		
		It "Should be of type [System.Boolean]" {
			$result = Test-IsValidIPAddress -IP $IP
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [bool]
		}
	}
}