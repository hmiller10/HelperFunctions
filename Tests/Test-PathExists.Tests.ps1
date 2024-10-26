BeforeAll {
	if ($Error) { $Error.Clear() }
	Import-Module -Name HelperFunctions -Force
}

Describe 'Test-PathExists' {
	
	context 'Test function parameters' {
		It "Should Have Parameter Path" {
			Get-Command Test-PathExists | Should -HaveParameter Path -Mandatory -Type System.String
		}
		It "Should Have Parameter PathType" {
			Get-Command Test-PathExists | Should -HaveParameter PathType -Mandatory -Type System.String
		}
		It "Should Have Parameter Force" {
			Get-Command Test-PathExists | Should -HaveParameter Force -Type System.Switch
		}
		
	}
	
	context "Test-Or-Create" {
		It "Creates a file if it does not exist" {
			$testFilePath = "C:\temp\testfile.txt"
			
			if (Test-Path $testFilePath)
			{
				Remove-Item $testFilePath
			}
			
			Test-PathExists -Path $testFilePath -PathType File | Should -Exist
		}
		
		It "Creates a folder if it does not exist" {
			$testFolderPath = "C:\temp\testfolder"
			
			if (Test-Path $testFolderPath)
			{
				Remove-Item $testFolderPath -Recurse
			}
			
			Test-PathExists -Path $testFolderPath -PathType Folder | Should -Exist
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}