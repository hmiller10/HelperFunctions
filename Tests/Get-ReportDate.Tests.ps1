BeforeAll {
	if ($Error) { $Error.Clear() }
}

Describe "Get-ReportDate" {
	Context "when function Get-ReportDate is called" {
		Mock Get-ReportDate -MockWith {
			$result = Get-ReportDate
		}
		It "Get-ReportDate should be of type String in the format 'yyyy-MM-dd'" {
			$result | Should -BeOfType [String] -Because "The function is to return a formatted date."
		}

		It "should not return $null"  {
			$result | Should -Not -Be $null
		}

		It "Should be a date string in the format yyyy-MM-dd_mm-dd-ss" {
			$result | Should -BeLessOrEqual $(Get-Date -Format "yyyy-MM-dd")
		}
	}
}

AfterAll {
	$null = $result
}