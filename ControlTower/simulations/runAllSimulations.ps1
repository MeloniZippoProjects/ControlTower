# Script used to execute many simulations in parallel.
# First, the script finds the .ini files representing the scenarios to execute. A parallel job is executed for each scenario
# Each scenario is then executed. The results are then collected using gawk scripts.

# Configuration variables

$configurations = ("queueStudy.ini", "QueueMeasurement" ),  ( "parkingStudy.ini", "ParkingMeasurement" );
$repetitions = 50;

$vectors = "landingQueue_queueLength", "landingQueue_queueTime" ,"takeoffQueue_queueLength", "takeoffQueue_queueTime",
            "parkingLot_parkingOccupancy", "runway_landingInterLeaving", "runway_takeoffInterLeaving", "parkingLot_parkingInterLeaving";

$relativeBinPath = "..\src\ControlTower.exe";
$relativeSrcPath = "..\src";

$relativeAwkParsePath = "..\simulations\parseVectors.awk";
$relativeAwkSplitPath = "..\simulations\splitVectors.awk";

# Absolute paths computation
$rootDirectory = (Get-Location).Path;
$absoluteBinPath = Join-Path $rootDirectory $relativeBinPath;
$absoluteSrcPath = Join-Path $rootDirectory $relativeSrcPath;
$absoluteAwkParsePath = Join-Path $rootDirectory $relativeAwkParsePath;
$absoluteAwkSplitPath = Join-Path $rootDirectory $relativeAwkSplitPath;

# Parallel Job body
$executeIni =
{
    param($ini, $measurement, $absoluteAwkParsePath, $absoluteAwkSplitPath, $vectors, $absoluteBinPath, $absoluteSrcPath, $repetitions)

	cd $ini.DirectoryName

    for ($i = 0; $i -lt $repetitions; $i++)
    {
        #Executes a single repetition of the scenario
        Invoke-Expression ($absoluteBinPath + " -r " + $i + " -u Cmdenv -c " + $measurement + " -n " + $absoluteSrcPath + " --debug-on-errors=false " + $ini.Name)
    }

	cd results
        #Parses the result files to a .m file and a .csv file
		gawk -f $absoluteAwkParsePath -v out=$measurement ( Get-ChildItem -Filter ($measurement + "-*.vec") | % name )

        #Splits the .m file in a .m file per result vector
        foreach($vector in $vectors)
        {
            gawk -f $absoluteAwkSplitPath -v pattern=$vector ($measurement + ".m")
        }
}

#Script body: locates the scenario files and starts a parallel job for each
$jobs = @();
foreach ( $configuration in $configurations )
{
	cd $rootDirectory

	$iniName = $configuration[0];
	$measurement = $configuration[1];

	$inis = Get-ChildItem -Recurse -Filter $iniName;

	foreach( $ini in $inis )
	{
		$jobs += Start-Job -ScriptBlock $executeIni -ArgumentList ($ini, $measurement, $absoluteAwkParsePath, $absoluteAwkSplitPath, $vectors, $absoluteBinPath, $absoluteSrcPath, $repetitions)
    }
}

#The script terminates after all jobs are completed
Wait-Job -Job $jobs