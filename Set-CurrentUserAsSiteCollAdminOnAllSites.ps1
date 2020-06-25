<#
.SYNOPSIS
    Add or remove current user as site collection admin
.DESCRIPTION
    SharePoint Online PowerShell Module required.
.NOTES
    File Name      : Set-CurrentUserAsSiteCollAdminOnAllSites.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and SharePoint Online PowerShell Module 
    Source/Inspiration : https://www.sharepointdiary.com/2015/08/sharepoint-online-add-site-collection-administrator-using-powershell.html#gsc.tab=0

.EXAMPLE
    .\Set-CurrentUserAsSiteCollAdminOnAllSites.ps1 -SPAdminURL "https://contoso-admin.sharepoint.com/" -isAdmin $true
#>
param(
 
    [Parameter(Mandatory = $true)]
    [String]$SPAdminURL,
    
    [Parameter(Mandatory = $true)]
    [boolean]$isAdmin, 

    [Parameter(Mandatory = $true)]
    [String]$adminName

)
Connect-SPOService -Url $SPAdminURL

Get-SPOSite | % { Write-host "Add/Remove Site Collection Admin for: $($_.URL)"; Set-SPOUser -site $_.Url -LoginName $adminName -IsSiteCollectionAdmin $isAdmin}