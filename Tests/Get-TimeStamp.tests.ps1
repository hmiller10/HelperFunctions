BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe "Get-TimeStamp" {
	Context "When function Get-TimeStamp is called" {
		Mock Get-TimeStamp { return "2024-04-20_01-00-00" } -Verifiable -ParameterFilter {$format -match "yyyy-MM-dd_hh-mm-ss"}

		It "Get-TimeStamp should be of type String in the format 'yyyy-MM-dd_hh-mm-ss'" {
			$result = Get-TimeStamp
			$result | Should -BeOfType System.String
			$result | Should -Not -BeNullOrEmpty
		}
	}
}

AfterAll {
	$null = $result
	Remove-Module -Name HelperFunctions -Force
}