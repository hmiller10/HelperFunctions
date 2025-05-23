﻿# Invoke-CreateZipFile

## SYNOPSIS
Uses .Net class to create compressed archive

## SYNTAX

### Set 1
```
Invoke-CreateZipFile [-CompressedFileName] <String> [-FileToCompress] <String> [-EntryName] <String> [-ArchiveMode] <String> [<CommonParameters>]
```

## DESCRIPTION
This function requires .Net 4.5.2 or later and will use native .Net technologies to create, read or update a .zip archive file using the specified compression level

## EXAMPLES

### PS C:\\\> Invoke-CreateZipFile -CompressedFileName myZip.zip -FileToCompress 'Test1.ps1 -EntryName Test1 -ArchiveMode Create

```powershell
C:\PS> Invoke-CreateZipFile
```

### PS C:\\\> Invoke-CreateZipFile -CompressedFileName myZip.zip -FileToCompress 'Test2.ps1 -EntryName Test2 -ArchiveMode Update

```powershell
C:\PS> Invoke-CreateZipFile
```

## PARAMETERS

### CompressedFileName
Zip file name

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 0
Default Value: 
Pipeline Input: False
```

### FileToCompress
File system file to add to zip file

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 1
Default Value: 
Pipeline Input: False
```

### EntryName
Zip entry name

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 2
Default Value: 
Pipeline Input: False
```

### ArchiveMode
Mode of zip archival process (Create, Update, Read)

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 3
Default Value: 
Pipeline Input: False
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None


## OUTPUTS

### System.IO.Compression.ZipFile


## NOTES

### Disclaimer
THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## RELATED LINKS


*Generated by: v3.0.71 (L)PowerShell HelpWriter 2025*
