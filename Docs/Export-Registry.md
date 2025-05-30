﻿# Export-Registry

## SYNOPSIS
Export registry key to file

## SYNTAX

### Parameter Set 1
```
Export-Registry [<CommonParameters>]
```

## DESCRIPTION
This function will export the specified registry key to a PSCustomobject and write the output to the specified file and file type.

## EXAMPLES

### PS C:\\\> Export-Registry -Path 'HKLM:\\SOFTWARE\\Microsoft\\Policies' -Outfile 'C:\\Temp\\policiesHive.csv'

```powershell
C:\PS> Export-Registry
```

## PARAMETERS

### Path
The registry hive path to be exported.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### OutputFile
Enter the path where the registry key should be exported to.

```yaml
Type: System.IO.FileInfo
Parameter Sets: (All)
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: False
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.IO.FileInfo


## NOTES

### Disclaimer
THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## RELATED LINKS

[Related Topic](Http://jdhitsolutions.com/blog)


*Generated by: v3.0.71 (L)PowerShell HelpWriter 2025*
