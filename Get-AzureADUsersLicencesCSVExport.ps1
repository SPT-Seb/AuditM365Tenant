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
    .\Get-AzureADUsersLicencesCSVExport.ps1 -ExportName "Microsoft"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
Connect-AzureAD
$dateFileString = Get-Date -Format "FileDateTimeUniversal"

$allUsers = Get-AzureADUser -All $true | Select * -ExpandProperty AssignedLicenses | Select ObjectType, Mail, UserPrincipalName, UserType, AccountEnabled, SkuId, @{Name = 'DisabledPlansCount'; Expression = {($_.DisabledPlans).Count}}
$licensePlanList = Get-AzureADSubscribedSku

$allUsersPlans = @()
$allUsers | % { 
    $sku=$_.SkuId ; $user = $_;  $licensePlanList | % { 
        If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36) ) 
        { 
            # Collect information into a hashtable
		    $Props = @{
                "ObjectType" =  $user.ObjectType
                "Mail" =  $user.Mail
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

$allUsersPlans | Export-Csv -Path "$pwd\UsersPlansExport-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation