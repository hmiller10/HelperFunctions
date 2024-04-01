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


Describe "Test-RegistryValue" {

	Context "Test pre-defined registry key and value" {
		# Test-RegistryValue Tests, all should pass

		It "Should Have Parameter Path" {
			Get-Command Test-RegistryValue | Should -HaveParameter Path -Mandatory -Type System.String
		}

		It "Should Have Parameter Value" {
			Get-Command Test-RegistryValue | Should -HaveParameter Name -Mandatory -Type System.String
		}

		It "Should be of type [System.Boolean]" {
			$result = Test-RegistryValue -Path $key -Name $value
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [bool]
		}
	}
}