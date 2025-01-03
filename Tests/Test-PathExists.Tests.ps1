BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }

	BeforeAll {
		
	}
}

# Test-PathExists Tests, all should pass
Describe 'Test-PathExists - Parameters' {
	
	BeforeEach {
		$Path = "TestDrive:\Temp"
		$PathType = "Folder"
	}
	It "Test-PathExists should have parameter Path." {
		Get-Command Test-PathExists | Should -HaveParameter -ParameterName Path -Type System.String -Mandatory
	}
	
	It "Test-PathExists should have parameter PathType." {
		Get-Command Test-PathExists | Should -HaveParameter -ParameterName PathType -Type System.String -Mandatory
	}

	AfterEach {
		$null = - $Path
		$null = $PathType
	}

}

# Pester test to check for the existence of the file or folder
Describe 'Test-PathExists - Folder' {

	BeforeEach {
		$Path = "TestDrive:\Temp"
		$PathType = "Folder"
	}

	It "Folder should exist" {
		if (-Not (Test-Path -Path $Path -PathType Container)) {
			New-Item -Path $Path -ItemType Directory
		}
		Test-Path -Path $Path | Should -Be $true
	}
	
	It "Folder should be of type [System.String]" {
		$result1 = Test-PathExists -Path $Path -PathType Folder
		$result1 | Should -Not -BeNullOrEmpty
		$result1 | Should -BeOfType [System.String]
	}
	
	AfterEach {
		Remove-Item -Path $Path -Force
		$null = - $Path
		$null = $PathType
	}
}

Describe 'Test-PathExists - File' {
	BeforeEach {
		$Path = "TestDrive:\Test.txt"
		$PathType = "File"
		$File = "TestDrive:\test.txt"
		Set-Content $File -value "My test1 file text."
	}
	
	It "File should exist" {
		if (-Not (Test-Path -Path $File -PathType Leaf)) {
			New-Item -Path $File -ItemType File
		}
		Test-Path -Path $File | Should -Be $true
	}
	
	It "File should be of type [System.String]" {
		$result2 = Test-PathExists -Path $File -PathType File
		$result2 | Should -Not -BeNullOrEmpty
		$result2 | Should -BeOfType [System.String]
	}
	
	AfterEach {
		if ((Test-Path -Path $File -PathType Leaf) -eq $true) {
			Get-ChildItem -Path $File -File | Remove-Item -Force
		}

		Remove-Item -Path $File -Force
		$null = $Path
		$null = $PathType
		$null = $file
		
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