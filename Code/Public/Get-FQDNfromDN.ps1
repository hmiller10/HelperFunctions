function global:Get-FQDNfromDN
{
		<#
			.EXTERNALHELP HelperFunctions.psm1-Help.xml		
		#>
	
	[CmdletBinding()]
	[OutputType([String])]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DistinguishedName
    )

    Begin { }
    Process
    {
        
        if ([string]::IsNullOrEmpty($DistinguishedName) -eq $true)
        {
            return $null
        }
        else
        {
            $colSplit = $DistinguishedName.Split(",")
            $computerName = $colSplit[0].Trim("CN=")
            
            Try
            {
                $FQDN = [System.Net.Dns]::GetHostByName($computerName).HostName
            }
            Catch
            {
                $ErrorMessage = $Error[0].Exception.Message
            }
        }

    }
    End
    {
        if ($FQDN)
        {
            Return $FQDN
        }
        elseif ($Error[0].Exception.Message -match "No such host is known")
        {
            Return "Host is not registered in DNS"
        } 
    }
	
} #End function Get-FQDNfromDN