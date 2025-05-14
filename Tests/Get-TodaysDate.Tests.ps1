BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Get-TodaysDate Tests, all should pass
Describe 'Get-TodaysDate function output' {

	Mock Get-TodaysDate { return "04-20-2024" } -Verifiable -ParameterFilter {$format -match "MM-dd-yyyy"}

	It "Get-TodaysDate should be of type String in the format 'MM-dd-yyyy'" {
		$result = Get-TodaysDate
		$result | Should -BeOfType System.String
		$result | Should -Not -BeNullOrEmpty
	}
}

AfterAll {
	$null = $result
	Remove-Module -Name HelperFunctions -Force
}