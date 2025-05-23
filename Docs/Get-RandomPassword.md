﻿# Get-RandomPassword

## SYNOPSIS
Create random, secure password

## SYNTAX

### Set 1
```
Get-RandomPassword [-Length] <Int32> [-IncludeLCase] [-IncludeUCase] [-IncludeNumbers] [-IncludeSpecialChar] [-NoSimilarCharacters] [<CommonParameters>]
```

## DESCRIPTION
This function takes the input parameters, using Switch statements it will generate a random, secure password of the length as determined by the function call.

## EXAMPLES

### PS C:\\\> $pw = Get-RandomPassword -Length 25 -IncludeLCase $true -IncludeUCase $true -IncludeNumbers $true -IncludeSpecialChar $true  -NoSimilarCharacters $true

```powershell
C:\PS> Get-RandomPassword
```

## PARAMETERS

### Length


```yaml
Type: Int32
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 0
Default Value: 
Pipeline Input: True (ByValue)
```

### IncludeLCase


```yaml
Type: Boolean
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 1
Default Value: 
Pipeline Input: True (ByValue)
```

### IncludeUCase


```yaml
Type: Boolean
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 2
Default Value: 
Pipeline Input: True (ByValue)
```

### IncludeNumbers


```yaml
Type: Boolean
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 3
Default Value: 
Pipeline Input: True (ByValue)
```

### IncludeSpecialChar


```yaml
Type: Boolean
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 4
Default Value: 
Pipeline Input: True (ByValue)
```

### NoSimilarCharacters


```yaml
Type: Boolean
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 5
Default Value: 
Pipeline Input: True (ByValue)
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32


### System.Boolean


## OUTPUTS

### System.String


## NOTES

### Disclaimer
THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## RELATED LINKS


*Generated by: v3.0.71 (L)PowerShell HelpWriter 2025*
