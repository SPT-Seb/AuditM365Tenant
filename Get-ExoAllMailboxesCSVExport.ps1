<#
.SYNOPSIS
    Export all Exchange Mailboxes infos
.DESCRIPTION
    Exchange ONline PowerShell Module  required.
.NOTES
    File Name      : Get-ExoAllMailboxesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange ONline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/powershell/module/exchange/get-exomailbox?view=exchange-ps
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoAllMailboxesCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-EXOPSSession
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-Mailbox -ResultSize Unlimited | select * | Export-Csv -Path "$pwd\MailBoxesExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation