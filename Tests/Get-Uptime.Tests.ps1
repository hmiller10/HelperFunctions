BeforeAll {
	Import-Module -Name HelperFunctions -Force
	Import-Module -Name Pester -Force
    if ($Error) { $Error.Clear()
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