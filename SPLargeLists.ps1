## AUTHOR : RIPON KUNDU
## RIPONKUNDU@OUTLOOK.COM
## Version 1.1
## Updated by GTconsult A Team https://www.gtconsult.com
## GTconsult do not accept responsibility for any damage, errors or anything whatsoever caused by running or using these scripts. Ensure that you thoroughly test any script in a development environment first before running on your production servers. ##
#### FIND LARGE LISTS IN SHAREPOINT 2010/2013/2016 FARM ####

## Dont Display Errors
$ErrorActionPreference = "Continue"

function GetSPLargeLists {
    if ( (Get-PSSnapin -Name microsoft.sharepoint.powershell -ErrorAction SilentlyContinue) -eq $null )
{
    Add-pssnapin microsoft.sharepoint.powershell
}

$SPWebApps = Get-SPWebApplication
$Exceldata = New-Object PSObject
foreach($SPWebApp in $SPWebApps)
{
  $Threshold = $SPWebApp.MaxItemsPerThrottledOperation
  $Warning = $SPWebApp.MaxItemsPerThrottledOperation * (50 / 100)
  $Critical = $SPWebApp.MaxItemsPerThrottledOperation * (75 / 100)
    
    ## Add a trap for an exception.  All tested exceptions where Access Denied and I needed to know the URL
    trap {
        $errobj = New-Object PSObject
        $errobj | Add-Member NoteProperty Title($SPlist.Title)
        $errobj | Add-Member NoteProperty WebURL($SPweb.URL)
        $errobj | Add-Member NoteProperty Count($SPlist.ItemCount)
        $errobj | Add-Member NoteProperty Threshold($Threshold)
        $errobj | Add-Member NoteProperty Level("No Info")
        $errobj | Add-Member NoteProperty Access("Denied")
        $errobj
        }
  foreach($SPsite in $SPWebApp.Sites)
  {
    foreach($SPweb in $SPsite.AllWebs)
    {
      foreach($SPlist in $SPweb.Lists)
      {
        if($SPlist.ItemCount -gt $Threshold)
        {
          $obj = New-Object PSObject
          $obj | Add-Member NoteProperty Title($SPlist.Title)
          $obj | Add-Member NoteProperty WebURL($SPweb.URL)
          $obj | Add-Member NoteProperty Count($SPlist.ItemCount)
          $obj | Add-Member NoteProperty Threshold($Threshold)
          $obj | Add-Member NoteProperty Level("Exceeded Limit")
          $obj | Add-Member NoteProperty Access("Granted")
          $obj 
        }
        elseif($SPlist.ItemCount -gt $Critical)
        {
          $obj = New-Object PSObject
          $obj | Add-Member NoteProperty Title($SPlist.Title)
          $obj | Add-Member NoteProperty WebURL($SPweb.URL)
          $obj | Add-Member NoteProperty Count($SPlist.ItemCount)
          $obj | Add-Member NoteProperty Threshold($Threshold)
          $obj | Add-Member NoteProperty Level("Above 75%")
          $obj | Add-Member NoteProperty Access("Granted")
          $obj
         }
        elseif($SPlist.ItemCount -gt $Warning)
        {
          $obj = New-Object PSObject
          $obj | Add-Member NoteProperty Title($SPlist.Title)
          $obj | Add-Member NoteProperty WebURL($SPweb.URL)
          $obj | Add-Member NoteProperty Count($SPlist.ItemCount)
          $obj | Add-Member NoteProperty Threshold($Threshold)
          $obj | Add-Member NoteProperty Level("Above 50%")
          $obj | Add-Member NoteProperty Access("Granted")
          $obj 
         }

      $SPweb.Dispose()
    }
    $SPsite.Dispose()
    }
    }
}

#Turn Errors back on
$ErrorActionPreference = "Continue"
}
GetSPLargeLists