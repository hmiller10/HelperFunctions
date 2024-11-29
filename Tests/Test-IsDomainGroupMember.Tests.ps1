BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error) { $Error.Clear() }

	if ((Get-CimInstance -ClassName CIM_ComputerSystem -NameSpace 'root\CIMv2').partOfDomain -eq $false)
	{
		try
		{
			$Drive = Get-PSDrive -Name TestDrive -ErrorAction Stop
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
		   
		If ($Drive) { Remove-PSDrive -Name TestDrive -Force -ErrorAction Continue}
		exit
	}
	else
	{
		try
		{
			$Drive = Get-PSDrive -Name TestDrive -ErrorAction Stop
		}
		catch
		{
			$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
			Write-Error $errorMessage -ErrorAction Continue
		}
		
		If ($Drive) { Remove-PSDrive -Name TestDrive -Force -ErrorAction Continue }
		$Me = $env:USERNAME
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