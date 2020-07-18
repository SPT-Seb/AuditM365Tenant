<#
.SYNOPSIS
    Export all Azure AD users in a CSV file in current folder
.DESCRIPTION
    Azure AD PowerShell Module required,
.NOTES
    File Name      : Get-AzureADUsersCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Azure AD PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/office365/enterprise/powershell/view-account-license-and-service-details-with-office-365-powershell
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-AzureADUsersCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
$isConnectedBefore = $false
try {
    Get-AzureADSubscribedSku | Out-Null 
    Write-Verbose 'Open Azure AD connexion found'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to Azure AD'
    Connect-AzureAD
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Request all users'
$allUsers = Get-AzureADUser -All $true | Select ObjectType, Mail, UserPrincipalName, UserType, AccountEnabled, AgeGroup, City, CompanyName, ConsentProvidedForMinor, Country, CreationType, Department, DirSyncEnabled, DisplayName, FacsimileTelephoneNumber, GivenName, IsCompromised, ImmutableId, JobTitle, LastDirSyncTime, LegalAgeGroupClassification, MailNickName, Mobile, OnPremisesSecurityIdentifier, PasswordPolicies, PasswordProfile, PhysicalDeliveryOfficeName, PostalCode, PreferredLanguage, ProxyAddresses[0], RefreshTokensValidFromDateTime, ShowInAddressList, SipProxyAddress, State, StreetAddress, Surname, TelephoneNumber, UsageLocation, UserState, UserStateChangedOn
Write-Verbose 'Export to CSV'
$allUsers | Export-Csv -Path "$pwd\$ExportName\UsersExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation

if (-not $isConnectedBefore) {
    Write-Verbose 'Disconnecting from Azure AD'
    Disconnect-AzureAD
}