Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature DHCP -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature Print-Server -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature WDS -IncludeAllSubFeature -IncludeManagementTools -Confirm
## Install-WindowsFeature UpdateServices -IncludeAllSubFeature -IncludeManagementTools -Confirm ## only 1 type of db !!
Install-WindowsFeature RSAT-Feature-Tools-BitLocker -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature Telnet-Client -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature Search-Service -IncludeAllSubFeature -IncludeManagementTools -Confirm

netsh firewall set opmode mode = DISABLE profile = ALL


$AdminKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}”
Set-ItemProperty -Path $AdminKey -Name “IsInstalled” -Value 0
Stop-Process -Name Explorer

