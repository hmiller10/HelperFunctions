BeforeAll {
	if ($Error) { $Error.Clear() }
}

Describe "Get-TodaysDate" {
	Context "when function Get-TodaysDate is called" {

		Mock Get-TodaysDate -MockWith {
			$result = Get-TodaysDate
		}
		It "Get-TodaysDate should be of type String in the format 'MM-dd-yyyy'" {
			$result | Should -BeOfType [String]
		}

		It "should not return $null"  {
			$result | Should -Not -Be $null
		}

		It "should return a date string in the format MM-dd-yyyy" {
			$result | Should -BeLessOrEqual $((Get-Date).ToString("MM-dd-yyyy"))
		}
	}
}

AfterAll {
	$null = $result
}