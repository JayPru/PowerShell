Get-SPWebApplication https://portal.contoso.com | Get-SPSite -Limit All |
Get-SPWeb -Limit All | Select Title, URL, ID, ParentWebID | Export -CSV
C:sharepointinventory.csv -NoTypeInformation