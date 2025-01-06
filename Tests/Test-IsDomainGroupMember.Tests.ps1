BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	$localComputer = Get-CimInstance -ClassName Cim_ComputerSystem -Namespace 'root\CIMv2' -ErrorAction Stop
	if ($localComputer.PartOfDomain -eq $false)
	{
		exit;
	}
	else
	{
		$User = "Administrator"
		$GroupName = "Domain Admins"
	}
}

# Test-IsDomainGroupMember Tests, all should pass
Describe "Test-IsDomainGroupMember - Parameters" {
	
	Context "Test AD user membership in AD group" {
		
		
		It "Should Have Parameter User" {
			Get-Command Test-IsDomainGroupMember -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName User -Mandatory -Type System.String
		}
		
		It "Should Have Parameter Group" {
			Get-Command Test-IsDomainGroupMember -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName GroupName -Mandatory -Type System.String
		}

	}
}

Describe "Test-IsDomainGroupMember function output" {
	
	It "Test-IsDomainGroupMember should be of type [System.Boolean]" {
		$result = Test-IsDomainGroupMember -User $Me -GroupName 'Administrators'
		$result | Should -Not -BeNullOrEmpty
		$result | Should -ExpectedType [bool]
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}