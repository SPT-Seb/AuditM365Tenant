<#
.SYNOPSIS
    Export tenant password policy settings
.DESCRIPTION
    MSOnline PowerShell Module required.
.NOTES
    File Name      : Get-MsolUsersMFAStatusCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and MSOnline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/azure/active-directory/authentication/howto-mfa-userstates
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-MsolPasswordPolicyCSVExport.ps1 -ExportName "Contoso"
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

Write-Verbose 'Request all domains'
Get-MsolDomain | % {
    Write-Verbose "Request $($_.Name) domains password policies";
    Get-MsolPasswordPolicy -DomainName $_.Name
} | Export-Csv -Path "$pwd\$ExportName\UsersPAsswordPolicyExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation