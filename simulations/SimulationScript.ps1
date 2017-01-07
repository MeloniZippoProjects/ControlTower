# Configuration variables

$iniName = "queueStudy.ini"
$configuration = "QueueMeasurement"
$repetitions = 150
$awkScriptPath = "simulations/parse.awk" 

# Script body

$root = pwd
$inis = Get-ChildItem -Recurse -Filter $iniName

$runSimulation =
{
    param($ini)

    cd $ini.DirectoryName
    
    for ($i = 0; $i -lt 70; $i++)
    {
        ../../../../src/PESC_Control_Tower -r $i -u Cmdenv -c $configuration -n ../../..:../../../../src --debug-on-errors=false $iniName
    }

    cd results
    	gawk -f $awkScriptPath -v out=$configuration ( "./" + $configuration + "-*.vec" )
    cd ..
}

foreach( $ini in $inis )
{
    Invoke-Command -ScriptBlock $runSimulation -ArgumentList $ini   
}

cd $root