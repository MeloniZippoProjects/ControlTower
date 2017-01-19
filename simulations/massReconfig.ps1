#ATTENTO ALLA DIRECTORY DOVE ESEGUI LO SCRIPT!!
#Tieni d'occhio i file (sia target che non) per controllare che effetto c'è stato.
#In caso di singolo errore, c'è il file di backup .old

#Variabili di configurazione:

$rootDir = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\"
$oldLinePattern = "sim-time-limit";
$newLine = "sim-time-limit = 5d";

#Inizio script

$currentDir = pwd
cd $rootDir

$inis += Get-ChildItem -Recurse -Filter "queueStudy.ini"
$inis += Get-ChildItem -Recurse -Filter "parkingStudy.ini"
$inis += Get-ChildItem -Recurse -Filter "responseStudy.ini"

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