
function Get-MacAddress {
    
        param( [string]$device= $( throw "Please specify device" ) )
    
        if ( $device | ? { $_ -match "[0-9].[0-9].[0-9].[0-9]" } )
        {
          #"Searching by IP Address"
          $ip = $device
    
        } else {
            #"Searching by Host Name"
            $ip = [System.Net.Dns]::GetHostByName($device).AddressList[0].IpAddressToString
        }
    
        $ping = ( new-object System.Net.NetworkInformation.Ping ).Send($ip);
    
        $mac = arp -a;
    
        if($ping)
        {
    
            ( $mac | ? { $_ -match $ip } ) -match "([0-9A-F]{2}([:-][0-9A-F]{2}){5})" | out-null;
    
            if ( $matches ) {
    
                $matches[0];
    
            } else {
    
                "Not Found"
    
            }
        }
    }
    
    
    
    
    $Device=read-host "Device IP"
    $NewName=read-host "New Reservation Name"
    $IPAddress=read-host "New IP"
    $scope=Get-DhcpServerv4Scope
    $DeviceMAC=Get-MacAddress $Device
    
    Remove-DhcpServerv4Lease -ComputerName $env:computername -IPAddress $Device
    
    Add-DhcpServerv4Reservation -ComputerName $env:computername -ScopeId $scope.ScopeId -Name $Device -IPAddress $IPAddress -ClientId $DeviceMAC -Description $Device
    
    