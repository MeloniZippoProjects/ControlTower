# Configuration variables

$iniName = "queueStudy.ini"
$configuration = "QueueMeasurement"
$repetitions = 150

$awkScriptPath = "/home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/simulations/parse.awk" 
$absoluteBinPath = "/home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/src/PESC_Control_Tower"
$absoluteSrcPath = "/home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/src"

# Script body

$root = pwd
$inis = Get-ChildItem -Recurse -Filter $iniName

$runSimulation =
{
    param($ini)

    cd $ini.DirectoryName
    
    for ($i = 0; $i -lt $repetitions; $i++)
    {
        Invoke-Expression ($absoluteBinPath + " -r " + $i + " -u Cmdenv -c " + $configuration + " -n " + $absoluteSrcPath + " --debug-on-errors=false " + $iniName)
    }

	gawk -f $awkScriptPath -v out=$configuration ( Get-ChildItem -Filter ($configuration + "-*.vec") | % name )
}

foreach( $ini in $inis )
{
    Invoke-Command -ScriptBlock $runSimulation -ArgumentList $ini   
}

cd $root