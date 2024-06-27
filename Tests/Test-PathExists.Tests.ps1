BeforeAll {
	if ($Error) { $Error.Clear() }
	$Path = TestDrive:\tmpPath
	$File = TestDrive:\text.txt
}

Describe 'Test-PathExists' {
	mock 'New-Item'
	mock 'Write-Output'
	
	context 'when Test-PathExists and the folder path does not exist' {
		## This ensures Test-Path always returns $false "mimicking" the file does not exist
		mock 'Test-Path' { $false }
		
		$null = Test-PathExists -Path $Path -PathType Folder
		
		it 'creates the folder' {
			## This checks to see if New-Item attempted to run. If so, we know the script did what we expected
			$assMParams = @{
				CommandName = 'New-Item'
				Times	  = 1
				Exactly     = $true
			}
			Assert-MockCalled @assMParams
		}
	}
	
	context 'when Test-PathExists and the folder path already exists' {
		## This ensures Test-Path always returns $true "mimicking" the file does not exist
		mock 'Test-Path' { $true }
		
		$null = Test-Path -Path $Path -PathType Folder
		
		it 'attempts to write a output message' {
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
	
	context 'when Test-PathExists and the folder path does not exist' {
		## This ensures Test-Path always returns $false "mimicking" the file does not exist
		mock 'Test-Path' { $false }
		
		$null = Test-PathExists -Path $File -PathType File
		
		it 'creates the file' {
			## This checks to see if New-Item attempted to run. If so, we know the script did what we expected
			$assMParams = @{
				CommandName = 'New-Item'
				Times	  = 1
				Exactly     = $true
			}
			Assert-MockCalled @assMParams
		}
	}
	
	context 'when Test-PathExists and the file path already exists' {
		## This ensures Test-Path always returns $true "mimicking" the file does not exist
		mock 'Test-Path' { $true }
		
		$null = Test-Path -Path $File -PathType File
		
		it 'attempts to write a output message' {
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
}
