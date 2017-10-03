## AUTHOR : GTconsult A Team
## https://www.gtconsult.com
## Version 1.0
## GTconsult do not accept responsibility for any damage, errors or anything whatsoever caused by running or using these scripts. Ensure that you thoroughly test any script in a development environment first before running on your production servers. ##
#### FIND AND DOWNLOAD WSP SOLUTIONS IN SHAREPOINT 2010/2013/2016 FARM ####
if ( (Get-PSSnapin -Name microsoft.sharepoint.powershell -ErrorAction SilentlyContinue) -eq $null )
{
    Add-pssnapin microsoft.sharepoint.powershell
}

Function SPSolutions {
$farm = Get-SPFarm
foreach($solution in $farm.Solutions){
   $solution = $farm.Solutions[$solution.Name]
        $obj = New-Object PSObject
        $obj | Add-Member NoteProperty Name($Solution.Name)
        $obj | Add-Member NoteProperty SolutionId($Solution.SolutionId)
        $obj | Add-Member NoteProperty Deployed($Solution.Deployed)
        $obj
        }

Write-host "Would you like to download all WSP's? (Default is No)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-host "Yes, Download all WSPs"; 
       Write-host "Please enter destination folder for the WSP's" -ForegroundColor Yellow
       $folderPath = Read-Host
        $farm = Get-SPFarm
            foreach($solution in $farm.Solutions){
   		        $solution = $farm.Solutions[$solution.Name]
   		        $file = $solution.SolutionFile
   		        $file.SaveAs($folderPath + ‘\’ + $solution.Name)
                Write-host "Copied " $solution.Name " to " $folderPath
            }
       } 
       N {Write-Host "No, Do not download all WSP's";} 
       Default {Write-Host "Default, Skip WSP Download";} 
     } 
 }
 SPSolutions