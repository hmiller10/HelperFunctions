BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error)
	{
		$Error.Clear()

		[string]$key = 'HKLM:\Software\HerThoughtsOnTech'
		[string]$value = "BuildVersion"
	}
}


Describe "Test-RegistryValue" {

	Context "Test pre-defined registry key and value" {
		# Test-RegistryValue Tests, all should pass

		It "Should Have Parameter Path" {
			Get-Command Test-RegistryValue | Should -HaveParameter Path -Mandatory -Type System.String
		}

		It "Should Have Parameter Name" {
			Get-Command Test-RegistryValue | Should -HaveParameter Name -Mandatory -Type System.String
		}
	}

	Context "Test for predefined registry key and value" {
		It "Checks if a registry key/value pair exists" {
			
			# Ensure the key and value exist for the test
			if (-Not (Test-Path "HKLM:\$key"))
			{
				New-Item -Path "HKLM:\$key" -Force
			}
			if (-Not (Get-ItemProperty -Path "HKLM:\$key" -Name $value -ErrorAction SilentlyContinue))
			{
				New-ItemProperty -Path "HKLM:\$key" -Name $value -Value "Test" -Force
			}
			
			(Test-RegistryValue -Path $key -Name $value) | Should -Not -BeNullOrEmpty
			(Test-RegistryValue -Path $key -Name $value) | Should -BeTrue
		}
	}
	
}