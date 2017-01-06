#ATTENTO ALLA DIRECTORY DOVE ESEGUI LO SCRIPT!!
#Tieni d'occhio i file (sia target che non) per controllare che effetto c'è stato.
#In caso di singolo errore, c'è il file di backup .old

#Variabili di configurazione:

$rootDir = "/home/raff/omnetpp-5.0/controltower/PESC_Control_Tower/simulations/parkingStudy/"
$iniFilename = "parkingStudy.ini";
$oldLinePattern = "\[Config QueueMeasurement\]"; #le parentesi richiedono l'escape cioè \( e \)
$newLine = "[Config ParkingMeasurement]";

#Inizio script

$currentDir = pwd
cd $rootDir

$inis = Get-ChildItem -Recurse -Filter $iniFilename

foreach($ini in $inis)
{
    #Backup
    Copy-Item -Path $ini.FullName -Destination ($ini.FullName + ".old") 
    
    #Ricerca e sostituzione
    $content = type $ini.FullName;
    $matches = Select-String -Path $ini.FullName -Pattern $oldLinePattern;
    foreach($match in $matches)
    {
        $content[$match.LineNumber - 1] = $newLine;
    }

    Set-Content -Path $ini.FullName -Value $content;
}

cd $currentDir
