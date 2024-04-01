Before All {
    Import-Module -Name HelperFunctions -Force
    if ($Error) { $Error.Clear() }

}

Describe "Get-UtcTime" {
	Context "when function Get-UtcTime is called" {
		It "should return [System.DateTime]::UtcNow in GMT time" {
			Get-UtcTime | Should -BeOfType System.DateTime
		}

		It "should return [DateTime]::UtcNow" {
			Get-UTCTime | Should -BeLike $([DateTime]::UtcNow)
		}
	}
}