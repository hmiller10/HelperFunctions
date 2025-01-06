BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-PathExists Tests, all should pass
Describe 'Test-PathExists - Parameters' {
	
	It "Test-PathExists should have parameter Path." {
		Get-Command Test-PathExists | Should -HaveParameter -ParameterName Path -Type System.String -Mandatory
	}
	
	It "Test-PathExists should have parameter PathType." {
		Get-Command Test-PathExists | Should -HaveParameter -ParameterName PathType -Type System.String -Mandatory
	}

}

# Pester test to check for the existence of the file or folder
Describe 'Test-PathExists - Functionality' {

	Context 'Test-PathExists - Folder' {
		BeforeEach {
			$FolderPath = "TestDrive:\Temp\"
			New-Item -Path $FolderPath -ItemType Directory
		}

		It "Folder should exist" {
			Test-Path -Path $FolderPath | Should -Be $true
		}
	
		It "Folder should be of type [System.String]" {
			$result1 = Test-PathExists -Path $FolderPath -PathType Folder
			$result1 | Should -Not -BeNullOrEmpty
			$result1 | Should -BeOfType [System.String]
		}
	
		AfterEach {
			Remove-Item -Path $FolderPath -Force
			$null = $FolderPath = $result1
		}
	}

	Context 'Test-PathExists - File' {
		BeforeEach {
			$File = "TestDrive:\test.txt"
			New-Item -Path $File -ItemType File
			Set-Content $File -value "My test file text."
		}
	
		It "File should exist" {
			Test-Path -Path $File | Should -Be $true
		}
	
		It "File should be of type [System.String]" {
			$result2 = Test-PathExists -Path $File -PathType File
			$result2 | Should -Not -BeNullOrEmpty
			$result2 | Should -BeOfType [System.String]
		}
	
		AfterEach {
			Remove-Item -Path $File -Force
			$null = $File = $result2	
		}
	}
}

AfterAll {
	
	try {
		$Drive = Get-PSDrive -Name TestDrive -ErrorAction Stop
	}
	catch {
		$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
		Write-Error $errorMessage -ErrorAction Continue
	}
		
	If ($Drive) { Remove-PSDrive -Name TestDrive -Force -ErrorAction Continue }
	Remove-Module -Name HelperFunctions -Force
}