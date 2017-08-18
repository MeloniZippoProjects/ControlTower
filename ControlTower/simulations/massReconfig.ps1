# Utility for quick reconfiguration of many .ini files. 

#PAY ATTENTION TO THE DIRECTORY WHERE YOU EXECUTE THE SCRIPT!!!1
#In case of an error, the script keeps a .old backup for each file.

#Configuration variables
$rootDir = "D:\Users\Raff\Documents\GitHub\PESC_Control_Tower\simulations\";
$filename = "parkingStudy.ini";
$oldLinePattern = "sim-time-limit";
$newLine = "sim-time-limit = 25d";

#script start

$currentDir = pwd
cd $rootDir

$inis += Get-ChildItem -Recurse -Filter $filename;

foreach($ini in $inis)
{
    #Backup
    Copy-Item -Path $ini.FullName -Destination ($ini.FullName + ".old") 
    
    #Find and replace string
    $content = type $ini.FullName;
    $matches = Select-String -Path $ini.FullName -Pattern $oldLinePattern;
    foreach($match in $matches)
    {
        $content[$match.LineNumber - 1] = $newLine;
    }

    Set-Content -Path $ini.FullName -Value $content;
}

cd $currentDir