#ATTENTO ALLA DIRECTORY DOVE ESEGUI LO SCRIPT!!
#Tieni d'occhio i file (sia target che non) per controllare che effetto c'è stato.
#In caso di singolo errore, c'è il file di backup .old

#Variabili di configurazione:

$rootDir = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\parkingStudy\rho0.7\"
$iniFilename = "parkingStudy.ini";
$oldLinePattern = "SimNetwork.a.runway.throughputCheckInterval = 100min"; #le parentesi richiedono l'escape cioè \( e \)
$newLine = "SimNetwork.a.runway.throughputCheckInterval = 28.571min";

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