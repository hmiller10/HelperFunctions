BeforeAll {
	if ($Error) { $Error.Clear() }
}

Describe "Get-TimeStamp" {
	Context "When function Get-TimeStamp is called" {
		
		Mock Get-TimeStamp -MockWith {
			$result | Get-TimeStamp
		}

		It "Get-TimeStamp should be of type String in the format 'yyyy-MM-dd_hh-mm-ss'" {
			$result | Should -BeOfType [String]
		}
		
		It "should not return $null"  {
			$result | Should -Not -Be $null
		}

		It "Should be a date string in the format yyyy-MM-dd_mm-dd-ss" {
			$result | Should -BeLessOrEqual $(Get-Date -Format "yyyy-MM-dd_hh-mm-ss")
		}
	}
}

AfterAll {
	$null = $result
}