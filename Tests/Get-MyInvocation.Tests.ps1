BeforeAll {
	Import-Module -Name HelperFunctions -Force -ErrorAction Stop
    if ($Error) { $Error.Clear() }
}


Describe 'Get-MyInvocation' {
	
	Context "Return MyInvocation" {
		
		It "Should return $($MyInvocation)" {
			$result = Get-MyInvocation
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.Management.Automation.InvocationInfo]
		}
	}
}