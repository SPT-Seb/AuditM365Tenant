<#
.SYNOPSIS
    Export all Exchange Mailboxes statistics
.DESCRIPTION
    Exchange ONline PowerShell Module  required.
.NOTES
    File Name      : Get-ExoAllMailboxesStatisticsCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange ONline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/powershell/module/exchange/get-exomailbox?view=exchange-ps
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoAllMailboxesStatisticsCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-EXOPSSession
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-Mailbox -ResultSize Unlimited | % {Get-Mailboxstatistics -Identity $_.PrimarySmtpAddress } | select * | Export-Csv -Path "$pwd\MailBoxesStatisticsExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation