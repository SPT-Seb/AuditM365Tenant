<#
.SYNOPSIS
    Export all O365 users' admin role infos in a CSV file in current folder, including MFA authentication status
.DESCRIPTION
    MSOnline PowerShell Module required.
.NOTES
    File Name      : Get-MsolAdminRolesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and MSOnline PowerShell Module + Join-Object Module
    Source/Inspiration : https://www.powershellgallery.com/packages/Join-Object/
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-MsolAdminRolesCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName 
)
if (Get-MsolCompanyInformation -ErrorAction SilentlyContinue ) {
    Write-Verbose 'Open Msol connexion found'
}else {
    Write-Verbose 'Connecting Msol'
    Connect-MsolService
}
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Request users MFA status'
$usersMFA =  Get-MsolUser -all | select UserPrincipalName, `
@{N="MFAStatus"; E={ if( $_.StrongAuthenticationRequirements.State -ne $null) `
    { $_.StrongAuthenticationRequirements.State} else { "Disabled"}}}, `
@{N="MFAMethod"; E={ if( $_.StrongAuthenticationMethods.MethodType -ne $null){ `
    $_.StrongAuthenticationMethods.MethodType}}}, StrongPasswordRequired, `
    StrongAuthenticationProofupTime 
Write-Verbose "$($usersMFA.count) users found"
Write-Verbose 'Request admin roles'
$allAdminRoles = Get-MsolRole | %{ $roleName = $_.Name; `
    Get-MsolRoleMember -RoleObjectId $_.ObjectId | select DisplayName, EmailAddress, `
    @{Name = 'O365Role'; Expression = {$roleName}}}
Write-Verbose "$($allAdminRoles.count) admin roles found"
Write-Verbose 'Joining tables'
$allAdminRolesWithMFAStatus = Join-Object -Left $allAdminRoles -Right $usersMFA `
-LeftJoinProperty 'EmailAddress' -RightJoinProperty 'UserPrincipalName'
Write-Verbose "$($allAdminRolesWithMFAStatus.count) admin roles MFA status found"

Write-Verbose 'Export to CSV'
$allAdminRolesWithMFAStatus | Export-Csv -Path "$pwd\$ExportName\O365AdminRolesExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation