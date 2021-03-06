﻿$date = Get-Date

#### Fill This bit in ############################################

$logondate = (Get-Date).AddDays(-120) # The 120 is the number of days from today since the last logon.
$action="find" # Set action to "find" "disable" or "delete"
$move="no" # Move to Archive OU?
$ArchiveOU="OU=Computers,OU=ARCHIVE,OU=RichmondHouse,DC=RichmondHouse,DC=local"
$description = "Disabled by AT on $date."
##################################################################
Get-ADComputer -Property Name,lastLogonDate -Filter {(lastLogonDate -lt $logondate) -and (enabled -eq $TRUE)} |Sort-Object lastLogonDate| FT Name,lastLogonDate
$m=Get-ADComputer -Property Name,lastLogonDate -Filter {(lastLogonDate -lt $logondate) -and (enabled -eq $TRUE)} | measure -ErrorAction SilentlyContinue
write-host "Accounts Found : " $m.Count

if ($action -eq "disable") 
{
Write-host "Setting accounts to disabled."
Get-ADComputer -Property Name,lastLogonDate -Filter {(lastLogonDate -lt $logondate) -and (enabled -eq $TRUE)} | Set-ADComputer -Enabled $false
}

if($move -eq "yes")
{
write-host -foregroundcolor yellow "Searching for disabled Accounts"
[System.Threading.Thread]::Sleep(500)
$disabledAccounts = Search-ADAccount -AccountDisabled -ComputersOnly

write-host -foregroundcolor yellow "Moving all disabled Accounts to the Archive OU"
[System.Threading.Thread]::Sleep(500)
$disabledAccounts | Move-ADObject -TargetPath $ArchiveOU
$disabledAccounts | Set-ADComputer -Description $description –passthru
}

if ($action -eq "delete")
{
Write-host "Deleting Accounts"
Get-ADComputer -Property Name,lastLogonDate -Filter {(lastLogonDate -lt $logondate) -and (enabled -eq $TRUE)} | Remove-ADComputer
}



write-host -foregroundcolor yellow "Script Complete" 