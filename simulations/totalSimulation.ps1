# Configuration variables

$configurations = ("queueStudy.ini", "QueueMeasurement" ),  ( "parkingStudy.ini", "ParkingMeasurement" ), ( "responseStudy.ini", "ResponseMeasurement" );
$repetitions = 150;

$awkScriptPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\parse.awk" 
$absoluteBinPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\src\ControlTower.exe"
$absoluteSrcPath = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\src"

# Script body

$root = pwd



$runStudy =
{
    param($ini, $measurement, $awkScriptPath, $absoluteBinPath, $absoluteSrcPath, $repetitions)

	$runSimulation =
	{
	    param($ini, $measurement, $awkScriptPath, $absoluteBinPath, $absoluteSrcPath, $i)

		#("In runSimulation " + $ini.FullName + " run " + $i) | Out-File -FilePath ($ini.FullName + $i + ".dbg") -Append
			cd $ini.DirectoryName
		#("in directory " + $ini.DirectoryName + " run " + $i) | Out-File -FilePath ($ini.FullName + $i + ".dbg") -Append
		#("about to run" + $absoluteBinPath + " -r " + $i + " -u Cmdenv -c " + $measurement + " -n " + $absoluteSrcPath + " --debug-on-errors=false " + $ini.Name) | Out-File -FilePath ($ini.FullName + $i + ".dbg")
	    Invoke-Expression ($absoluteBinPath + " -r " + $i + " -u Cmdenv -c " + $measurement + " -n " + $absoluteSrcPath + " --debug-on-errors=false " + $ini.Name)	
	}
	
	("In runStudy " + $ini.FullName) | Out-File -FilePath ($ini.FullName + ".dbg") -Append
    	cd $ini.DirectoryName
	("in directory " + $ini.DirectoryName + " run " + $i) | Out-File -FilePath ($ini.FullName + ".dbg") -Append

	#$internalJobs = @();
    for ($i = 0; $i -lt $repetitions; $i++)
    {
		#("About to start internal job " + $ini.DirectoryName) | Out-File -FilePath ($ini.FullName + ".dbg") -Append
    	Invoke-Command -ScriptBlock $runSimulation -ArgumentList ( $ini, $measurement, $awkScriptPath, $absoluteBinPath, $absoluteSrcPath, $i );
		#("Internal job started " + $ini.DirectoryName) | Out-File -FilePath ($ini.FullName + ".dbg") -Append
    }
    #Wait-Job -Job $internalJobs;

	cd results
		gawk -f $awkScriptPath -v out=$measurement ( Get-ChildItem -Filter ($measurement + "-*.vec") | % name )
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
		$externalJobs += Start-Job -ScriptBlock $runStudy -ArgumentList ( $ini, $measurement, $awkScriptPath, $absoluteBinPath, $absoluteSrcPath, $repetitions )
	}
}

Wait-Job -Job $externalJobs;