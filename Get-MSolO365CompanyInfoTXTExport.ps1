<#
.SYNOPSIS
    Export all O365 tenant Company info in a TXT file in current folder
.DESCRIPTION
    MSOnline PowerShell Module required.

.NOTES
    File Name      : Get-MSolO365CompanyInfoTXTExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and MSOnline PowerShell Module 
    Source/Inspiration : 
.PARAMETER ExportName
    Used in file export name (use company/tenant name)
.EXAMPLE
    .\Get-MSolO365CompanyInfoTXTExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-MsolService
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-MsolCompanyInformation | select * > "$pwd\TenantCompanyInfos-$ExportName-$dateFileString.txt"