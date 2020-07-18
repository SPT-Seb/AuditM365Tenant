<#
.SYNOPSIS
    Export all Azure AD users' licences in a CSV file in current folder
.DESCRIPTION
    Azure AD PowerShell Module required,
.NOTES
    File Name      : Get-AzureADUsersLicencesCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and Azure AD PowerShell Module 
    Source/Inspiration : https://docs.microsoft.com/fr-fr/office365/enterprise/powershell/view-account-license-and-service-details-with-office-365-powershell
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-AzureADUsersLicencesCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
$isConnectedBefore = $false
try {
    Get-AzureADSubscribedSku | Out-Null 
    Write-Verbose 'Open Azure AD connexion detected'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to Azure AD'
    Connect-AzureAD
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Request all Users'
$allUsers = Get-AzureADUser -All $true | Select * -ExpandProperty AssignedLicenses | `
Select ObjectType, Mail, UserPrincipalName, CompanyName, UserType, AccountEnabled, SkuId, `
@{Name = 'DisabledPlansCount'; Expression = {($_.DisabledPlans).Count}}
Write-Verbose 'Request all SKU'
$licensePlanList = Get-AzureADSubscribedSku

Write-Verbose 'Join Users/SKU'
$allUsersPlans = @()
$allUsers | % { 
    $sku=$_.SkuId ; $user = $_;  $licensePlanList | % { 
        If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36) ) 
        { 
            # Collect information into a hashtable
		    $Props = @{
                "ObjectType" =  $user.ObjectType
                "Mail" =  $user.Mail
                "Company" = $user.CompanyName
                "UserPrincipalName" =  $user.UserPrincipalName
                "UserType" =  $user.UserType
                "AccountEnabled" =  $user.AccountEnabled
                "SkuPartNumber" =  $_.SkuPartNumber
                "SkuId" =  $_.SkuId
            } 
            $allUsersPlans += New-Object PSObject -Property $Props
        }
    }
}

Write-Verbose 'Export to CSV'
$allUsersPlans | Export-Csv -Path `
"$pwd\$ExportName\UsersPlansExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation

if (-not $isConnectedBefore) {
    Write-Verbose 'Disconnecting from Azure AD'
    Disconnect-AzureAD
}