Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$SPWebApp = Get-SPWebApplication "<a class="vglnk" href="http://sharepoint.com" rel="nofollow"><span><http</span><span>://</span><span>sharepoint</span><span>.</span><span>com</span></a>"

<# If it is MOSS 2007, You can use:
$SPWebApp = [Microsoft.SharePoint.Administration.SPWebApplication]::Lookup(<a class="vglnk" href="http://sharepoint.com" rel="nofollow"><span><http</span><span>://</span><span>sharepoint</span><span>.</span><span>com</span></a>)
 To get SPWebApplication
 #>
 
 #create a CSV file
 "Email,List,Site" > "Email-Enabled.txt" #Write the Headers in to a texdt file
 
 foreach ($SPsite in $SPwebApp.Sites) # get the colleciton of site collections
 {
	foreach ($SPweb in $SPsite.AllWebs) # get the collection of sub sites
	{
		foreach ($SPList in $SPweb.Lists)
		{
			if( ($splist.CanReceiveEmail) -and ($SPlist.EmailAlias) )
			{
				#Write-Host "E-Mail -" $SPList.EmailAlias "is configured for the list "$SPlist.Title "in "$SPweb.Url
				$SPList.EmailAlias + "," + $SPlist.Title +"," + $SPweb.Url >> Email-Enabled.txt #append the data
			}
		}
	}
 }