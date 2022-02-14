<#

.NOTES
#------------------------------------------------------------------------------
#
# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE
# ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS
# WITH THE USER.
#
#------------------------------------------------------------------------------
.SYNOPSIS
	HelperFunctions Module Pester tests

.DESCRIPTION
	This script is a collection of Pester tests used in testing module
	functions to insure proper output

.OUTPUTS
	None

.EXAMPLE 
.\HelperFunctions.Tests.ps1


#>

###########################################################################
#
#
# AUTHOR:  Heather Miller
#
# VERSION HISTORY:
# 1.0 14-September-2021 - Initial release
#
# 
###########################################################################

BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	If ($Error) { $Error.Clear() }
	
	$IPAddress = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Namespace 'root\CIMv2' -Filter "IPEnabled = 'True'" | Where-Object -Property { $_.DefaultIPGateway -ne $null } | Select-Object -Property IPAddress).IPAddress[0]
	$Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	[string]$key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
	[string]$value = "CurrentBuild"
}


Describe "Get-ReportDate" {
	Context "when function Get-ReportDate is called" {
		# Get-ReportDate Tests, all should pass
		It "Get-ReportDate should return a date String in the format 'yyyy-MM-dd'" {
			Get-ReportDate | Should -BeOfType [String]
		}
		
		It "should return [DateTime] in the format yyyy-MM-dd" {
			Get-ReportDate | Should -Be $(Get-Date -Format "yyyy-MM-dd")
		}
	}
}

Describe "Get-TodaysDate" {
	Context "when function Get-TodaysDate is called" {
		# Get-TodaysDate Tests, all should pass
		It "Get-TodaysDate should return a date String in the format 'MM-dd-yyyy'" {
			Get-TodaysDate | Should -BeOfType [String]
		}
		
		It "should return [DateTime] in the format MM-dd-yyyy" {
			Get-TodaysDate | Should -BeLike $(Get-Date -Format "MM-dd-yyyy")
		}
	}
}

Describe "Get-UtcTime" {
	Context "when function Get-UtcTime is called" {
		# Get-UtcTime Tests, all should pass
		It "should return [System.DateTime]::UtcNow in GMT time" {
			Get-UtcTime | Should -BeOfType System.DateTime
		}
		
		It "should return [DateTime]::UtcNow" {
			Get-UTCTime | Should -BeLike $([DateTime]::UtcNow)
		}
	}
}

Describe "Test-IsAdmin" {
	Context "when function Test-IsAdmin is called" {
		It "should return $True" {
			# Test-IsAdmin Tests, all should pass
			Test-IsAdmin | Should -Be $True -Because "Test must run with elevated rights."
			$result = Test-IsAdmin
			$result | Should -BeOfType [bool]
		}
	}
}

Describe 'Test-IsValidIPAddress' {
	
	Context "IPAddress Validation" {
		
		It "Should be of type [bool]" {
			# Test-IsValidIPAddress Tests, all should pass
			Get-Command Test-IsInstalled | Should -HaveParameter Program -Type String
			Get-Command Test-IsInstalled | Should -HaveParameter Program -Mandatory
			$result = Test-IsValidIPAddress -IP $IPAddress
			$result | Should -Not -BeNullOrEmpty -Because "$null is not a parsable value."
			$result | Should -BeOfType [bool]
		}
	}
}

Describe 'Test-IsInstalled' {
	
	Context "Program installation verification" {
		# Test-IsInstalled Tests, all should pass
		
		It "Test-IsInstalled should have a parameter Program" {
			Get-Command Test-IsInstalled | Should -HaveParameter Program -Type String
			Get-Command Test-IsInstalled | Should -HaveParameter Program -Mandatory
		}
		
		It "Should be of type [bool]" {
			$result = Test-IsInstalled -Program $Program
			$result | Should -BeOfType [bool]
		}
	}
}

Describe 'Get-MyInvocation' {
	
	Context "Return MyInvocation" {
		
		It "Should return $($MyInvocation)" {
			# Get-MyInvocation Tests, all should pass
			$result = Get-MyInvocation
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.Management.Automation.InvocationInfo]
		}
	}
}

Describe 'Get-DNfromFQDN' {
	
	Context "Return Get-DNfromFQDN" {
		# Get-DNfromFQDN Tests, all should pass
		
		It "Get-DNfromFQDN should have parameter DomainFQDN." {
			Get-Command Get-DNfromFQDN | Should -HaveParameter DomainFQDN -Type String
			Get-Command Get-DNfromFQDN | Should -HaveParameter DomainFQDN -Mandatory
		}
		
		It "Should be of type [System.String]" {
			$result = Get-DNfromFQDN -DomainFQDN $Computer
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}

Describe 'Get-FQDNfromDN' {
	
	Context "Return Get-FQDNfromDN" {
		# Get-FQDNfromDN Tests, all should pass
		
		It "Get-FQDNfromDN should have parameter DistinguishedName." {
			Get-Command Get-FQDNfromDN | Should -HaveParameter DistinguishedName -Type String -Mandatory
		}
		
		It "Should be of type [System.String]" {
			$result = Get-FQDNfromDN -DistinguishedName $Computer
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [System.String]
		}
	}
}

Describe 'Get-ComputerNameByIP' {
	
	Context "Get-ComputerNameByIP is called, it must have parameter IPAddress" {
		# Get-ComputerNameByIP Tests, all should pass
		
		It "Get-ComputerNameByIP should have IPAddress as a mandatory parameter." {
			Get-Command Get-ComputerNameByIP | Should -HaveParameter IPAddress -Mandatory -Because "IPAddress is required to render result."
		}
		
		It "Should return a string value" {
			$result = Get-ComputerNameByIP -IPAddress $IPAddress
			$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType [System.String]
		}
	}
}

Describe 'Get-IPByComputerName' {
	
	Context "When Get-IPByComputerName is called" {
		
		# Get-IPByComputerName Tests, all should pass
		
		It "Get-IPByComputerName should have parameter ComputerName" {
			Get-Command Get-IPByComputerName | Should -HaveParameter ComputerName -Type [System.String[]]
			Get-Command Get-IPByComputerName | Should -HaveParameter ComputerName -Mandatory -Because "If IP address is valid it should return the assigned device."
		}
		
		
		It "Get-IPByComputerName should return the IP address of the computer passed into the function" {
			$result = Get-IPByComputerName -ComputerName $Computer
			$result | Should -Not -BeNullOrEmpty -Because "Cannot resolve an IP address if the computer name is invalid."
			$result | Should -BeOfType [PSCustomObject]
		}
	}
}

Describe "Test-RegistryValue" {
	
	Context "Test pre-defined registry key and value" {
		# Test-RegistryValue Tests, all should pass
		
		It "Should Have Parameter Path" {
			Get-Command Test-RegistryValue | Should -HaveParameter Path -Mandatory -Type System.Object
		}
		
		It "Should Have Parameter Value" {
			Get-Command Test-RegistryValue | Should -HaveParameter Value -Mandatory -Type System.Object
		}
		
		It "Should be of type [System.Boolean]" {
			$result = Test-RegistryValue -Path $key -Value $value
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [bool]
		}
	}
}

Describe "Get-Uptime" {
	
	Context "Get computer uptime" {
		# Get-Uptime Tests, all should pass
		
		It "Should Have Parameter Path" {
			Get-Command Get-Uptime | Should -HaveParameter ComputerName -Type System.String
		}
		
		It "Should Have Parameter Value" {
			Get-Command Get-Uptime | Should -HaveParameter Credential -Type System.Management.Automation.PsCredential
		}
		
		It "Should be of type [PSCustomObject]" {
			$result = Get-Uptime
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [PSCustomObject]
		}
	}
}