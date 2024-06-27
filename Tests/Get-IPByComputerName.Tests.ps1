BeforeAll {
	if ($Error) { $Error.Clear() }

}

Describe 'Get-IPByComputerName' {
     Mock -CommandName Get-IPByComputerName -MockWith { 
          $Computer = [System.Net.Dns]::GetHostByName("LocalHost").HostName
          [pscustomobject]@{ ComputerName = $Computer }
     }  -Module HelperFunctions

	Context "When Get-IPByComputerName is called" {
		# Get-ComputerNameByIP Tests, all should pass
		It "Get-IPByComputerName should have parameter ComputerName" {
			Get-Command -Name Get-IPByComputerName -ComputerName $Computer -Module HelperFunctions -CommandType Function | Should -HaveParameter -ParameterName ComputerName
		}

	}
	Context "Test Get-IPByComputerName output" {
		It "Get-IPByComputerName should return the IP address of the computer passed into the function" {
			
		     It -Name 'when IPv4Only is passed, it returns the IPv4 IP Address' -Test { Get-IPByComputerName -ComputerName $Computer -IPV4only | Should -BeOfType PSCustomObject }

		     It -Name 'when IPv6Only is passed, it returns the IPv6 IP Address' -Test { Get-IPByComputerName -ComputerName $Computer -IPv6Only | Should -BeOfType PSCustomObject }
		}
	}

}

AfterAll {
	#Remove-Module -Name HelperFunctions -Force
}