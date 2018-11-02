Write-Host "Provide tenancy Credentials" -ForegroundColor Yellow
$cred=Get-Credential
Write-Host "Attempting to connect to Exchange Online" -ForegroundColor Yellow
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $session -ErrorAction Stop
Write-Host "Connected" -ForegroundColor Green

$moreusers=1
$mailbox=read-host "Mailbox to change (email address)"

while ($moreusers=1) {
    $User=read-host "Give permission to (email address)"
    Get-Mailbox -Identity $mailbox | Add-mailboxpermission -user $user -AccessRights FullAccess
    $anotheruser=Read-Host "Add another user? (y/n)"
    if($anotheruser -ne "y"){
        Exit-PSSession
        Exit
        
    }
}