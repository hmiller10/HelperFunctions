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

Describe "Testing registry access with Pester" {
	It "Should get the value of a registry key" {
		# Mock the Get-ItemProperty cmdlet
		Mock Get-ItemProperty {
			if ($Path -eq 'HKLM:\SOFTWARE\TestKey')
			{
				return @{ TestValue = 'TestData' }
			}
		}
		
		# Function that uses Get-ItemProperty
		function Get-RegistryValue
		{
			param (
				[string]$Path,
				[string]$Name
			)
			
			Get-ItemProperty -Path $Path -Name $Name | Select-Object -ExpandProperty $Name
		}
		
		# Test the function
		$result = Get-RegistryValue -Path 'HKLM:\SOFTWARE\TestKey' -Name 'TestValue'
		$result | Should -Be 'TestData'
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