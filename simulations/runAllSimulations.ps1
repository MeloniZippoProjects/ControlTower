# Configuration variables

$configurations = ("queueStudy.ini", "QueueMeasurement" ),  ( "parkingStudy.ini", "ParkingMeasurement" );
#$configurations = ("queueStudy.ini", "WarmupMeasurement" ),  ( "parkingStudy.ini", "WarmupMeasurement" );
$repetitions = 50;

$patterns = "landingQueue_queueLength", "landingQueue_queueTime" ,"takeoffQueue_queueLength", "takeoffQueue_queueTime", "parkingLot_parkingOccupancy";

$absoluteBinPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\src\ControlTower.exe"
$absoluteSrcPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\src"

$awkParseScriptPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\parseVectors.awk" 
$awkFilterScriptPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\splitVectors.awk"


# Script body

$root = pwd

$runStudy =
{
    param($ini, $measurement, $awkParseScriptPath, $awkFilterScriptPath, $patterns, $absoluteBinPath, $absoluteSrcPath, $repetitions)

	$runSimulation =
	{
        param($ini, $measurement, $awkParseScriptPath, $absoluteBinPath, $absoluteSrcPath, $repetitions)
		cd $ini.DirectoryName
	    Invoke-Expression ($absoluteBinPath + " -r " + $i + " -u Cmdenv -c " + $measurement + " -n " + $absoluteSrcPath + " --debug-on-errors=false " + $ini.Name)	
	}
	
	cd $ini.DirectoryName

    for ($i = 0; $i -lt $repetitions; $i++)
    {
    	Invoke-Command -ScriptBlock $runSimulation -ArgumentList ($ini, $measurement, $awkParseScriptPath, $absoluteBinPath, $absoluteSrcPath, $repetitions);
    }

	cd results
		gawk -f $awkParseScriptPath -v out=$measurement ( Get-ChildItem -Filter ($measurement + "-*.vec") | % name )

        foreach($pattern in $patterns)
        {
            gawk -f $awkFilterScriptPath -v pattern=$pattern ( Get-ChildItem -Filter ($measurement + ".m") | % name )
        }
}

$externalJobs = @();
foreach ( $configuration in $configurations )
{
	cd $root

	$iniName = $configuration[0];
	$measurement = $configuration[1];

    if(!($iniName -match 'parkingStudy.ini'))
    {
        continue;
    }

	$inis = Get-ChildItem -Recurse -Filter $iniName;

	foreach( $ini in $inis )
	{
        if(!($ini.fullName -match 'parkingStudy_interarrival'))
        {
            continue;
        }
        
		$externalJobs += Start-Job -ScriptBlock $runStudy -ArgumentList ($ini, $measurement, $awkParseScriptPath, $awkFilterScriptPath, $patterns, $absoluteBinPath, $absoluteSrcPath, $repetitions)
	}
}
Wait-Job -Job $externalJobs