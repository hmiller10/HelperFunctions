Function Get-DNfromFQDN
{
	<#
		.EXTERNALHELP HelperFunctions.psm1-Help.xml		
	#>

	[CmdletBinding()]
	[OutputType([String])]
	param (
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $false)]
		[string]$FQDN
	)
	
	Begin
	{
		$Error.Clear()
		Import-Module -Name ActiveDirectory -Force -ErrorAction Stop
	}
	Process
	{
		ForEach ($index In $FQDN)
		{
			$Dot = $index.IndexOf('.')
			$Object = [pscustomobject]@{
				Hostname = $index.Substring(0, $Dot)
				Domain   = $index.Substring($Dot + 1)
			}
			
		}
		
		$DN = Get-ADObject -Identity $Object.HostName -Properties distinguishedName -Server $Object.Domain -ErrorAction Stop | Select-Object -ExpandProperty distinguishedName
		
	}
	End
	{
		If ($null -ne $DN)
		{
			Return $DN
		}
	}
	
} #End function Get-DNfromFQDN





