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
    .\Get-AzureADPlanCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
$isConnectedBefore = $false
try {
    Get-AzureADSubscribedSku | Out-Null 
    Write-Verbose 'Open Azure AD connexion detected'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to Azure AD'
    Connect-AzureAD
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Request all SKU'
$allSKUs=Get-AzureADSubscribedSku
$allServicePlans = $allSKUs | Select * -ExpandProperty ServicePlans -ea SilentlyContinue | Select SkuPartNumber, SkuId, AppliesTo, ProvisioningStatus, CapabilityStatus, ConsumedUnits,  ServicePlanId, ServicePlanName -ExpandProperty PrepaidUnits
Write-Verbose 'Export to CSV'
$allServicePlans | Export-Csv -Path "$pwd\$ExportName\LicenceExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation

if (-not $isConnectedBefore) {
    Write-Verbose 'Disconnecting from Azure AD'
    Disconnect-AzureAD
}