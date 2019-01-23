$drive=Read-Host "Source Drive"
$destination=Read-Host "Destination"
while ($TRUE){
    $source=Read-Host "Directory"
    $arg=""""+$drive+"\"+$source+""""+" "+""""+$destination+"\"+$source+""""+" /e /r:0 /w:0 /mt /log:$source.txt"
    Start-Process "robocopy.exe" -ArgumentList $arg
}