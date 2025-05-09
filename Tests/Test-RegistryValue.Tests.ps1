﻿BeforeAll {
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
		Get-Command -Name Test-RegistryValue -Module HelperFunctions -CommandType Function  | Should -HaveParameter -ParameterName "Value" -Mandatory
	}
	
}

Describe "Testing registry access with Pester" {

	BeforeEach {
		$Name = 'TestData'
		New-Item -Path TestRegistry:\ -Name TestLocation
		New-ItemProperty -Path "TestRegistry:\TestLocation" -Name $Name -Value "Test"
	}

	It "Should test the value of a registry key" {
		$result = Test-RegistryValue -Path "TestRegistry:\TestLocation" -Value $Name
		$result | Should -Not -BeNullOrEmpty
		$result | Should -BeFalse
		
	}
	
	AfterEach {
		$null = $Name = $result
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