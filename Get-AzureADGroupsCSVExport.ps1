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
    .\Get-AzureADGroupsCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
$isConnectedBefore = $false
try {
    Get-AzureADSubscribedSku | Out-Null 
    Write-Verbose 'Open Azure AD connexion found'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to Azure AD'
    Connect-AzureAD
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Requesting all Azure AD groups'
$allGroups = Get-AzureADMSGroup -All $true | select *, @{N="GroupType"; E={ if( $_.GroupTypes -ne $null){ $_.GroupTypes[0]} else {"DistributionList"}}}
Write-Verbose 'Export to CSV'
$allGroups | Export-Csv -Path "$pwd\$ExportName\AzureADGroupsExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation