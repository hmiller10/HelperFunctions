BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	
	[string]$key = 'HKLM:\Software\HerThoughtsOnTech'
	[string]$value = "BuildVersion"
}


# Pester Test for Test-RegistryValue function
Describe "Test-RegistryValue parameter values" {
	
	BeforeEach {
		$cmd = Get-Command -Name Test-RegistryValue -Module HelperFunctions -CommandType Function -ArgumentList @{ Path = $Path; 
			Value = $Value
		}
	}
	
	It "Should Have Parameter ComputerName" {
		$cmd | Should -HaveParameter -ParameterName "Path" -Mandatory
	}
	
	It "Should Have Parameter Credential" {
		$cmd | Should -HaveParameter -ParameterName Name -Mandatory
	}
	
	AfterEach {
		$null = $cmd
	}
	
}

Describe 'Test-RegistryValue function output' {
	
	BeforeEach {
		$Path = "HKLM:\Software\MyCompany\MyApp"
		$Name = "TestValue"
	}
	
	It "Test-RegistryValue returns true if the registry key and value exist" {
		
		# Ensure the key and value exist for the test
		if (-Not (Test-Path $Path))
		{
			New-Item -Path $Path -Force
		}
		
		if (-Not (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue))
		{
			New-ItemProperty -Path $Path -Name $Name -Value "Test" -Force
		}
		
		$result = Test-RegistryValue -Path $Path -Name $Name
		$result | Should -BeFalse
	}
	
	AfterEach {
		$null = $Path
		$null = $Value
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}