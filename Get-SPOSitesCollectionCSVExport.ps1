<#
.SYNOPSIS
    Export all harePoint Online site collections in a CSV file in current folder
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
    .\Get-SPOSitesCollectionCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
    [String]$ExportName = "TEST",
    
    [Parameter(Mandatory = $true)]
	[String]$SPAdminURL
)
Connect-SPOService -Url $SPAdminURL
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

$allSites = Get-SPOSite
$allSites | Export-Csv -Path "$pwd\SharePointSiteCollectionsExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation