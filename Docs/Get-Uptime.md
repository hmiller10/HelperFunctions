﻿# Get-Uptime

## SYNOPSIS
Get computer uptime

## SYNTAX

### Set 1
```
Get-Uptime [[-ComputerName] <String>] [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
This functions uses CIM or WMI, depending upon response to query, to get the lastBootUptime of the computer operating system. It thens converts the lastBootUptime to date and time.

## EXAMPLES

### PS C:\\\> Get-Uptime
PS C:\\\>
```powershell
Get-Uptime
```

### PS C:\\\> Get-Uptime -ComputerName $ComputerName -Credential (Get-Credential)
PS C:\\\>
```powershell
Get-Uptime -ComputerName $ComputerName -Credential (Get-Credential)
```

## PARAMETERS

### ComputerName
If querying remote computer, enter the FQDN of the computer.

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 0
Default Value: [System.Net.Dns]::GetHostByName("LocalHost").HostName
Pipeline Input: false
```

### Credential
Add the PSCredential object

```yaml
Type: PSCredential
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 1
Default Value: 
Pipeline Input: false
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject


## NOTES

### Disclaimer
THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## RELATED LINKS


*Generated by: v3.0.69 (L)PowerShell HelpWriter 2024*
