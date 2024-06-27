BeforeAll {
	Import-Module -Name HelperFunctions -Force -ErrorAction Stop
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

Describe 'Test-PathExists' {

	## This ensures New-Item will never run. It's just being used as a
	## flag to test if it attempts to execute
	mock 'Test-PathExists'

	context 'when the file path does not exist' {

		## This ensures Test-Path always returns $false "mimicking" the file does not exist
		mock 'Test-Path' -ModuleName HelperFunctions  { $false }

		$null = Test-PathExists -Path '~\file.txt' -PathType File

		it 'creates the file' {
			## This checks to see if New-Item attempted to run. If so, we know the script did what we expected
			$assMParams = @{
				CommandName = 'Test-Path'
				Times	  = 1
				Exactly     = $true
			}
			Assert-MockCalled -CommandName Test-PathExists -Times 1 -ModuleName HelperFUnctions -Scope Context
		}
	}
}