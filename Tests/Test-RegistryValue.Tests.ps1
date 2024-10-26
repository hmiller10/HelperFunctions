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

		It "Should Have Parameter Value" {
			Get-Command Test-RegistryValue | Should -HaveParameter Name -Mandatory -Type System.String
		}
	}
}

# Pester Test
Describe "Test-RegistryValue" {
	It "Checks if a registry key exists" {
		$keyPath = "Software\HerThoughtsOnTech\TestApp"
		
		# Ensure the key exists for the test
		if (-Not (Test-Path "HKLM:\$keyPath"))
		{
			New-Item -Path "HKLM:\$keyPath" -Force
		}
		
		(Test-RegistryValue -Path $keyPath -Name $null) | Should -BeTrue
	}
	
	It "Checks if a registry key/value pair exists" {
		$keyPath = "Software\HerThoughtsOnTech\TestApp"
		$valueName = "TestValue"
		
		# Ensure the key and value exist for the test
		if (-Not (Test-Path "HKLM:\$keyPath"))
		{
			New-Item -Path "HKLM:\$keyPath" -Force
		}
		if (-Not (Get-ItemProperty -Path "HKLM:\$keyPath" -Name $valueName -ErrorAction SilentlyContinue))
		{
			New-ItemProperty -Path "HKLM:\$keyPath" -Name $valueName -Value "Test" -Force
		}
		
		(Test-RegistryValue -Path $keyPath -Name $valueName) | Should -BeTrue
	}
}