<#
.SYNOPSIS
    Export all Azure AD users' licences in a CSV file in current folder
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
    .\Get-MsolUsersMFAStatusCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName = "TEST"
)
Connect-MsolService
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

$allUsersMFAStatus = Get-MsolUser -all | select UserPrincipalName, UserType, ObjectId, WhenCreated, LastPasswordChangeTimestamp, PasswordNeverExpires, PasswordResetNotRequiredDuringActivate, @{N="MFAStatus"; E={ if( $_.StrongAuthenticationRequirements.State -ne $null){ $_.StrongAuthenticationRequirements.State} else { "Disabled"}}}, @{N="MFAMethod"; E={ if( $_.StrongAuthenticationMethods.MethodType -ne $null){ $_.StrongAuthenticationMethods.MethodType}}}, StrongPasswordRequired, StrongAuthenticationProofupTime
$allUsersMFAStatus | Export-Csv -Path "$pwd\UsersMFAStatusExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation