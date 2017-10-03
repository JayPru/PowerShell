## AUTHOR : GTconsult A Team
## https://www.gtconsult.com
## Version 1.0
## GTconsult do not accept responsibility for any damage, errors or anything whatsoever caused by running or using these scripts. Ensure that you thoroughly test any script in a development environment first before running on your production servers. ##
#### FIND ORPHAN USERS IN SHAREPOINT 2010/2013/2016 FARM ####
if ( (Get-PSSnapin -Name microsoft.sharepoint.powershell -ErrorAction SilentlyContinue) -eq $null )
{
    Add-pssnapin microsoft.sharepoint.powershell
}

function CheckUserExistsInAD() 
   {
   Param( [Parameter(Mandatory=$true)] [string]$UserLoginID )
 
  #Search the User in AD
  $forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
  foreach ($Domain in $forest.Domains)
  {
   $context = new-object System.DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $Domain.Name)
         $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($context)
   
   $root = $domain.GetDirectoryEntry()
         $search = [System.DirectoryServices.DirectorySearcher]$root
         $search.Filter = "(&(objectCategory=User)(samAccountName=$UserLoginID))"
         $result = $search.FindOne()
         if ($result -ne $null)
         {
           return $true
         }
  }
  return $false
 }
  #Get all Site Collections of the web application
 $OrphanedUsers =@()
 $OrphanedUsersurl =@()

 #Iterate through all Web Applications
 $SPWebApps = Get-SPWebApplication
 foreach($SPWebApp in $SPWebApps)
    {
   
    #Iterate through all Site Collections
    foreach($SPsite in $SPWebApp.Sites)
    {
 #Get all site collections with unique permissions
 Write-Host "Checking $SPSite"
 $WebsColl = $SPsite.AllWebs | Where {$_.HasUniqueRoleAssignments -eq $True} | ForEach-Object {
        
  #Iterate through the users collection
  foreach($User in $_.SiteUsers)
  {
      #Exclude Built-in User Accounts , Security Groups & an external domain "corporate"
   if(($User.LoginName.ToLower() -ne "nt authority\authenticated users") -and
                ($User.LoginName.ToLower() -ne "sharepoint\system") -and
                    ($User.LoginName.ToLower() -ne "nt authority\local service")  -and
                        ($user.IsDomainGroup -eq $false ) -and
                            ($User.LoginName.ToLower().StartsWith("corporate") -ne $true) )
                   {
                    $UserName = $User.LoginName.split("\") #Domain\UserName
                    $AccountName = $UserName[1]    #UserName 
                    if ( ( CheckUserExistsInAD $AccountName ) -eq $false ) 
                    {
                         Write-Host "Found orphan $($User.Name) ($($User.LoginName)) in $($_.URL)" 
                         $OrphanedUsers += $User.LoginName
                         $OrphanedUsersurl += $_.URL

                         Write-Host $OrphanedUsers -ForegroundColor Yellow 
    
                    }
                }
            }
        }
    }
    }
 Write-host "Would you like to delete orphan users (Default is No)" -ForegroundColor Yellow 
 $Readhost = Read-Host " ( y / n ) " 
 Switch ($ReadHost)
    {
 
 # ****  Remove Users ****#
      y {
        For($i=0;$i -lt $OrphanedUsers.Length; $i++) 
        {
                $tempurl = $($OrphanedUsersURL[$i])
                $tempuser = $($OrphanedUsers[$i])
                [Microsoft.SharePoint.SPSecurity]::RunWithElevatedPrivileges({ 
                Remove-SPUser $tempuser -web $tempurl -Confirm:$false
                });
                Write-host "Removed the Orphaned user $tempuser from $tempurl" -ForegroundColor Yellow 
        }
    }
      N { Write-Host "Skipping Orphan Removal";}
      Default {Write-Host "Default, Skip Orphan Removal";}
  }
