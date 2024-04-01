BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe "Get-ReportDate" {
	Context "when function Get-ReportDate is called" {

		It "Get-ReportDate should be of type String in the format 'yyyy-MM-dd'" {
			Get-Command Get-ReportDate | Should -BeOfType [String]
		}

		It "should return [DateTime] in the format yyyy-MM-dd" {
			Get-Command Get-ReportDate | Should -Be $(Get-Date -Format "yyyy-MM-dd")
		}
	}
}