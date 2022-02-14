BeforeAll {
	Import-Module -Name HelperFunctions -Force -ErrorAction Stop
    if ($Error) { $Error.Clear() }

	$IPAddress = '10.0.0.1'
}


Describe 'Test-IsValidIPAddress' {
	
	Context "IPAddress Validation" {
		
		It "Should be of type [bool]" {
			$result = Test-IsValidIPAddress -IP $IPAddress
			$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType [bool]
		}
	}
}