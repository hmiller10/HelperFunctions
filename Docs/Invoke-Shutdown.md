﻿# Invoke-Shutdown

## SYNOPSIS
Shutdown specified computer(s) cleanly as if doing through GUI

## SYNTAX

### Parameter Set 1
```
Invoke-Shutdown [-ComputerName [<string[]>]]
```

## DESCRIPTION
This function leverage CIM sessions, pre-defined ENUMs and credentials to shutdown or reboot the specified computers.

## EXAMPLES

### Invoke-Shutdown -ComputerName computer1.domain.com -ShutdownType Reboot -Force -MajorReasonCode APPLICATION -MinorReasonCode HOTFIX -Comment 'Application patch install'

```powershell
Invoke-Shutdown -ComputerName computer1.domain.com -ShutdownType Reboot -Force -MajorReasonCode APPLICATION -MinorReasonCode HOTFIX -Comment 'Application patch install'
```

## PARAMETERS

### ComputerName
Name or FQDN of computers to shutdown or reboot

```yaml
Type: string[]
Parameter Sets: Parameter Set 1
Aliases: 'CN', 'Computer', 'Server',  'ServerName', 'IP'

Required: false
Position: named
Default Value: $env:COMPUTERNAME
Pipeline Input: True (ByPropertyName, ByValue)
```

### ShutdownType
'Logoff', 'Shutdown', 'Reboot', 'PowerOff'

```yaml
Type: string
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### Force


```yaml
Type: Switch
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### Wait


```yaml
Type: Switch
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### MajorReasonCode
Select from validate set

```yaml
Type: Shutdown_MajorReason
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### MinorReasonCode
Select from validate set

```yaml
Type: Shutdown_MinorReason
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### Unplanned


```yaml
Type: Switch
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### Credential


```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

## INPUTS

## OUTPUTS

## NOTES

### Disclaimer
THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## RELATED LINKS


*Generated by: v3.0.71 (L)PowerShell HelpWriter 2025*
