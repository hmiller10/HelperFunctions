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
	
	BeforeEach {
		$Path = "HKLM:\Software\MyCompany\MyApp"
		$Name = "TestValue"
	}
	
	It "Test-RegistryValue returns true if the registry key and value exist" {
		# Ensure the key and value exist for the test
		if ((Test-Path $Path) -eq $false) {
			New-Item -Path $Path -Force
		}
		
		#if (-Not (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue))
		if (-Not (Get-ItemProperty -Path $Path -Name $Name)) {
			New-ItemProperty -Path $Path -Name $Name -Value "Test" -Force
		}
		
		$result = Test-RegistryValue -Path $Path -Name $Name
		$result | Should -BeFalse
	}
	
	AfterEach {
		$null = $Path
		$null = $Name
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}