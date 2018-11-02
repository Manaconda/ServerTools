$machines=import-csv -Path .\machines.csv

$localaccount=Get-Credential -Message "local account"
$domainaccount=Get-Credential -Message "Domain account"
$domain=Read-Host "Domain to join?"

foreach($machine in $machines){
    write-host $machine.hostname    
    Add-Computer -ComputerName $machine.Hostname -LocalCredential $localaccount -Credential $domainaccount -DomainName $domain
}



######## NOT WORKING
