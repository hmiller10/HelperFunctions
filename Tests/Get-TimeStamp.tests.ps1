BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe "Get-TimeStamp" {
	Context "when function Get-TimeStamp is called" {
		
		It "Get-TimeStamp should be of type String in the format 'yyyy-MM-dd_hh-mm-ss'" {
			Get-TimeStamp | Should -BeOfType [String]
		}
		
		It "should return [DateTime] in the format yyyy-MM-dd" {
			Get-TimeStamp | Should -Be $(Get-Date -Format "yyyy-MM-dd_hh-mm-ss")
		}
	}
}