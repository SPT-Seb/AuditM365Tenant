<#
.SYNOPSIS
    Export all Azure AD users' MFA status
.DESCRIPTION
    MSOnline PowerShell Module required.
    MFA Status :
        Disabled : The default state for a new user not enrolled in Azure Multi-Factor Authentication. 	
        Enabled : The user has been enrolled in Azure Multi-Factor Authentication, but hasn't registered. They receive a prompt to register the next time they sign in. 
        Enforced : The user has been enrolled and has completed the registration process for Azure Multi-Factor Authentication.
.NOTES
    File Name      : Get-MsolUsersMFAStatusCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and MSOnline PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/azure/active-directory/authentication/howto-mfa-userstates
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-MsolUsersMFAStatusCSVExport.ps1 -ExportName "Contoso"
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

Write-Verbose 'Request users MFA status and export to CSV'
Get-MsolUser -all | select UserPrincipalName, UserType, ObjectId, WhenCreated, `
LastPasswordChangeTimestamp, PasswordNeverExpires, PasswordResetNotRequiredDuringActivate, `
ValidationStatus, IsLicensed, BlockCredential, `
@{N="MFAStatus"; E={ if( $_.StrongAuthenticationRequirements.State -ne $null) `
    { $_.StrongAuthenticationRequirements.State} else { "Disabled"}}}, `
@{N="MFAMethod"; E={ if( $_.StrongAuthenticationMethods.MethodType -ne $null){ `
    $_.StrongAuthenticationMethods.MethodType}}}, StrongPasswordRequired, `
    StrongAuthenticationProofupTime | Export-Csv -Path `
"$pwd\$ExportName\UsersMFAStatusExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation