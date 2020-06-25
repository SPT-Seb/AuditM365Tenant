<#
.SYNOPSIS
    Export all Exchange Organization Settings 
.DESCRIPTION
    Exchange ONline PowerShell Module required.
.NOTES
    File Name      : Get-ExoOrgaConfigTXTExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange ONline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/azure/active-directory/authentication/howto-mfa-userstates
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoOrgaConfigTXTExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-EXOPSSession
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-OrganizationConfig | select * > "$pwd\OrganizationSettings-$ExportName-$dateFileString.txt"