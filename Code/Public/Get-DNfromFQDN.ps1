Function Get-DNfromFQDN
{
	<#

	.NOTES
	#------------------------------------------------------------------------------
	#
	# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE
	# ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS
	# WITH THE USER.
	#
	#------------------------------------------------------------------------------
	.SYNOPSIS
		Get object distinguishedName from DNS name
		
	.DESCRIPTION
		This function translates an AD object FQDN to it's distinguishedName
		
	.OUTPUTS
		System.String
		
	.EXAMPLE 
	PS C:\>Get-DNfromFQDN -FQDN mycomputer.my.domain.com


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





