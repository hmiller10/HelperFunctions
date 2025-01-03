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
		$KeyPath = "HKLM\Software\MyCompany\MyApp"
		$Name = "TestValue"
		New-Item -Path TestRegistry:\ -Name $KeyPath
		New-ItemProperty -Path "TestRegistry:\$KeyPath" -Name $Name -Value
	}
	
	It "Test-RegistryValue returns true if the registry key and value exist" {
		# Ensure the key and value exist for the test
		if ((Test-Path "TestRegistry:\$KeyPath") -eq $false) {
			New-Item -Path "TestRegistry\$KeyPath" -Force
		}
		
		#if (-Not (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue))
		if (-Not (Get-ItemProperty -Path "TestRegistry:\$KeyPath" -Name $Name)) {
			New-ItemProperty -Path "TestRegistry:\$KeyPath" -Name $Name -Value "Test" -Force
		}
		
		$result = Test-RegistryValue -Path "TestRegistry:\$KeyPath" -Name $Name
		$result | Should -BeTrue
	}
	
	AfterEach {
		$null = $KeyPath
		$null = $Name
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