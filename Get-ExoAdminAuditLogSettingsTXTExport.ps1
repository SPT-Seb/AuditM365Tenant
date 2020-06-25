<#
.SYNOPSIS
    Export all Exchange authentication policies infos
.DESCRIPTION
    Exchange Online PowerShell Module required.
.NOTES
    File Name      : Get-ExoAuthenticationPoliciesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange Online PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/azure/active-directory/authentication/howto-mfa-userstates
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoAuthenticationPoliciesCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-EXOPSSession
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Set-AdminAuditLogConfig | select * > "$pwd\AdminAuditLogConfig-$ExportName-$dateFileString.txt"