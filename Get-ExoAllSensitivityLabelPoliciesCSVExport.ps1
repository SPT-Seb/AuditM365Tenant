<#
.SYNOPSIS
    Export all existing sensitivity labels informations
.DESCRIPTION
    Exchange Online PowerShell Module  required.
.NOTES
    File Name      : Get-ExoAllSensitivityLabelPoliciesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange ONline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/powershell/module/exchange/get-exomailbox?view=exchange-ps
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoAllSensitivityLabelPoliciesCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
$isConnectedBefore = $false
try {
    Get-Label | Out-Null 
    Write-Verbose 'Open compliance center connexion detected'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to compliance center'
    Connect-IPPSSession
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 
Get-LabelPolicy | Export-Csv -Path "$pwd\$ExportName\SensitivityLabelPoliciesExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation