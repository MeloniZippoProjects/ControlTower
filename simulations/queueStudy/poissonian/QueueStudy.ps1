$awkScriptPath = "/parse.awk" 

$root = pwd
$inis = Get-ChildItem -Recurse -Filter "queueStudy.ini"

$runSimulation =
{
    param($ini)

    cd $ini.DirectoryName
    
    for ($i = 0; $i -lt 70; $i++)
    {
        ../../../../src/PESC_Control_Tower -r $i -u Cmdenv -c QueueMeasurement -n ../../..:../../../../src --debug-on-errors=false queueStudy.ini
    }

    cd results
    	gawk -f $awkScriptPath -v out=QueueMeaseurement ./QueueMeasurement-*.vec
    cd ..
}

foreach( $ini in $inis )
{
    Invoke-Command -ScriptBlock $runSimulation -ArgumentList $ini   
}

cd $root

#Get-Job | Wait-Job

#$ cd /home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/simulations/queueStudy/deterministic/rho0.1
#$ ../../../../src/PESC_Control_Tower -r 69 -u Cmdenv -c QueueMeasurement -n ../../..:../../../../src --debug-on-errors=false queueStudy.ini
