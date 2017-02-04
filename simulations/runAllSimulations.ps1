# Configuration variables

$configurations = ("queueStudy.ini", "QueueMeasurement" ),  ( "parkingStudy.ini", "ParkingMeasurement" );
$repetitions = 50;

$vectors = "landingQueue_queueLength", "landingQueue_queueTime" ,"takeoffQueue_queueLength", "takeoffQueue_queueTime",
            "parkingLot_parkingOccupancy", "runway_landingInterLeaving", "runway_takeoffInterLeaving", "parkingLot_parkingInterLeaving";

$relativeBinPath = ".\src\ControlTower.exe";
$relativeSrcPath = ".\src"

$relativeAwkParsePath = ".\simulations\parseVectors.awk" 
$relativeAwkSplitPath = ".\simulations\splitVectors.awk"

# Absolute paths computation
$rootDirectory = (Get-Location).Path;
$absoluteBinPath = Join-Path $rootDirectory $relativeBinPath;
$absoluteSrcPath = Join-Path $rootDirectory $relativeSrcPath;
$absoluteAwkParsePath = Join-Path $rootDirectory $relativeAwkParsePath;
$absoluteAwkSplitPath = Join-Path $rootDirectory $relativeAwkSplitPath;


# Script body
$executeIni =
{
    param($ini, $measurement, $absoluteAwkParsePath, $absoluteAwkSplitPath, $vectors, $absoluteBinPath, $absoluteSrcPath, $repetitions)

	$executeSingleRepetition =
	{
        param($ini, $measurement, $absoluteAwkParsePath, $absoluteBinPath, $absoluteSrcPath, $repetitions)
		cd $ini.DirectoryName
	    Invoke-Expression ($absoluteBinPath + " -r " + $i + " -u Cmdenv -c " + $measurement + " -n " + $absoluteSrcPath + " --debug-on-errors=false " + $ini.Name)	
	}
	
	cd $ini.DirectoryName

    for ($i = 0; $i -lt $repetitions; $i++)
    {
    	Invoke-Command -ScriptBlock $executeSingleRepetition -ArgumentList ($ini, $measurement, $absoluteAwkParsePath, $absoluteBinPath, $absoluteSrcPath, $repetitions);
    }

	cd results
		gawk -f $absoluteAwkParsePath -v out=$measurement ( Get-ChildItem -Filter ($measurement + "-*.vec") | % name )

        foreach($vector in $vectors)
        {
            gawk -f $absoluteAwkSplitPath -v pattern=$vector ($measurement + ".m")
        }
}

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
Wait-Job -Job $jobs