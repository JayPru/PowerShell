## AUTHOR : GTconsult A Team
## https://www.gtconsult.com
## Version 1.0
## GTconsult do not accept responsibility for any damage, errors or anything whatsoever caused by running or using these scripts. Ensure that you thoroughly test any script in a development environment first before running on your production servers. ##
#### GET SIZE OF SHAREPOINT SITE COLLECTIONS 2010/2013/2016 FARM ####
if ( (Get-PSSnapin -Name microsoft.sharepoint.powershell -ErrorAction SilentlyContinue) -eq $null )
{
    Add-pssnapin microsoft.sharepoint.powershell
}

$TotalSize = 0

Write-host "Please enter destination folder for the SPSiteSize.csv report" -ForegroundColor Yellow
$folderPath = Read-Host
$SizeLog = $folderpath+"\SPSiteSize.csv"

$CurrentDate = Get-Date -format d
$WebApps = Get-SPWebApplication
foreach($WebApp in $WebApps)
{
    $Sites = Get-SPSite -WebApplication $WebApp -Limit All
    foreach($Site in $Sites)
    {
        $SizeInKB = $Site.Usage.Storage
        $SizeInGB = $SizeInKB/1024/1024/1024
        $SizeInGB = [math]::Round($SizeInGB,2)
        $TotalSize += $SizeInGB
        $CSVOutput = $Site.RootWeb.Title + "*" + $Site.URL + "*" + $Site.ContentDatabase.Name + "*" + $SizeInGB + "*" + $CurrentDate
        Write-Host = $Site.URL "  Size in GB  " $SizeInGB
        $CSVOutput | Out-File $SizeLog -Append  
    }
}

Write-Host "Completed Report located" $SizeLog "Total Size of Farm" $TotalSize GB -ForegroundColor Yellow
$Site.Dispose()