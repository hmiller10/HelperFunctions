function global:New-RemotePSSession
{
<#
	.EXTERNALHELP HelperFunctions.psm1-Help.xml
#>
	
	[CmdletBinding()]
	[OutputType([System.Management.Automation.Runspaces.PSSession])]
	param
	(
		[Parameter(Mandatory = $true,
				 ValueFromPipeline = $true,
				 ValueFromPipelineByPropertyName = $true,
				 HelpMessage = 'Provide the FQDN of the computer you wish to create a remoting session with')]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({
				$ComputerName | ForEach-Object {
					if ((Test-NetConnection -ComputerName $_ -CommonTCPPort WINRM -ErrorAction SilentlyContinue).TcpTestSucceeded -eq $true)
					{
						return $true
					}
					else
					{
						Write-Error "Cannot connect to $_."
					}
				}
			})]
		[Alias ('CN', 'Computer', 'ServerName', 'Server', 'IP')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $false,
				 HelpMessage = 'Enter username. You will be prompted for Password')]
		[ValidateNotNull()]
		[System.Management.Automation.PSCredential]$Credential = [System.Management.Automation.PSCredential]::Empty,
		[Parameter(Mandatory = $false,
				 ValueFromPipeline = $false,
				 HelpMessage = 'Session requires proxy access is true.')]
		[Switch]$EnableNetworkAccess,
		[Switch]$RequiresProxy
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
		
	}
	process
	{
		foreach ($Computer in $ComputerName)
		{
			$Dot = $index.IndexOf('.')
			$Object = [pscustomobject]@{
				Hostname = $Computer.Substring(0, $Dot)
				FQDN     = $Computer
				Domain   = $Computer.Substring($Dot + 1)
			}
			
			$params = @{
				ComputerName = $Computer
				Name	        = $Object.HostName
				ErrorAction  = 'Stop'
			}
			
			if ($PSBoundParameters.ContainsKey('Credential'))
			{
				$params.Add('Credential', $Credential)
			}
			
			if ($PSBoundParameters.ContainsKey('RequiresProxy'))
			{
				$option = New-PSSessionOption -ProxyAccessType NoProxyServer
				$params.Add('SessionOption', $Option)
			}
			
			if ($PSBoundParameters.ContainsKey('EnableNetworkAccess'))
			{
				$params.Add('EnableNetworkAccess', $true)
			}
			
			if ($PSCmdlet.ShouldProcess($Computer, "Creating new PS Session to $Computer"))
			{
				
				try
				{
					$s = New-PSSession @params
				}
				catch
				{
					switch -Wildcard ($_.Exception.Message)
					{
						"*2150858770*"                       { $ErrorMessage = 'Offline' }
						"*server name cannot be resolved*"   { $ErrorMessage = 'ServerName cannot be resolved' }
						"*2150859046*"                       { $ErrorMessage = 'PS Connect Failed' }
						"*2150859193*"                       { $ErrorMessage = 'Asset Not Found' }
						"*Access is denied*"                 { $ErrorMessage = 'Access Denied' }
						"*specified computer name is valid*" { $ErrorMessage = 'Server Offline' }
						"*winrm quickconfig*"                { $ErrorMessage = 'PsRemoting Not Enabled' }
						"*firewall exception*"               { $ErrorMessage = 'PsRemoting Not Enabled' }
						Default                              { $ErrorMessage = 'PS connect Error' }
					}
					$s = $ErrorMessage
				}
				
				return $s
			}
		}
	}
	end
	{ }
} #End function New-RemotePSSession