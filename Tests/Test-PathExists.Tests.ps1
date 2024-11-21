BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
}

# Test-PathExists Tests, all should pass
Describe 'Test-PathExists - Parameters' {
	BeforeEach {
		$Path = Join-Path $TestDrive "Temp"
		$cmd = Get-Command Test-MyNetConnection -Server $ServerIP -Port $Port -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName Server -Type System.String -Because "The function requires a destination to test."
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
	BeforeAll {
		$Path = Join-Path $TestDrive "Temp"
	}
	
	It 'Test-PathExists with Folder should exist' {
		if (-Not (Test-Path -Path $Path -PathType Container))
		{
			New-Item -Path $Path -ItemType Directory
		}
		
		Test-Path -Path $Path | Should -Be $true 
	}
	
	AfterAll {
		Remove-Item -Path $Path -Force
	}
}

Describe 'Test-PathExists - File' {
	BeforeAll {
		$File = Join-Path $TestDrive "Temp\test.txt"
	}
	
	It 'should exist' {
		if (-Not (Test-Path -Path $File -PathType Leaf))
		{
			New-Item -Path $File-ItemType File
			Set-Content $File -value "My test text."
		}
		
		Test-Path -Path $File | Should -Be $true
	}
	
	AfterAll {
		Remove-Item -Path $File -Force
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}