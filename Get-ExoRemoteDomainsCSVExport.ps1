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
    .\Get-ExoRemoteDomainsCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-EXOPSSession
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-RemoteDomain | select * | Export-Csv -Path "$pwd\RemoteDomains-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation