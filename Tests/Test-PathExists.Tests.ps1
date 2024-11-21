BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-PathExists Tests, all should pass
Describe 'Test-PathExists parameter values' {
	BeforeEach {
		$Path = "TestDrive:\Temp"
		$cmd = Get-Command Test-PathExists -Module HelperFunctions -CommandType Function
	}

	It "Test-PathExists should have parameter Path." {
		$cmd | Should -HaveParameter -ParameterName "Path" -Mandatory
	}
	
	It "Test-PathExists should have parameter PathType." {
		$cmd | Should -HaveParameter -ParameterName PathType -Mandatory
	}
	
	AfterEach {
		Remove-Item -Path $Path -Force
	}
}

# Pester test to check for the existence of the file or folder
Describe 'Test-PathExists - Folder' {
	BeforeEach {
		$Path = "TestDrive:\Temp"
	}
	
	It 'Test-PathExists with Folder should exist' {
		if (-Not (Test-Path -Path $Path -PathType Container))
		{
			New-Item -Path $Path -ItemType Directory
		}
		
		Test-Path -Path $Path -PathType Container | Should -Be $true 
	}
	
	AfterEach {
		Remove-Item -Path $Path -Force
	}
}

Describe 'Test-PathExists - File' {
	BeforeEach {
		$File = "TestDrive:\Temp\test.txt"
	}
	
	It 'Test-PathExists with File should exist' {
		if (-Not (Test-Path -Path $File -PathType Leaf))
		{
			New-Item -Path $File -ItemType File
			Set-Content $File -value "My test text."
		}
		
		Test-Path -Path $File -PathType Leaf | Should -Be $true
	}
	
	AfterAll {
		Remove-Item -Path $File -Force
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}