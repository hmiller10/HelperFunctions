BeforeAll {
	if ($Error) { $Error.Clear() }
	Import-Module -Name HelperFunctions -Force
	$Path = TestDrive:\tmpPath
	$File = TestDrive:\text.txt
}

Describe 'Test-PathExists' {
	
	context 'when Test-PathExists and the folder path does not exist' {
		It 'creates the folder' {
			Test-PathExists -Path $Path -PathType Folder | Should -BeOfType System.IO.FileInfo
		}
	}
	
	context 'when Test-PathExists and the folder path already exists' {
		
		It 'attempts to write a output message' {
			## This checks to see if New-Item did not attempt to run (Times = 0). If it did not
			## that means that it did not attempt to create the file
			$assMParams = @{
				CommandName = 'Write-Output'
				Times	  = 1
				Exactly     = $true
			}
			Assert-MockCalled @assMParams
		}
	}
	
	context 'when Test-PathExists and the file path does not exist' {
		
		It 'creates the file' {
			Test-Path -Path $Path -PathType File | Should -BeOfType System.IO.File
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}
