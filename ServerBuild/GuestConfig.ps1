# rdp
# firewall off
# ie enhanced



Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature DHCP -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature Print-Server -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature WDS -IncludeAllSubFeature -IncludeManagementTools -Confirm
## Install-WindowsFeature UpdateServices -IncludeAllSubFeature -IncludeManagementTools -Confirm ## only 1 type of db !!
Install-WindowsFeature RSAT-Feature-Tools-BitLocker -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature Telnet-Client -IncludeAllSubFeature -IncludeManagementTools -Confirm
Install-WindowsFeature Search-Service -IncludeAllSubFeature -IncludeManagementTools -Confirm

