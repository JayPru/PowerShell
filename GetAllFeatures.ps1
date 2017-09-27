#All Farm features

Get-SPFeature -Limit All | Where-Object {$_.Scope -eq "Farm"} | Out-GridView

#Specific Site features

Get-SPFeature -Site http://sp2013dev:1000 | Out-GridView