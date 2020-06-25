<#
.SYNOPSIS
    Export all Exchange email transport rules
.DESCRIPTION
    Exchange Online PowerShell Module required.
.NOTES
    File Name      : Get-ExoTransportRulesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange Online PowerShell Module 
    Source/Inspiration : 
.PARAMETER ExportName
    Used in file export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoTransportRulesCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-EXOPSSession
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-TransportRule | Select Name, State, Mode, Priority, Comments, Description, IsValid, WhenChanged, Guid | Export-Csv -Path "$pwd\TransportRules-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation