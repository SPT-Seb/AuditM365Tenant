<#
.SYNOPSIS
    Export all Exchange domain settings
.DESCRIPTION
    Exchange Online PowerShell Module required.
.NOTES
    File Name      : Get-ExoRemoteDomainsCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange Online PowerShell Module 
    Source/Inspiration : 
.PARAMETER ExportName
    Used in file export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoRemoteDomainsCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
$isConnectedBefore = $false
try {
    Get-OrganizationConfig | Out-Null 
    Write-Verbose 'Open Exchange Online Admin connexion detected'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to Exchange Online Admin center'
    Connect-EXOPSSession
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"
mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Request and export EXO domain settings'

Get-RemoteDomain | select * | Export-Csv -Path "$pwd\$ExportName\RemoteDomains-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation