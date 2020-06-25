<#
.SYNOPSIS
    Export all Azure AD groups in a CSV file in current folder
.DESCRIPTION
    Azure AD PowerShell Module required,
.NOTES
    File Name      : Get-AzureADGroupsCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Azure AD PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/office365/enterprise/powershell/view-account-license-and-service-details-with-office-365-powershell
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-AzureADGroupsCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
Connect-AzureAD
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

$allGroups = Get-AzureADMSGroup -All $true | select *, @{N="GroupType"; E={ if( $_.GroupTypes -ne $null){ $_.GroupTypes[0]} else {"DistributionList"}}}
$allGroups | Export-Csv -Path "$pwd\AzureADGroupsExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation