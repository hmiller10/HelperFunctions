function Remove-LoggedOnUsers
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
		[Alias('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[string[]]$ComputerName,
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
			if ($PSBoundParameters.ContainsKey('ComputerName') -and ($null -ne $PSBoundParameters["ComputerName"]) -and ($PSBoundParameters["ComputerName"].Count -gt 1))
			{
				$ComputerName = $ComputerName -split (",")
			}
			elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($null -ne $PSBoundParameters["ComputerName"]) -and ($PSBoundParameters["ComputerName"].Count -eq 1))
			{
				$ComputerName = $PSBoundParameters["ComputerName"]
			}
			else
			{
				$ComputerName = [System.Net.Dns]::GetHostByName("LocalHost").HostName
			}

			foreach ($Computer in $ComputerName)
			{
				if ($pscmdlet.ShouldProcess($Computer))
				{
					$userinit = Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock { ((quser /server $using:Computer) -replace '\s{2,}', ',' | ConvertFrom-Csv) }
					$loggedonusers = @()
					foreach ($session in $userinit)
					{
						$loggedonusers += $Session.UserName
						$ID = $session.ID
						if ($loggedonusers.Count -ge 1)
						{
							$loggedonusers.foreach({
								$user = $_
								Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock {
									logoff.exe $using:ID /server $using:Computer $using:user /V
								}
							})
						}
					}
				}
			}
		}
		"SessionParameterSet" {
			if ($pscmdlet.ShouldProcess($RemoteSession))
			{
				$Server = $RemoteSession.ComputerName
				$userinit = Invoke-Command -Session $RemoteSession -ScriptBlock {((quser /server $using:Server) -replace '\s{2,}', ',' | ConvertFrom-Csv) }

				$loggedonusers = @()
				foreach ($session in $userinit)
				{
					$loggedonusers += $Session.UserName
					$ID = $session.ID
					if ($loggedonusers.Count -ge 1)
					{
						$loggedonusers.foreach({
								$user = $_
								Invoke-Command -Session $RemoteSession -ScriptBlock {
									logoff.exe $using:ID /server $using:Server $using:user /V
								}
							})
					}
				}
			}
		}
	}
} #end Remove-LoggedOnUsers