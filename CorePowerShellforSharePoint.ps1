# Core Script for SharePoint
# A Single Web, Site Collection, Application or an Entire Farm

#Single SharePoint Site
Get-SPWeb http://sharepoint/sites/training/salestraining | Select -ExpandProperty Lists | Select Title

#All lists in the site collection
Get-SPSite http://sharepoint/sites/training -Limit All | Select -ExpandProperty AllWebs | Select -ExpandProperty Lists | Select ParentWebUrl, Title

#All site collections in a single web application
Get-SPSite -WebApplication http://sharepoint -Limit All | Select -ExpandProperty AllWebs | Select -ExpandProperty Lists | Select ParentWebUrl, Title

#All Site collections in the farm
Get-SPSite -Limit All | Select -ExpandProperty AllWebs | Select -ExpandProperty Lists | Select {$_.ParentWeb.Url}, Title

#{$_.ParentWeb.Url} replaces ParentWebUrl. ParentWebUrl is an application-relative URL and does not show us the full URL of the application

#Getting a quick count (items)
(Get-SPSite -Limit All | Select -ExpandProperty AllWebs | Select -ExpandProperty Lists ).Count

#Lists of specific type
#Lists
Get-SPWeb http://sharepoint/sites/training | Select -ExpandProperty Lists | Where { $_.GetType().Name -eq "SPList" } | Select Title

#Libraries
Get-SPWeb http://sharepoint/sites/training | Select -ExpandProperty Lists | Where { $_.GetType().Name - eq "SPDocumentLibrary" } | Select Title

#Exclude hidden list. Add '-and -not $_.hidden' to Where clause
Get-SPWeb http://sharepoint/sites/training | Select -ExpandProperty Lists | Where { $_.GetType().Name - eq "SPDocumentLibrary" -and -not $_.hidden } | Select Title

#Find list by any property
Get-SPWeb http://sharepoint/sites/training | Select -ExpandProperty Lists | Where { -not $_.hidden -and $_.EnableVerisoning -eq $true } | Select ParentWebUrl, title

#Find lists using a Certain Content Type
Get-SPWeb http://sharepoint/sites/training | Select -ExpandProperty ContentTypes | Select Name, ID | Sort Name

#Example of Annoucement Lists in a site collection
Get-SPSite http://sharepoint/sites/training | Select -ExpandProperty AllWebs | Select -ExpandProperty Lists | ForEach { ForEach($ct in $_.ContentTypes) { if($ct.Name -eq "Announcment") {$_} } } | Select ParentWebUrl, Title

