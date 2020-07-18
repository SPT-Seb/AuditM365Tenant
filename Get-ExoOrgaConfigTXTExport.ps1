<#
.SYNOPSIS
    Export all Exchange Organization Settings 
.DESCRIPTION
    Exchange ONline PowerShell Module required.
.NOTES
    File Name      : Get-ExoOrgaConfigTXTExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange ONline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/azure/active-directory/authentication/howto-mfa-userstates
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoOrgaConfigTXTExport.ps1 -ExportName "Contoso"
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

Write-Verbose 'Request and export EXO organization config'
Get-OrganizationConfig | select * > "$pwd\$ExportName\OrganizationSettings-$ExportName-$dateFileString.txt"