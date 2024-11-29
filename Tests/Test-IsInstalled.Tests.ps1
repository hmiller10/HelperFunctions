BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	try
	{
		$Drive = Get-PSDrive -Name TestDrive -ErrorAction Stop
	}
	catch
	{
		$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
		Write-Error $errorMessage -ErrorAction Continue
	}
	
	If ($Drive) { Remove-PSDrive -Name TestDrive -Force -ErrorAction Continue }
	$Program = "Github Desktop"
}

# Test-IsInstalled Tests, all should pass
Describe 'Test-IsInstalled parameters' {
	
	It "Test-IsInstalled should have a parameter Program" {
		Get-Command -Name Test-IsInstalled -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName Program -Type System.String -Mandatory
	}
}

Describe 'Test-IsInstalled function output' {

	It "Test-IsInstalled output should be of type [bool]" {
		
		$result = Test-IsInstalled -Program $Program
		$result | Should -BeOfType [bool]
	}
	
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}