function global:Write-Logfile
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml
		#>

	[CmdletBinding()]
	[OutputType([System.IO.Stream])]
	[Alias('fnWrite-LogFile')]
	param
	(
		[Parameter(Mandatory = $true,
		           HelpMessage = 'Write the text entry to be logged')]
		[ValidateNotNullOrEmpty()]
		[String]
		$LogEntry,
		[Parameter(Mandatory = $true,
		           HelpMessage = 'Specify the path and file name to the log file')]
		[ValidateScript({Test-Path $_})]
		[String]
		$LogFile,
		[Parameter(Mandatory = $true)]
		[ValidateSet('Info', 'Warning', 'Error', 'Debug', 'Failure', 'Success')]
		[LogLevel]
		$LogLevel
	)
	
	begin
	{
		$dtmFileFormatString = "yyyy-MM-dd_HH-mm-ss"
		$dtmUTC = (Get-Date).ToUniversalTime().ToString($dtmFileFormatString)
	}
	process
	{
		switch ($LogLevel)
		{
			'Info' { $type = "[INFO]" }
			'Warning' { $type = "[WARNING]" }
			'Error' { $type = "[ERROR]" }
			'Critical' { $type = "[CRITICAL]" }
			'Debug' { $type = "[DEBUG]" }
			'Failure' { $type = "[FAILURE]" }
			'Success' { $type = "[SUCCESS]" }
		}
		
		Write-Verbose -Message $LogEntry
	}
	end
	{
		("{0}`t{1}`t{2}" -f $dtmUTC, $type, $LogEntry) | Out-File -FilePath $LogFile -Append
	}
} #End function Write-Logfile