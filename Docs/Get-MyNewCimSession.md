﻿# Get-MyNewCimSession

## SYNOPSIS
Create CIM session to computer

## SYNTAX

### Set 1
```
Get-MyNewCimSession [-ServerName] <String> [-Credential] <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
This functions creates a new Microsoft Common Information Model remote session to the specified computer. It will default to using WSMan. If that fails an attempt to establish a session using DCOM will be tried.

## EXAMPLES

### PS\> Get-MyNewCimSession -Server <ServerFQDN\> -Credential PSCredential
PS C:\\\>
```powershell
.\Get-MyNewCimSession.ps1 -ServerName user.example.com -Credential (Get-Credential)
```

## PARAMETERS

### ServerName
FQDN of remote server

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 0
Default Value: 
Pipeline Input: false
```

### Credential
PSCredential object

```yaml
Type: PSCredential
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 1
Default Value: 
Pipeline Input: false
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Microsoft.Management.Infrastructure.CimSession


## NOTES

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## RELATED LINKS


*Generated by: PowerShell HelpWriter 2023 v3.0.58*