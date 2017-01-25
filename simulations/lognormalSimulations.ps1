# Configuration variables

$configurations = ("queueStudy.ini", "QueueMeasurement" ),  ( "parkingStudy.ini", "ParkingMeasurement" ), ( "responseStudy.ini", "ResponseMeasurement" );
$repetitions = 150;

$awkParseScriptPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\parse.awk" 
$awkFilterScriptPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\filter_m.awk"

$patterns = "landingQueue_queueLength", "landingQueue_queueTime" ,"takeoffQueue_queueLength", "takeoffQueue_queueTime", "wg_responseTime", "parkingLot_parkingOccupancy";
$iniName = "queueStudy.ini"

$absoluteBinPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\src\ControlTower.exe"
$absoluteSrcPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\src"

# Script body

$root = pwd

$runStudy =
{
    param($ini, $measurement, $awkParseScriptPath, $awkFilterScriptPath, $absoluteBinPath, $absoluteSrcPath, $repetitions)

	$runSimulation =
	{
	    param($ini, $measurement, $awkParseScriptPath, $absoluteBinPath, $absoluteSrcPath, $i)

		cd $ini.DirectoryName
	    Invoke-Expression ($absoluteBinPath + " -r " + $i + " -u Cmdenv -c " + $measurement + " -n " + $absoluteSrcPath + " --debug-on-errors=false " + $ini.Name)	
	}
	
	cd $ini.DirectoryName

    for ($i = 0; $i -lt $repetitions; $i++)
    {
    	Invoke-Command -ScriptBlock $runSimulation -ArgumentList ( $ini, $measurement, $awkParseScriptPath, $absoluteBinPath, $absoluteSrcPath, $i );
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

	$inis = Get-ChildItem -Recurse -Filter $iniName;

	foreach( $ini in $inis )
	{
		if($ini.fullName -match 'lognormal')
		{
			$externalJobs += Start-Job -ScriptBlock $runStudy -ArgumentList ( $ini, $measurement, $awkParseScriptPath, $awkFilterScriptPath, $absoluteBinPath, $absoluteSrcPath, $repetitions )
		}
	}
}

Wait-Job -Job $externalJobs;