BeforeAll {
    Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
    if ($Error) { $Error.Clear() }

}

Describe "Get-UtcTime" {
	Context "when function Get-UtcTime is called" {

		Mock Get-TimeStamp -MockWith {
			$result | Get-UtcTime
		}

		It "should return [System.DateTime]::UtcNow in GMT time" {
			Get-UTCTime | Should -BeOfType System.DateTime
		}
		
		It "should not return $null"  {
			$result | Should -Not -Be $null
		}

		It "should return [DateTime]::UtcNow" {
			Get-UTCTime | Should -BeLike $([DateTime]::UtcNow)
		}
	}
}

AfterAll {
	$null = $result
}