BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }
	$localComputer = Get-CimInstance -ClassName Cim_ComputerSystem -Namespace 'root\CIMv2' -ErrorAction Stop
	
}

# Test-IsDomainGroupMember Tests, all should pass
Describe "Test-IsDomainGroupMember - Parameters" {
	
	Context "Test AD user membership in AD group" {
		
		if ($localComputer.PartOfDomain -eq $true)
		{
			It "Should Have Parameter User" {
				Get-Command Test-IsDomainGroupMember -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName User -Mandatory -Type System.String
			}
			
			It "Should Have Parameter Group" {
				Get-Command Test-IsDomainGroupMember -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName GroupName -Mandatory -Type System.String
			}
		}
	}
}

Describe "Test-IsDomainGroupMember function output" {
	
	if ($localComputer.PartOfDomain -eq $true)
	{
		$User = "Administrator"
		$GroupName = "Domain Admins"
		
		It "Test-IsDomainGroupMember should be of type [System.Boolean]" {
			$result = Test-IsDomainGroupMember -User $User -GroupName $GroupName
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [bool]
		}
	}
}

AfterAll {
	Remove-Module -Name HelperFunctions -Force
}