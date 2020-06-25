<#
.SYNOPSIS
    Export all Exchange Mailboxes which have auto forwarding rules infos
.DESCRIPTION
    Exchange Online PowerShell Module required.
.NOTES
    File Name      : Get-ExoAllMailboxesForwardRulesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Exchange Online PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/powershell/module/exchange/get-exomailbox?view=exchange-ps
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-ExoAllMailboxesForwardRulesCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-EXOPSSession
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-Mailbox -ResultSize Unlimited -Filter {(RecipientTypeDetails -ne "DiscoveryMailbox") -and ((ForwardingSmtpAddress -ne $null) -or (ForwardingAddress -ne $null))} `
| select UserPrincipalName, RecipientTypeDetails, ForwardingSmtpAddress, ForwardingAddress `
| Export-Csv -Path "$pwd\AutomaticForwardMailExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation