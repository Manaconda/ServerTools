#### AUTO ELEVATE

$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($myWindowsPrincipal.IsInRole($adminRole)){
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
}
else {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);
   exit
}

#### START

$installdirectory="c:\program files\LicenseManager"

### Decrypt password
$AESKey = Get-Content $PSScriptRoot\AESKey
$pwdTxt = Get-Content $PSScriptRoot\Credfile
$securePwd = $pwdTxt | ConvertTo-SecureString -Key $AESKey
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePwd)
$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

### Download Files
$executable=$PSScriptRoot+"\executable"
$source = "https://files.404.me.uk/?u=repo&p=$password&path=/executable"
Invoke-WebRequest $source -OutFile $executable

### Create DNS record
$domain=Get-ADDomain
$fqdn=$domain.PDCEmulator
$domainname=$domain.DNSRoot
Add-DnsServerResourceRecord -ZoneName $domainname -Name _VLMCS._tcp -Srv -DomainName $fqdn -Port 1688 -Priority 0 -Weight 0 -ComputerName $fqdn -Verbose

### Create Service
if (!(Test-Path -path $installdirectory)) {New-Item $installdirectory -Type Directory}
Copy-Item $executable -Destination "$installdirectory\LicenseManager.exe"
New-Service -Name "License Manager" -BinaryPathName "$installdirectory\LicenseManager.exe" -DisplayName "License Manager" -StartupType Automatic -Description "License Manager Service."
Start-Service "License Manager"
Remove-Item $executable -Force




