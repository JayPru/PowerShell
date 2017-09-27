Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

#Output Report File
$currentLocation = (Get-Location).Path
$outputReport = $currentLocation +"/" + "SharePointUsers.csv"
#Write CSV File Header

#Array to hold user data
$UserDataCollection = @()

#Get All Web Applications and iterate through
$webAppsColl = Get-SPWebApplication
#To Get all Users from specific web application, Use: $WebAppsColl = Get-SPWebApplication "web-app-url"
#and remove line #12

foreach()
{
	Write-host "Scanning Web Application:"$WebApp.Name
	#Get All site collections and iterate through
	$SitesColl = $WebApp.SitesColl
	#To Get all Users from site collection, Use: $SitesColl = Get-SPSite "site-colleciton-url"
	#and remove lines between #11 to #20 and Line #55 "}"
	#get all users from site collection PowerShell
	foreach ($Site in $SitesColl)
	{
		Write-host "Scanning Site Collection:"$Site.Url
		#Get All Webs and iterate through
		$WebsColl = $Site.AllWebs
		#To Get all Users from aq site, Use: $WebsColl = Get-SPWeb "web-url"
		#and remove lines between #11 to #28 and Lines #53, #54, #55 "}"
		
		foreach ($web in $WebsColl)
		{
			Write-host "Scanning Web:"$Web.URL
			#Get All Users of the Web
			#UsersColl = $web.AllUsers  #get all users programmatically
			#list all users
			foreach ($user in $UsersColl)
			{
				if($User.IsDomainGroup -eq $false)
				{
					$UserData = New-Object PSObject
						
					$UserData | Add-Member -type NoteProperty -name "UserLogin" -value $user.UserLogin.ToString()
					$UserData | Add-Member -type NoteProperty -name "DisplayName" -value $user.displayName.ToString()
					$UserData | Add-Member -type NoteProperty -name "E-mailID" -value $user.Email.ToString()
						
					$UserDataCollection += $UserData
				}
			}
		$Web.dispose()
		}
	$site.dispose()	
	}
}
#Remove duplicates
$UserDataCollection = $UserDataCollection | sort-object -Property {$_.UserLogin } -Unique


////////////////////////////////////////////////////////////////////////

Oneliner

Get-SPSite -Limit All | Select -ExpandProperty AllWebs | select -ExpandProperty AllUsers | {$_.IsDomainGroup -ne $true} | select - LoginName
	
#Remove duplicates and export all users to excel
$UserDataCollection | Export-CSV -LiteralPath $OutputReport -NoTypeInformation
	
Write-host "Total Number of Unique User found:"$UserDataCollection.Length	
