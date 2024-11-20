BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }

	if ((Get-CimInstance -ClassName CIM_ComputerSystem -NameSpace 'root\CIMv2').partOfDomain -eq $false)
	{
		exit
	}
	else
	{
		$Me = $env:USERNAME
	}
	
}


Describe "Test-IsDomainGroupMember" {
	
	Context "Test AD user membership in AD group" {
		# Test-IsDomainGroupMember Tests, all should pass
		
		It "Should Have Parameter User" {
			Get-Command Test-IsDomainGroupMember | Should -HaveParameter -ParameterName User -Mandatory -Type System.String
		}
		
		It "Should Have Parameter Group" {
			Get-Command Test-IsDomainGroupMember | Should -HaveParameter -ParameterName GroupName -Mandatory -Type System.String
		}
		
		It "Should be of type [System.Boolean]" {
			$result = Test-IsDomainGroupMember -User $Me -GroupName 'Administrators'
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [bool]
		}
	}
}

AfterAll {
	Remote-Module -Name HelperFunctions -Force
}