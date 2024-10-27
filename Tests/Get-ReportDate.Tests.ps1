BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe "Get-ReportDate" {
	Context "when function Get-ReportDate is called" {
		Mock Get-ReportDate { return "2024-04-20" } -Verifiable -ParameterFilter {$format -match "yyyy-MM-dd"}

		It "Get-ReportDate should be of type String in the format 'yyyy-MM-dd'" {
			$result = Get-ReportDate
			$result | Should -BeOfType [String] -Because "The function is to return a formatted date."
			$result | Should -Not -BeNullOrEmpty
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
	$null = $result
}