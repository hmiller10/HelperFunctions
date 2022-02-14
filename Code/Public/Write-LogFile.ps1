function global:Write-Logfile
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[String]$LogEntry,
		[Parameter(Mandatory = $true)]
		[String]$LogFile,
		[Parameter(Mandatory = $true)]
		[ValidateSet('1', '2', '3')]
		[uint32]$Level
	)
	
	begin
	{
		$dtmFormatString = "yyyy-MM-dd HH:mm:ss"
		$dtmUTC = [DateTime]::UtcNow
	}
	process
	{
		switch ($level)
		{
			1 { $loglevel = "[INFO]: " }
			2 { $loglevel = "[WARNING]: " }
			3 { $loglevel = "[ERROR]: " }
		}
		
		Write-Verbose -Message $Logentry
	}
	end
	{
		("{0} {1}  {2}" -f $dtmUTC.ToString($dtmFormatString), $LogLevel, $LogEntry) | Out-File -FilePath $LogFile -Append
	}
} #End function Write-Logfile