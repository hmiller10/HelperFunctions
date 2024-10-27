BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
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
			Get-Command Test-PathExists | Should -HaveParameter Force -Type System.Management.Automation.SwitchParameter
		}
		
	}
	
	context "Test-Or-Create" {
		It "Creates a file if it does not exist" {
			$testFilePath = "C:\temp\testfile.txt"
			
			if (Test-Path $testFilePath)
			{
				Remove-Item $testFilePath
			}
			
			Test-PathExists -Path $testFilePath -PathType File
			
			(Test-Path -Path $testFilePath) | Should -BeTrue
		}
		
		It "Creates a folder if it does not exist" {
			$testFolderPath = "C:\temp\testfolder"
			
			if (Test-Path $testFolderPath)
			{
				Remove-Item $testFolderPath -Recurse
			}
			
			Test-PathExists -Path $testFolderPath -PathType Folder
			
			(Test-Path -Path $testFolderPath) | Should -BeTrue
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}