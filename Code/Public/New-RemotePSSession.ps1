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
				 HelpMessage = 'Provide the FQDN of the computer you wish to create a remoting session with')]
		[ValidateScript({
				if ((Test-NetConnection -ComputerName $_ -CommonTCPPort WINRM -InformationLevel Quiet).TcpTestSucceeded -eq $true)
				{
					$true
				}
				else
				{
					throw "Cannot connect to $_ on the default WinRM port from this computer."
				}
			})]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,
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
	
	#endParameterBlock
	
	begin
	{
		$Dot = $index.IndexOf('.')
		$Object = [pscustomobject]@{
			Hostname = $ComputerName.Substring(0, $Dot)
			FQDN     = $ComputerName
			Domain   = $ComputerName.Substring($Dot + 1)
		}
		
		$params = @{
			ComputerName = $ComputerName
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
	}
	process
	{
		if ($PSCmdlet.ShouldProcess($ComputerName, "Creating new PS Session to $ComputerName"))
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
			
		}
		
	}
	end
	{
		return $s
	}
}#End function New-RemotePSSession