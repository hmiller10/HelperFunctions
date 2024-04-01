BeforeAll {
	Set-Location -Path ..\Code\Public
	Import-Module .\HelperFunctions.psd1 -Force
	
	if ($Error)
	{
		$Error.Clear()
	}
	$IPAddress = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Namespace 'root\CIMv2' -Filter "IPEnabled = 'True'" | Where { $_.DefaultIPGateway -ne $null } | Select-Object -Property IPAddress).IPAddress
	[IPAddress]$IPAddress = $IPAddress[0]
}

Describe 'Get-ComputerNameByIP' {

	Context "Get-ComputerNameByIP is called, it must have parameter IPAddress" {
		# Get-ComputerNameByIP Tests, all should pass

		It "Get-ComputerNameByIP should have IPAddress as a mandatory parameter." {
			Get-Command Get-ComputerNameByIP | Should -HaveParameter IPAddress -Because "IPAddress is required to render result."
		}

		It "Should return a string value" {
			$result = Get-ComputerNameByIP -IPAddress $IPAddress
			$result | Should -Not -BeNullOrEmpty
			$result | Should -BeOfType [System.String]
		}
	}
}