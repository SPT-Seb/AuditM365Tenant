<#
.SYNOPSIS
    Export all SharePoint Online site collections in a CSV file in current folder
.DESCRIPTION
    SharePoint Online PowerShell Module required.
.NOTES
    File Name      : Get-SPOSitesCollectionCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and SharePoint Online PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/azure/active-directory/authentication/howto-mfa-userstates
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-SPOSitesCollectionCSVExport.ps1 -ExportName "Contoso" -SPAdminURL "https://contoso-admin.sharepoint.com/"
#>
param(
 	[Parameter(Mandatory = $true)]
    [String]$ExportName,
    
    [Parameter(Mandatory = $true)]
	[String]$SPAdminURL
)
$isConnectedBefore = $false
try {
    Get-SPOMultiGeoExperience | Out-Null 
    Write-Verbose 'Open SPO Service connexion found'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to SPO Service'
    Connect-SPOService -Url $SPAdminURL
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Requesting all SP site collections'
$allSites = Get-SPOSite
Write-Verbose 'Export to CSV'
$allSites | Export-Csv -Path "$pwd\$ExportName\SharePointSiteCollectionsExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation

if (-not $isConnectedBefore) {
    Write-Verbose 'Disonnecting from SPO Service'
    Disconnect-SPOService
}