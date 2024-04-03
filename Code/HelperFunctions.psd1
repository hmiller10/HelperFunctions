#
# Module manifest for module 'HelperFunctions'
#
# Generated by: Heather Miller
#
# Generated on: 12/9/2020
#

@{

	# Script module or binary module file associated with this manifest
	RootModule		   = 'HelperFunctions.psm1'

	# Version number of this module.
	ModuleVersion	        = '2.3.4'

	# ID used to uniquely identify this module
	GUID			        = 'c5fd1931-b11e-42ff-b94f-8b0095395e6b'

	# Author of this module
	Author			   = 'Heather Miller'

	# Company or vendor of this module
	CompanyName		   = ''

	# Copyright statement for this module
	Copyright		        = '(c) 2018-2024. All rights reserved.'

	# Description of the functionality provided by this module
	Description		   = 'This module contains a number of functions PowerShell scripts and scriptlets that make it quicker to write new code utilizing functions to handle common methods.'

	# Name of the Windows PowerShell host required by this module
	PowerShellHostName     = ''

	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion  = ''

	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '4.5'

	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion		   = '2.0.50727'

	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture  = 'None'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules	   = @()

	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies     = @()

	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess	   = '.\ScriptsToProcess\ShtdnRebootEnums.ps1'

	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess	        = @()

	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess	   = @("HelperFunctions.Format.ps1xml")

	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
	NestedModules	        = @()

	# Functions to export from this module
	FunctionsToExport	   = @(
		'Add-DataTable',
		'Export-PSCredential',
		'Export-Registry',
		'Get-ComputerNameByIP',
		'Get-DNfromFQDN',
		'Get-DomainFromDN',
		'Get-FQDNfromDN',
		'Get-IISWebCertificates',
		'Get-IPByComputerName',
		'Get-LastBootTime',
		'Get-MyInvocation',
		'Get-MyNewCimSession',
		'Get-RandomPassword',
		'Get-ReportDate',
		'Get-SIDforDomainUser',
		'Get-TimeStamp',
		'Get-TodaysDate',
		'Get-Uptime',
		'Get-UserFromSID',
		'Get-UTCTime',
		'Import-PSCredential',
		'Invoke-CreateZipFile',
		'Invoke-ExpandZipArchive',
		'Invoke-ZipDirectory',
		'New-RemotePSSession',
		'Remove-LoggedOnUsers',
		'Test-IsAdmin',
		'Test-IsGroupMember',
		'Test-IsInstallad',
		'Test-IsValidIPAddress',
		'Test-MyNetConnection',
		'Test-PathExists',
		'Test-RegistryValue',
		'Write-Logfile'
	) #For performance, list functions explicitly

	# Cmdlets to export from this module
	CmdletsToExport	   = '*'

	# Variables to export from this module
	VariablesToExport	   = '*'

	# Aliases to export from this module
	AliasesToExport	   = @(
		'Check-Path',
		'Create-ZipArchive',
		'Create-ZipFile',
		'Expand-ZipArchive',
		'fnCheck-Path',
		'fnGet-MyInvocation',
		'fnMake-Table',
		'fnNew-CimSession',
		'fnGet-ReportDate',
		'fnGet-TodaysDate',
		'fnUTC-Now',
		'fnTest-IsValidIPAddress',
		'fnTest-NetConnection',
		'fnWrite-LogFile',
		'Get-FileDate',
		'Make-Table',
		'UTC-Now'
	) #For performance, list alias explicitly

	# DSC class resources to export from this module.
	#DSCResourcesToExport = ''

	# List of all modules packaged with this module
	ModuleList		   = @()

	# List of all files packaged with this module
	FileList		        = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData		   = @{

		#Support for PowerShellGet galleries.
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags	        = @('PowerShell', 'Module', 'Function', 'Datatable', 'DateTime', 'FQDN', 'DistinguishedName', 'CimSession', 'Create', 'Zip', 'Unzip', 'Expand', 'Archive', 'PSCredential', 'PSSession', 'Import', 'Export', 'SID', 'Registry', 'SemVer', 'Translate')

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/hmiller10/HelperFunctions/License.md'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/hmiller10/HelperFunctions'

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			ReleaseNotes = 'Add new functions: Get-LastBootTime, Export-Registry, Invoke-Shutdown. Cleared out .temppoint.ps1 files committed accidentally.'

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}