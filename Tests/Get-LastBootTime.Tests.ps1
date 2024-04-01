BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
	if ($Error)
	{
		$Error.Clear()
	}
	$plainTextPwd = "Passw0rd1!!"
	$password = ConvertTo-SecureString -String $plainTextPwd -AsPlainText -Force
	$Creds = New-Object -TypeName System.Management.Automation.PSCredential ('Admin', $password)
	[string]$ComputerName = [System.Net.Dns]::GetHostByName("LocalHost").HostName
	[pscredential]$Credential = $Creds
	$DaysPast = "14"
}


Describe "Get-LastBootTime" {
	
	Context "Test function to get a computers last boot time" {
		# Get-LastBootTime Tests, all should pass
		
		It "Should Have Parameter ComputerName" {
			Get-Command Get-LastBootTime | Should -HaveParameter ComputerName -Type String[]
		}
		
		It "Should Have Parameter Credential" {
			Get-Command Get-LastBootTime | Should -HaveParameter Credential -Type System.Management.Automation.PSCredential
		}
		
		It "Should Have Parameter DaysPast" {
			Get-Command Get-LastBootTime | Should -HaveParameter DaysPast -Type int
		}
		
		It "Should be output a PowerShell Object " {
			$result = Get-LastBootTime -ComputerName $ComputerName -Credential $Credential -DaysPast $DaysPast
			$result | Should -Not -BeNullOrEmpty
			$result | Should -ExpectedType [PSObject]
		}
	}
}