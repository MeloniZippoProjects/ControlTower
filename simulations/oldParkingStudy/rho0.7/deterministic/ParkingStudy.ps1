# Configuration variables

$iniName = "parkingStudy.ini"
$configuration = "ParkingMeasurement"
$repetitions = 1

$awkScriptPath = "/home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/simulations/parse.awk" 
$relativeBinLocation = "/home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/src/PESC_Control_Tower"
$relativePathToSrc = "/home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/src"

# Script body

$root = pwd
$inis = Get-ChildItem -Recurse -Filter $iniName

$runSimulation =
{
    param($ini)

    cd $ini.DirectoryName
    
    for ($i = 0; $i -lt $repetitions; $i++)
    {
        Invoke-Expression ($relativeBinLocation + " -r " + $i + " -u Cmdenv -c " + $configuration + " -n " + $relativePathToSrc + " --debug-on-errors=false " + $iniName)
    }

	Write-Host "inizio parsing con gawk"
	
    cd results
    	gawk -f $awkScriptPath -v out=$configuration ( Get-ChildItem -Filter ($configuration + "-*.vec") | % name )
    cd ..
	
	Write-Host "fine parsing con gawk"
}

foreach( $ini in $inis )
{
    Invoke-Command -ScriptBlock $runSimulation -ArgumentList $ini   
}

cd $root