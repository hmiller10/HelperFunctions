BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-MyInvocation Tests, all should pass
Describe 'Get-MyInvocation function output' {

	It "Should return $($MyInvocation)" {
		$result = Get-MyInvocation #-ErrorAction SilentlyContinue
		$result | Should -Not -BeNullOrEmpty
		$result | Should -ExpectedType [System.Management.Automation.InvocationInfo]
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}