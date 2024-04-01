﻿BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe "Get-TodaysDate" {
	Context "when function Get-TodaysDate is called" {

		It "Get-TodaysDate should be of type String in the format 'MM-dd-yyyy'" {
			Get-Command Get-TodaysDate | Should -BeOfType [String]
		}

		It "should return [DateTime] in the format MM-dd-yyyy" {
			Get-Command Get-TodaysDate | Should -BeLike $(Get-Date -Format "MM-dd-yyyy")
		}
	}
}