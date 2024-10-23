BeforeAll {
	if ($Error) { $Error.Clear() }
	Import-Module -Name HelperFunctions -Force
}

Describe 'Test-PathExists' {
	
	context 'when Test-PathExists and the folder path does not exist' {
		it 'creates a file then reads if the file does not exist' {
			mock -CommandName 'Test-Path' -MockWith {
				return $false
			}
			mock -CommandName 'Get-Content' -MockWith {
				return $null
			}
			mock -CommandName 'Add-Content' -MockWith {
				return $null
			}
			Get-FileContents -Path 'C:\SomeBogusFile.txt'
			Assert-MockCalled -CommandName 'Get-Content' -Times 1 -Scope It
			Assert-MockCalled -CommandName 'Add-Content' -Times 1 -Scope It
		}
	}
	
	context 'when Test-PathExists and the folder path already exists' {
		it 'only reads the file if it already exists' {
			mock -CommandName 'Test-Path' -MockWith {
				return $true
			}
			mock -CommandName 'Get-Content' -MockWith {
				return $null
			}
			Get-FileContents -Path 'C:\SomeBogusFile.txt'
			Assert-MockCalled -CommandName 'Get-Content' -Times 1 -Scope It
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}