<#
.SYNOPSIS
    Export all O365 users' admin role infos in a CSV file in current folder
.DESCRIPTION
    MSOnline PowerShell Module required.
.NOTES
    File Name      : Get-MsolAdminRolesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and MSOnline PowerShell Module 
    Source/Inspiration : 
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-MsolAdminRolesCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-MsolService
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

$allAdminRoles = Get-MsolRole | %{ $roleName = $_.Name; Get-MsolRoleMember -RoleObjectId $_.ObjectId | select DisplayName, EmailAddress, @{Name = 'O365Role'; Expression = {$roleName}}}
$allAdminRoles | Export-Csv -Path "$pwd\O365AdminRolesExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation