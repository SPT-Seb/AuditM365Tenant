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
    .\Get-MSolO365ServerNameTXTExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
if (Get-MsolCompanyInformation -ErrorAction SilentlyContinue ) {
    Write-Verbose 'Open Msol connexion detected'
}else {
    Write-Verbose 'Connecting Msol'
    Connect-MsolService
}
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 
$serversName = (Get-MsolCompanyInformation).AuthorizedServiceInstances
$serversName > "$pwd\$ExportName\ServiceInstances-$ExportName-$dateFileString.txt"