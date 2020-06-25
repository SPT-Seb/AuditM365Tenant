<#
.SYNOPSIS
    Export all Azure / Microsoft 365 licences in a CSV file in current folder
.DESCRIPTION
    Azure AD PowerShell Module required,
.NOTES
    File Name      : Get-AzureADPlanCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Azure AD PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/office365/enterprise/powershell/view-account-license-and-service-details-with-office-365-powershell
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-AzureADPlanCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
Connect-AzureAD
$dateFileString = Get-Date -Format "FileDateTimeUniversal"
$allSKUs=Get-AzureADSubscribedSku

$allServicePlans = $allSKUs | Select * -ExpandProperty ServicePlans -ea SilentlyContinue | Select SkuPartNumber, SkuId, AppliesTo, ProvisioningStatus, CapabilityStatus, ConsumedUnits,  ServicePlanId, ServicePlanName -ExpandProperty PrepaidUnits
$allServicePlans | Export-Csv -Path "$pwd\LicenceExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation