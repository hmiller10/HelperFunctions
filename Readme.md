# Helper Functions PowerShell Module

This module contains a collection of PowerShell functions I have found I use/reuse frequently. Consequently, I created this module to include those functions.

## Getting Started

# STEP 1
### Setup PowerShell to use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# STEP 2
### Prerequisites
To publish this module to Azure DevOps I used the NuGet package provider. Therefore, NuGet must be installed on the computer.

```
$pkgProviders = Get-PackageProvider -ListAvailable -Force -ErrorAction Continue
if (-not ($pkgProviders.Name.Contains('Nuget')))
{
try
	{
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	}
	catch
	{
		$errorMessage = "{0}: {1}" -f $Error[0], $Error[0].InvocationInfo.PositionMessage
		Write-Error $errorMessage -ErrorAction Continue
	}
	
}
```

The PowerShellGet module is also required. It can be installed from PowerShellGallery.com

```
Install-Module PowerShellGet -Repository PSGallery -Force
```

One option to authenticate to Azure DevOps is using a Personal Access Token (PAT). See:
https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops

Once the PAT token has been generated, save it in a secure location. I use Keepass to save mine for reuse.

# STEP 3
### Publish Module to Azure DevOps

1. Create Azure DevOps Credential Object. Open an elevated PowerShell prompt as Administrator. Type:

```
$creds = Get-Credential
```
User is not required, however I typically enter my personal e-mail address.
Password should be your PAT token.

2. If you have not already created an artifact repository in Azure DevOps, you will need to create that before proceeding. To register your PS repository in PowerShell, type:

```
Register-PSRepository -Name HMMPackages -SourceLocation 'Insert SourceLocation created when artifact repository was created' -InstallationPolicy Trusted -Credential $creds
```

3. Connect to Azure artifact package feed. (Only needs to be done once.)

```
.\nuget.exe sources Add -Name HMMPackages -Source 'Insert repository source location to .json file' -Force
```

4. Create NuGet configuration file (Only needs to be done once.) If there are no dependencies for the package, remove the dependencies section from the .nuspec file

```
\nuget.exe spec 'HelperFunctions' -Force
```

5.  Create NuGet package (Needs to be done with every module version.) 

NOTE: Module version in .psd1 file must match version number in .nuspec file.
NOTE: In order to work around  the "WARNING: Issue: PowerShell file outside tools folder." use the -NoPackageAnalysis parameter

```
.\nuget pack "HelperFunctions.nuspec" -NoPackageAnalysis
```

6. Publish the package to the artifact feed.

```
.\nuget.exe push -Source 'Insert Repository Name Here' -ApiKey az (can really be anything) "HelperFunctions.0.0.1.nupkg"
```

7. Verify the module exists in the artifact feed.

```
Find-Module -Repository 'HelperFunctions' -Credential $creds
```
End with an example of getting some data out of the system or using it for a little demo

## Running the tests

At present, I have not yet created Pester tests for all functions. I have run each function through PSScriptAnalyzer.

## Deployment

# STEP 4
### Installing
1. Install Module

```
Install-Module 'HelpFunctions' -Repository 'Insert PS Repository Name' -Credential $creds -Force -AllowClobber

### Update Module

Update-Module -Name HelperFunctions -Force

# Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

# Authors

* Heather Miller

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

# License

This project is licensed under the MIT License - see the [LICENSE.md](License.md) file for details

# Acknowledgments

* Hat tip to anyone who's code was used:
	* Thomas Ashworth
	* Mike F Robbins
* Inspiration:
	* Adam Bertram
