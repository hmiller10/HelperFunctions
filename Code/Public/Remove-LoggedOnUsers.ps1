function global:Remove-LoggedOnUsers
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	
	[CmdletBinding(DefaultParameterSetName = 'ComputerParameterSet',
				ConfirmImpact = 'Medium',
				SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ParameterSetName = 'ComputerParameterSet',
				 Mandatory = $true,
				 HelpMessage = 'Type the fully qualified domain name of the computer.')]
		[Alias('CN', 'MachineName', 'Computer')]
		[string]$ComputerName,
		[Parameter(ParameterSetName = 'ComputerParameterSet',
				 Mandatory = $true,
				 HelpMessage = 'Add the credential object or use (Get-Credential)')]
		[pscredential]$Credential,
		[Parameter(ParameterSetName = 'SessionParameterSet',
				 Mandatory = $true,
				 HelpMessage = 'Include PSSession variable.')]
		[System.Management.Automation.Runspaces.PSSession]$RemoteSession
	)
	
	switch ($PSCmdlet.ParameterSetName)
	{
		"ComputerParameterSet" {
			if ($pscmdlet.ShouldProcess($ComputerName))
			{
				$userinit = Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock { param ($ComputerName); ((quser /server $ComputerName) -replace '\s{2,}', ',' | ConvertFrom-Csv) } -ArgumentList $ComputerName
				$loggedonusers = @()
				foreach ($session in $userinit)
				{
					$loggedonusers += $Session.UserName
					if ($loggedonusers.Count -ge 1)
					{
						$loggedonusers.foreach({
								$user = $_
								Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
									param ($session,
										$ComputerName); logoff.exe $session.ID /server $ComputerName $user /V
								} -ArgumentList $session, $ComputerName
							})
					}
					
				}
			}
		}
		"SessionParameterSet" {
			if ($pscmdlet.ShouldProcess($RemoteSession.ComputerName))
			{
				$userinit = Invoke-Command -Session $RemoteSession -ScriptBlock { param ($ComputerName); ((quser /server $ComputerName) -replace '\s{2,}', ',' | ConvertFrom-Csv) } -ArgumentList $ComputerName
				$loggedonusers = @()
				foreach ($session in $userinit)
				{
					$loggedonusers += $Session.UserName
					if ($loggedonusers.Count -ge 1)
					{
						$loggedonusers.foreach({
								$user = $_
								Invoke-Command -Session $RemoteSession -ScriptBlock {
									param ($session,
										$ComputerName); logoff.exe $session.ID /server $ComputerName $user /V
								} -ArgumentList $session, $ComputerName
							})
					}
					
				}
			}
		}
	}
} #end Remove-LoggedOnUsers