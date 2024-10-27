BeforeAll {
   	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
    	if ($Error) { $Error.Clear() }

}

Describe "Get-UtcTime" {
	Context "when function Get-UtcTime is called" {

		It "should return [System.DateTime]::UtcNow in GMT time" {
			$result = Get-UTCTime 
			$result | Should -BeOfType System.DateTime
			$result | Should -Not -BeNullOrEmpty
		}
		
		It "should return [DateTime]::UtcNow" {
			Get-UTCTime | Should -BeLike $([DateTime]::UtcNow)
		}
	}
}

AfterAll {
	$null = $result
	Remove-Module -Name HelperFunctions -Force
}