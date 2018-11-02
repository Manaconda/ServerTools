$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication  Basic -AllowRedirection
Import-PSSession $Session

$mailbox=Read-Host "Maibox eg. Andy Taylor"
get-mailbox -Identity $mailbox
while($true){
    $user=read-host "user eg. Andy Taylor"
    Add-MailboxPermission -Identity $mailbox -User $user -AccessRights FullAccess -InheritanceType All
}