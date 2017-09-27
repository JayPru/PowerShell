function Get-Workflows($siteurl)
{
	$site = Get-SPSite($siteurl);
	
	$WorkflowDetail = @()
	foreach($web in $site.AllWebs)
		{
			foreach($list in $web.Lists)
			{
				foreach($wf in $list.WorkflowAssociations)
				{
					if ($wf.Name -notlike "*Previous Workflow*")
					{
						$row = new-object PSObject
						add-member -inputObject $row -memberType NoteProperty -name "Site URL" -value $web.Url
						add-member -inputObject $row -memberType NoteProperty -name "List Title" -value $list.Title
						add-member -inputObject $row -memberType NoteProperty -name "Workflow Name" -value $wf.Name
						$WorkflowDetail += $row
					}
				}
			}
		}
	$WorkflowDetail
}

Get-Workflows "http://sp2013dev:1000" | Out-GridView #"c:\ListAllWorkflows.csv"

Get-Workflows "http://sp2013dev:1000" | Out-File "c:\Temp\ListAllWorkflows.csv"