while ($true){
Clear-Host
Write-Host "East Ardsley Primary School" -ForegroundColor Yellow
Write-Host "---------------------------`n`n" -ForegroundColor Yellow
Write-Host "1)  List User Accounts"
Write-Host "2)  Reset Password"
Write-Host "3)  Exit`n`n"
$mode=Read-Host "Action (1/2/3) "

if($mode -eq "1"){
    Clear-Host
    Write-Host "East Ardsley Primary School" -ForegroundColor Yellow
    Write-Host "---------------------------`n`n" -ForegroundColor Yellow
    $year=Read-Host "Year (16/15/14/13...) "    
    Get-ADUser -Filter * |where {$_.samaccountname -like "10"] |select-object displayname, samaccountname, discription |format-table
}


if($mode -eq "2"){

}



if($mode -eq "3"){
    break
}

}
