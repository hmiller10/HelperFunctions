BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
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

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}