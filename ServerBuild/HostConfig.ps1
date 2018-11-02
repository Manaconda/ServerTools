#### AUTO ELEVATE

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
   }


$config=[xml] (get-content "\\app-02\deploymentshare$\Scripts\Config.xml")

$RAM=[int64] $config.config.host.RAM * 1GB
$CPU=$config.config.host.CPU
$OSDISK=[int64] $config.config.host.OSDISK * 1GB
$DATADISK=[int64] $config.config.host.DATADISK * 1GB
$VMPATH=$config.config.host.VMPATH
$IP=$config.config.host.IP
$GATEWAY=$config.config.host.GATEWAY
$DNS=$config.config.host.DNS



# Create Team and Virtual Switch
$nics=Get-NetAdapter
New-NetLbfoTeam -Name "Team" -TeamMembers $nics.name -TeamingMode SwitchIndependent -Confirm:$false
New-VMSwitch -Name "External" -AllowManagementOS $true -NetAdapterName "Team"

# Create Gateway VM
new-vm -Name "Gateway" -MemoryStartupBytes $RAM -BootDevice NetworkAdapter -NewVHDPath ($VMPATH+"\GATEWAY\gateway_disk1.vhdx") -NewVHDSizeBytes $OSDISK -Path $VMPATH -Generation 2 -SwitchName "External"
New-VHD -Path ($VMPATH+"\GATEWAY\gateway_disk2.vhdx") -SizeBytes $DATADISK -Dynamic
Add-VMHardDiskDrive -Path ($VMPATH+"\GATEWAY\gateway_disk2.vhdx") -VMName "Gateway"

# Create SIMS VM
new-vm -Name "SIMSSERVER" -MemoryStartupBytes $RAM -BootDevice VHD -Path $VMPATH -Generation 2 -SwitchName "External"


# Configure VM's
get-vm | Set-VM -ProcessorCount $CPU -AutomaticStartAction Start
get-vm | Enable-VMIntegrationService -Name "Guest Service Interface"
get-vm | Disable-VMIntegrationService -name "Time Synchronization"

# Configure Network
New-NetIPAddress -InterfaceAlias "vEthernet (External)" -IPAddress $IP -PrefixLength 22 -DefaultGateway $GATEWAY
Set-DnsClientServerAddress -InterfaceAlias "vEthernet (External)" -ServerAddresses $DNS

#Disable Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

#Enable Remote Desktop
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" –Value 0

#Disable Enhanced Security
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Value 0
Stop-Process -Name Explorer

#Set Updates to Manual
$WUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$WUSettings.NotificationLevel=2
$WUSettings.save()

#Start VM
Start-VM Gateway


