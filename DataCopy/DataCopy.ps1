$drive=Read-Host "Source Drive (with :)"
$destination=Read-Host "Destination (full path)"
while ($TRUE){
    $source=Read-Host "Directory"
    $arg=""""+$drive+"\"+$source+""""+" "+""""+$destination+"\"+$source+""""+" /e /r:0 /w:0 /mt /log:$source.txt"
    Start-Process "robocopy.exe" -ArgumentList $arg
}