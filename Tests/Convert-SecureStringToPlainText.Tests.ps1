BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	
	$cmd = Get-Command -Name Convert-SecureStringToPlainText -Module HelperFunctions -CommandType Function
	$securePass = ("P@ssw0rd1!!" | ConvertTo-SecureString -AsPlainText -Force)
}

# Get-ComputerNameByIP Tests, all should pass
Describe 'Convert-SecureStringToPlainText Parameters' {
	
	It "Convert-SecureStringToPlainText should have SecureString as a mandatory parameter." {
		$cmd | Should -HaveParameter -ParameterName SecureString -Because "The function must have a secure string to process." -Mandatory
		$cmd | Should -Not -BeNullOrEmpty
	}
	
}

Describe 'Convert-SecureStringToPlainText function output' {
	
	It "Convert-SecureStringToPlainText should have output type of string." {
		$cmd = Convert-SecureStringToPlainText -SecureString $securePass -ErrorAction SilentlyContinue
		$cmd | Should -BeOfType PSCustomObject
		$cmd | Should -Not -BeNullOrEmpty
	}
}

AfterAll {
	$null = $cmd
	$null = $securePass
	Remove-Module -Name HelperFunctions -Force
}