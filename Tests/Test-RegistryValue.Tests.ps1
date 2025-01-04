BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}


# Pester Test for Test-RegistryValue function
Describe "Test-RegistryValue parameter values" {
	
	It "Should Have Parameter Path" {
		Get-Command -Name Test-RegistryValue -Module HelperFunctions -CommandType Function  | Should -HaveParameter -ParameterName "Path" -Mandatory
	}
	
	It "Should Have Parameter Name" {
		Get-Command -Name Test-RegistryValue -Module HelperFunctions -CommandType Function  | Should -HaveParameter -ParameterName "Name" -Mandatory
	}
	
}

Describe 'Test-RegistryValue function output' {
	BeforeAll {
		New-Item -Path TestRegistry:\ -Name TestLocation
		New-ItemProperty -Path "TestRegistry:\TestLocation" -Name "InstallPath" -Value "C:\Program Files\MyApplication"
	}
	
	It "Test-RegistryValue returns true if the registry key and value exist" {
		# Ensure the key and value exist for the test
		Test-RegistryKeyValue -Path "TestRegistry:\TestLocation" -Value "InstallPath" | Should -Be "C:\Program Files\MyApplication"
	}
}

AfterAll {
	try {
		$Drive = Get-PSDrive -Name TestRegistry -ErrorAction Stop
	}
	catch {
		$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
		Write-Error $errorMessage -ErrorAction Continue
	}
		
	If ($Drive) { Remove-PSDrive -Name TestRegistry -Force -ErrorAction Continue }
	Remove-Module -Name HelperFunctions -Force
}