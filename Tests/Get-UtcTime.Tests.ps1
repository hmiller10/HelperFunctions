BeforeAll {
   	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
    	if ($Error) { $Error.Clear() }

}

# Get-TimeStamp Tests, all should pass
Describe "Get-UtcTime parameter tests" {
	
	It 'Get-Utctime function output should return [System.DateTime]::UtcNow in GMT time' {
		$result = Get-UTCTime 
		$result | Should -BeOfType System.DateTime
		$result | Should -Not -BeNullOrEmpty
	}
		
	It "Get-Utctime should return [DateTime]::UtcNow" {
		Get-UTCTime | Should -BeLike $([DateTime]::UtcNow)
	}

}

AfterAll {
	$null = $result
	Remove-Module -Name HelperFunctions -Force
}