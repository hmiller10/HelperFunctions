BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	# Define the path to the file or folder to be checked 
}

Describe 'Test-PathExists - Parameters' {
	Context "Test Function Parameters" {
		$Path = TestDrive:\Temp
		# Test-PathExists Tests, all should pass
		
		It "Test-PathExists should have parameter Path." {
			Get-Command Test-PathExists | Should -HaveParameter -ParameterName Path -Type System.String -Mandatory
		}
		
		It "Test-PathExists should have parameter PathType." {
			Get-Command Test-PathExists | Should -HaveParameter -ParameterName PathType -Type System.String -Mandatory
		}
		
		It "Should be of type [System.String]" {
			$result = Test-PathExists -Path $Path -PathType Folder
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}

# Pester test to check for the existence of the file or folder
Describe 'Test-PathExists - Folder' {
	$Path = TestDrive:\Temp
	 It 'should exist' {
		if (-Not (Test-Path -Path $Path -PathType Container))
		{
			New-Item -Path $Path -ItemType Directory
		} 
		Test-Path -Path $Path | Should -Be $true 
	}
}

Describe 'Test-PathExists - File' {
	$File = TestDrive:\Temp\text.txt
	It 'should exist' {
		if (-Not (Test-Path -Path $File -PathType Leaf))
		{
			New-Item -Path $Path -ItemType File
		}
		Test-Path -Path $Path | Should -Be $true
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}
