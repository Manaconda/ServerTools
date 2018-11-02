Param(
    [Parameter(Mandatory=$true)]
    [String]$Path,
    [Parameter(Mandatory=$true)]
    [String]$LocalAdminPass, 
    [Parameter(Mandatory=$true)]
    [String]$Domain,
    [Parameter(Mandatory=$false)]
    [SecureString]$DomainCredential,
    [Parameter(Mandatory=$false)]
    [String]$OU
)

$SecurePassword = $LocalAdminPass | ConvertTo-SecureString -AsPlainText -Force

if (!$DomainCredential){
    $DomainAccount=Get-Credential -Message "Domain Join Credential (domain\username) "
}

$Computers=import-csv $Path -ErrorAction Stop

foreach($computer in $Computers){
    Write-Host "Adding $($computer.hostname) to $domain" -ForegroundColor Yellow
    $UserName = "$($computer.hostname)\administrator"
    $LocalCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
    if($ou){
        Add-Computer -ComputerName $($computer.hostname) -DomainName $Domain -LocalCredential $LocalCredentials -Credential $DomainAccount -restart -Force -OUPath $OU
    }
    else {
        Add-Computer -ComputerName $($computer.hostname) -DomainName $Domain -LocalCredential $LocalCredentials -Credential $DomainAccount -restart -Force
    }
}

