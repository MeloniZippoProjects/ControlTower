# Configuration variables

$patterns = "landingQueue_queueLength", "landingQueue_queueTime" ,"takeoffQueue_queueLength", "takeoffQueue_queueTime";
$iniName = "queueStudy.ini"
$configuration = "QueueMeasurement"

$awkScriptPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\filter_m.awk" 

# Script body

$root = pwd
$inis = Get-ChildItem -Recurse -Filter $iniName

$runSimulation =
{
    param($ini)

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
    Invoke-Command -ScriptBlock $runSimulation -ArgumentList $ini   
}

cd $root