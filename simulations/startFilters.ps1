$filters = Get-ChildItem -Recurse -Filter "*Filter.ps1";

$run_gawk = 
{
	param($filter);

	cd $filter.DirectoryName;
	Invoke-Expression ("./" + $filter.Name);
}


foreach($filter in $filters)
{
	Start-Job -ScriptBlock $run_gawk -ArgumentList($filter);
}