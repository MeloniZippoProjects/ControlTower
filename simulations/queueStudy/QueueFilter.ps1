# Configuration variables

$patterns = "landingQueue_queueLength", "landingQueue_queueTime" ,"takeoffQueue_queueLength", "takeoffQueue_queueTime", "wg_responseTime", "parkingLot_parkingOccupancy";
$iniName = "queueStudy.ini"
$configuration = "QueueMeasurement"

$awkScriptPath = "\\PC-RAFF\simulations\filter_m.awk" 

# Script body

$root = pwd
$inis = Get-ChildItem -Recurse -Filter $iniName

$runFilter =
{
    param($ini, $awkScriptPath, $patterns, $configuration)

    cd $ini.DirectoryName

	Write-Host "Processing " (pwd | % path)
	
    cd results
	foreach($pattern in $patterns)
	{
		Write-Host "Processing " $pattern
	 	gawk -f $awkScriptPath -v pattern=$pattern ( Get-ChildItem -Filter ($configuration + ".m") | % name )
	}
    cd ..
}

foreach( $ini in $inis )
{
    Start-Job -ScriptBlock $runFilter -ArgumentList $ini, $awkScriptPath, $patterns, $configuration
}

cd $root