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


# Pester Test for Test-RegistryValue function
Describe "Test-RegistryValue" {
    It "Returns true if the registry key and value exist" {
        $Path = "HKLM:\Software\MyCompany\MyApp"
        $Name = "TestValue"
        
        # Ensure the key and value exist for the test
        if (-Not (Test-Path $Path)) {
            New-Item -Path $Path -Force
        }
        if (-Not (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $Path -Name $Name -Value "Test" -Force
        }
        
        $result = Test-RegistryValue -Path $Path -Name $Name
        $result | Should -BeTrue
    }
    
    It "Returns false if the registry key does not exist" {
        $Path = "HKLM:\Software\NonExistentKey"
        $Name = "TestValue"

        $result = Test-RegistryValue -Path $Path -Name $Name
        $result | Should -BeFalse
    }

    It "Returns false if the registry value does not exist" {
        $Path = "HKLM:\Software\MyCompany\MyApp"
        $Name = "NonExistentValue"
        
        # Ensure the key exists but the value does not
        if (-Not (Test-Path $Path)) {
            New-Item -Path $Path -Force
        }
        
        $result = Test-RegistryValue -Path $Path -Name $Name
        $result | Should -BeFalse
    }
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}