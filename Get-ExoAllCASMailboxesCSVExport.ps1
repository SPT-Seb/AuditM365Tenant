<#
.SYNOPSIS
    Export all CAS Exchange Mailboxes infos
.DESCRIPTION
    Exchange Online PowerShell Module required.
.NOTES
    File Name      : Get-ExoAllCASMailboxesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange ONline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/azure/active-directory/authentication/howto-mfa-userstates
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoAllCASMailboxesCSVExport.ps1 -ExportName "Contoso"
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

Get-CASMailbox -ResultSize unlimited | select * | Export-Csv -Path "$pwd\$ExportName\CASMailBoxesExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation