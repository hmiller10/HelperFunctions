﻿# Get-WinComputerUptime

## SYNOPSIS
Get Windows computer uptime

## SYNTAX

### CompterParamSet
```
Get-WinComputerUptime [[-ComputerName] <String>] [[-Credential] <PSCredential>] [<CommonParameters>]
```

### CimParamSet
```
Get-WinComputerUptime [-Session [<CimSession[]>]] [<CommonParameters>]
```

## DESCRIPTION
This functions uses Windows CIM or WMI, depending upon response to query, to get the lastBootUptime of the computer operating system. It then converts the lastBootUptime to date and time.

## EXAMPLES

### PS C:\\\> Get-WinComputerUptime -Session $CimS
PS C:\\\>
```powershell
PS C:\> Get-WinComputerUptime -Session $CimS
```

### PS C:\\\> Get-WinComputerUptime -ComputerName $ComputerName -Credential (Get-Credential)
PS C:\\\>
```powershell
Get-WinComputerUptime -ComputerName $ComputerName -Credential (Get-Credential)
```

## PARAMETERS

### ComputerName
If querying remote computer, enter the FQDN of the computer.

```yaml
Type: String
Parameter Sets: CompterParamSet
Aliases: 'CN', 'Computer', 'ServerName', 'Server', 'IP'

Required: false
Position: 0
Default Value: [System.Net.Dns]::GetHostByName("LocalHost").HostName
Pipeline Input: False
```

### Credential
Add the PSCredential object

```yaml
Type: PSCredential
Parameter Sets: CompterParamSet
Aliases: 

Required: false
Position: 1
Default Value: 
Pipeline Input: false
```

### Session
WinRM CimSession

```yaml
Type: Microsoft.Management.Infrastructure.CimSession[]
Parameter Sets: CimParamSet
Aliases: CimSession

Required: false
Position: named
Default Value: 
Pipeline Input: False
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


*Generated by: v3.0.71 (L)PowerShell HelpWriter 2025*
