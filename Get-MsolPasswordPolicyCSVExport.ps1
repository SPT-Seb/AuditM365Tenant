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
 .PARAMETER DomainName
    Specifies the fully qualified domain name of the domain to be retrieved.   
.EXAMPLE
    .\Get-MsolPasswordPolicyCSVExport.ps1 -ExportName "Microsoft" -DomainName "microsoft.com"
#>
param(
 	[Parameter(Mandatory = $true)]
    [String]$ExportName = "TEST",

    [Parameter(Mandatory = $true)]
    [String]$DomainName
)
Connect-MsolService
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

Get-MsolPasswordPolicy -DomainName $DomainName | Export-Csv -Path "$pwd\UsersPAsswordPolicyExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation