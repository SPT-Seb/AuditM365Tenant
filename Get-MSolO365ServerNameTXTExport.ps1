<#
.SYNOPSIS
    Export all O365 server names in a TXT file in current folder
.DESCRIPTION
    MSOnline PowerShell Module required.

.NOTES
    File Name      : Get-MSolO365ServerNameTXTExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and MSOnline PowerShell Module 
    Source/Inspiration : 
.PARAMETER ExportName
    Used in file export name (use company/tenant name)
.EXAMPLE
    .\Get-MSolO365ServerNameTXTExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-MsolService
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

$serversName = (Get-MsolCompanyInformation).AuthorizedServiceInstances
$serversName > "$pwd\ServiceInstances-$ExportName-$dateFileString.txt"