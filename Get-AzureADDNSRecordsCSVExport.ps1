<#
.SYNOPSIS
    Export all Azure AD DNS Records for all tenant domains in a CSV file in current folder
.DESCRIPTION
    Azure AD PowerShell Module required,
.NOTES
    File Name      : Get-AzureADDNSRecordsCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Azure AD PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/office365/enterprise/powershell/view-account-license-and-service-details-with-office-365-powershell
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-AzureADDNSRecordsCSVExport.ps1 -ExportName "Contoso"
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

Write-Verbose 'Request all Azure domains'' service configuration'
$allDNSRecords = Get-AzureADDomain | Get-AzureADDomainServiceConfigurationRecord  |`
 select DnsRecordId, IsOptional, Label, RecordType, SupportedService, Ttl, MailExchange, `
 Preference, Text, CanonicalName, NameTarget, Port, Priority, Protocol, Service, Weight
Write-Verbose 'Export to CSV'
$allDNSRecords | Export-Csv -Path "$pwd\$ExportName\AzureADDNSRecordsExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation