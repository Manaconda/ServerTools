clear-host
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

Get-Item -ErrorAction SilentlyContinue -path  "Microsoft.PowerShell.Core\Registry::HKEY_USERS\*\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\" |
foreach {
    Get-ItemProperty -Path "Microsoft.PowerShell.Core\Registry::$_" | 
    foreach {
        $CurrentUserShellFoldersPath = $_.PSPath
        $SID = $CurrentUserShellFoldersPath.Split('\')[2]
        $_.PSObject.Properties |
        foreach {
            if ($_.Value -like "*resources$*") {
                write-host "Path:`t`t"$CurrentUserShellFoldersPath

                remove-ItemProperty -Path $CurrentUserShellFoldersPath -Name $_.Name
                Write-host "================================================================"
            }
        }
    }
}

get-service "solus*" |Stop-Service
$command="wmic product where ""name like 'solus%%'"" call uninstall /nointeractive"
Invoke-Expression $command

$command="takeown.exe /f C:\programdata\Microsoft\Crypto\RSA\MachineKeys /a /r /d n"
Invoke-Expression $command

$FilesAndFolders = gci "C:\programdata\Microsoft\Crypto\RSA\MachineKeys" -recurse | % {$_.FullName}
foreach($FileAndFolder in $FilesAndFolders)
{
    #using get-item instead because some of the folders have '[' or ']' character and Powershell throws exception trying to do a get-acl or set-acl on them.
    $item = gi -literalpath $FileAndFolder 
    $acl = $item.GetAccessControl() 
    $permission = "Administrators","FullControl","Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    $item.SetAccessControl($acl)
}
$file=Get-ChildItem "C:\programdata\Microsoft\Crypto\RSA\MachineKeys"|where {$_.name -like "*1db350*"}

$command="attrib -s C:\programdata\Microsoft\Crypto\RSA\MachineKeys\*"
Invoke-Expression $command
Get-ChildItem "C:\programdata\Microsoft\Crypto\RSA\MachineKeys"|where {$_.name -like "*1db350*"} |Remove-Item