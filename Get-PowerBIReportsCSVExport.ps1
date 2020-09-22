<#
.SYNOPSIS
    Export all PowerBI workspaces and resports infos in two CSV files
.DESCRIPTION
    Power BI PowerShell Module required (run this command with elevated priviledges PS> Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser)
.NOTES
    File Name      : Get-PowerBIReportsCSVExport.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and MicrosoftPowerBIMgmt PowerShell Module + a tenant admin account + a Power BI Pro licence
.PARAMETER ExportName
    Used in CSV export name (use company/tenant name)
.EXAMPLE
    .\Get-PowerBIReportsCSVExport.ps1 -ExportName "Contoso"
#>
param(
 	[Parameter(Mandatory = $true)]
	[String]$ExportName
)
$isConnectedBefore = $false
try {
    Get-PowerBICapacity | Out-Null 
    Write-Verbose 'Open Power BI connexion found'
    $isConnectedBefore = $true
} catch {} 
if (-not $isConnectedBefore) {
    Write-Verbose 'Connecting to Power BI'
    Connect-PowerBIServiceAccount
}

$dateFileString = Get-Date -Format "FileDateTimeUniversal"

mkdir -Force "$pwd\$ExportName\" | Out-Null 

Write-Verbose 'Request Power BI Workspaces'

$workspaces = Get-PowerBIWorkspace -Scope Organization -All | select ID, Name, Type, State, IsReadOnly, IsOrphaned, IsOnDedicatedCapacity, CapacityId, @{Name = 'FirstUSer'; Expression = {$_.Users[0].Identifier}}
$workspaces |Export-Csv -Path "$pwd\$ExportName\PowerBIWorkspaces-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation

$reportsWithConnexions = Get-PowerBIReport -Scope Organization | % {
    $currentReport = $_
    $dataSources = Get-PowerBIDatasource -DatasetId $_.DatasetId -ErrorAction Ignore
    New-Object PSObject -Property @{
        ReportID = $currentReport.ID;
        ReportName = $currentReport.Name;
        ReportWebUrl = $currentReport.WebUrl;
        ReportEmbedUrl = $currentReport.EmbedUrl;
        DatasetId = $currentReport.DatasetId;
        DataSources = ConvertTo-Json $dataSources
    }
}
$reportsWithConnexions | Export-Csv -Path "$pwd\$ExportName\PowerBIReports-$ExportName-$dateFileString.csv" -Delimiter ';' -Encoding UTF8 -NoTypeInformation

if (-not $isConnectedBefore) {
    Write-Verbose 'Disconnecting from PowerBI'
    Disconnect-PowerBIServiceAccount
}