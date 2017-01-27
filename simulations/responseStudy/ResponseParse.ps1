# Configuration variables

#$patterns = "landingQueue_queueLength", "landingQueue_queueTime" ,"takeoffQueue_queueLength", "takeoffQueue_queueTime", "wg_responseTime", "parkingLot_parkingOccupancy";
$iniName = "responseStudy.ini"
$configuration = "ResponseMeasurement"

$awkScriptPath = "\\PC-RAFF\simulations\parse.awk" 

# Script body

$root = pwd
$inis = Get-ChildItem -Recurse -Filter $iniName

$runFilter =
{
    param($ini, $awkScriptPath, $patterns, $configuration)

    cd $ini.DirectoryName

	Write-Host "Processing " (pwd | % path)
	
    cd results
	
	gawk -f $awkScriptPath -v out=$configuration ( Get-ChildItem -Filter ($configuration + "*.vec") | % name )

    cd ..
}

foreach( $ini in $inis )
{
    Start-Job -ScriptBlock $runFilter -ArgumentList $ini, $awkScriptPath, $patterns, $configuration  
}

cd $root