BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error)
	{
		$Error.Clear()

		[string]$key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
		[string]$value = "CurrentBuild"
	}
}


Describe "Test-RegistryValue Parameters" {

	Context "Test pre-defined registry key and value" {
		# Test-RegistryValue Tests, all should pass

		It "Should Have Parameter Path" {
			Get-Command Test-RegistryValue | Should -HaveParameter Path -Mandatory -Type System.String
		}

		It "Should Have Parameter Name" {
			Get-Command Test-RegistryValue | Should -HaveParameter Name -Mandatory -Type System.String
		}
	}
}

# Pester Test
Describe "Test-RegistryValue" {
	It "Checks if a registry key exists" {
		
		# Ensure the key exists for the test
		if (-Not (Test-Path "HKLM:\$key"))
		{
			New-Item -Path "HKLM:\$key" -Force
		}
		
		(Test-RegistryValue -Path $key -Name $value) | Should -BeTrue
	}
	
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
		
		(Test-RegistryValue -Path $key -Name $value) | Should -BeTrue
	}
}