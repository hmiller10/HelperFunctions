BeforeAll {
	Import-Module -Name HelperFunctions -Force -ErrorAction Stop
    if ($Error) { $Error.Clear() }

	$Program = "Cylance Optics"
}


Describe 'Test-IsInstalled' {
	
	Context "Program installation verification" {
		# Test-IsInstalled Tests, all should pass

        It "Test-IsInstalled should have a parameter Program" {
            Get-Command Test-IsInstalled | Should -HaveParameter Program -Type String
			Get-Command Test-IsInstalled | Should -HaveParameter Program -Mandatory
        }

		It "Should be of type [bool]" {
			$result = Test-IsInstalled -Program $Program
			$result | Should -BeOfType [bool]
		}
	}
}