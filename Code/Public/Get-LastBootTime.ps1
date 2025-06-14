﻿function Get-LastBootTime
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml
	#>

	[CmdletBinding(SupportsShouldProcess = $true)]
	[OutputType([PSObject])]
	param
	(
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 HelpMessage = 'Enter the name of the computer to check or pipe the input to the function')]
		[Alias('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Enter the PS credential object variable name')]
		[ValidateNotNull()]
		[Alias('Cred')]
		[System.Management.Automation.PSCredential]$Credential,
		[Parameter(Mandatory = $false,
				 HelpMessage = 'Enter the number of days past or pipe input')]
		[ValidateNotNullOrEmpty()]
		[int]$DaysPast
	)

	begin
	{
		
		if ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -gt 1))
		{
		    $ComputerName = $ComputerName -split (",")
		}
		elseif ($PSBoundParameters.ContainsKey('ComputerName') -and ($PSBoundParameters["ComputerName"] -ne $null) -and ($PSBoundParameters["ComputerName"].Count -eq 1))
		{
			$ComputerName = $PSBoundParameters["ComputerName"]
		}

		if (($PSBoundParameters.ContainsKey('DaysPast') -and ($null -ne $PSBoundParameters["DaysPast"])))
		{
			$TimePast = (Get-Date).AddDays(-$DaysPast)
		}
		else
		{
			$TimePast = (Get-Date).AddDays(-1)
		}

	}
	process
	{
		foreach ($Computer in $ComputerName)
		{
			if ($PSCmdlet.ShouldProcess($Computer))
			{
				$params1 = @{
					ComputerName = $Computer
					Count	   = 1
					Quiet	   = $true
					ErrorAction  = 'Stop'
				}

				if (($PSBoundParameters.ContainsKey("Credential")) -and ($null -ne $PSBoundParameters["Credential"]))
				{
					$params1.Add('Credential', $Credential)
				}

				if ((Test-Connection @params1) -eq $true)
				{
					$params2 = @{
						ComputerName = $Computer
						ErrorAction  = 'Stop'
					}

					if (($PSBoundParameters.ContainsKey("Credential")) -and ($null -ne $PSBoundParameters["Credential"]))
					{
						$params2.Add('Credential', $Credential)
					}

					try
					{
						if ($PSCmdlet.ShouldProcess($Computer))
						{
							$events = Get-WinEvent @params2 -FilterHashtable @{
								LogName   = 'System';
								ID	     = '1074'
								StartTime = $TimePast
							}
						}

					}
					catch
					{
						[pscustomobject]@{
							ComputerName = "There were no event ID 1074 events of $($Computer) within the specified or default time period."
						}
					}
				}
				else
				{
					[pscustomobject]@{
						ComputerName = "Unable to reach $($Computer)"
					}
				}
			}
		}
	}
	end
	{
		if ($null -ne $events)
		{
			Write-Output $events
		}
	}
} #end function Get-LastBootTime