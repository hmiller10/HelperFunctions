BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-PathExists Tests, all should pass
Describe 'Test-PathExists - Parameters' {
	BeforeAll {
		$Path = "TestDrive:\Temp"
	}
	
	It "Test-PathExists should have parameter Path." {
		Get-Command Test-PathExists | Should -HaveParameter -ParameterName Path -Type System.String -Mandatory
	}
	
	It "Test-PathExists should have parameter PathType." {
		Get-Command Test-PathExists | Should -HaveParameter -ParameterName PathType -Type System.String -Mandatory
	}
	
	It "Should be of type [System.IO.DirectoryInfo]" {
		$result = Test-PathExists -Path $Path -PathType Folder
		$result | Should -Not -BeNullOrEmpty
		$result | Should -BeOfType [System.IO.DirectoryInfo]
	}
	
	AfterAll {
		Remove-Item -Path $Path -Force
	}
}

# Pester test to check for the existence of the file or folder
Describe 'Test-PathExists - Folder' {
	BeforeAll {
		$Path = "TestDrive:\Temp"
	}
	
	It "$Path should exist" {
		if (-Not (Test-Path -Path $Path -PathType Container))
		{
			New-Item -Path $Path -ItemType Directory
		}
		Test-Path -Path $Path | Should -Be $true
	}
	
	AfterAll {
		#Remove-Item -Path $Path -Force
	}
}

Describe 'Test-PathExists - File' {
	BeforeAll {
		$File = "TestDrive:\test.txt"
		Set-Content $File -value "my test text."
	}
	
	It "$File should exist" {
		if (-Not (Test-Path -Path $File -PathType Leaf))
		{
			New-Item -Path $File -ItemType File
		}
		Test-Path -Path $File | Should -Be $true
	}
	
	AfterAll {
		#Remove-Item -Path $File -Force
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}