function ModuleInstall
{
	Write-Host "***** Install Modules *****" -ForegroundColor Green
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	Start-Process cmd -ArgumentList "/c PresentationSettings /start" -NoNewWindow
	Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
	Install-PackageProvider -Name NuGet -Force
	Install-Module PSWindowsUpdate -Force
}

function DriversUpdate
{
$mfc = Get-WmiObject Win32_ComputerSystem | Select-Object manufacturer

switch -Wildcard ($mfc){
'*dell*'{
Write-Host "***** Update Dell Drivers *****" -ForegroundColor Green	
#This is to ensure that if an error happens, this script stops. 
$ErrorActionPreference = "Stop"

### Set your variables below this line ###
$DownloadURL = "https://wolftech.cc/6516510615/DCU.EXE"
$DownloadLocation = "C:\Temp"
$Reboot = "enable"
### Set your variables above this line ###

write-host "Download URL is set to $DownloadURL"
write-host "Download Location is set to $DownloadLocation"
 
#Check for 32bit or 64bit
$DCUExists32 = Test-Path "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
write-host "Does C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe exist? $DCUExists32"
$DCUExists64 = Test-Path "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe"
write-host "Does C:\Program Files\Dell\CommandUpdate\dcu-cli.exe exist? $DCUExists64"

if ($DCUExists32 -eq $true) {
    $DCUPath = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
}    
elseif ($DCUExists64 -eq $true) {
    $DCUPath = "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe"
}

if (!$DCUExists32 -And !$DCUExists64) {
    
        $TestDownloadLocation = Test-Path $DownloadLocation
        write-host "$DownloadLocation exists? $($TestDownloadLocation)"
        
        if (!$TestDownloadLocation) { new-item $DownloadLocation -ItemType Directory -force 
            write-host "Temp Folder has been created"
        }
        
        $TestDownloadLocationZip = Test-Path "$($DownloadLocation)\DellCommandUpdate.exe"
        write-host "DellCommandUpdate.exe exists in $($DownloadLocation)? $($TestDownloadLocationZip)"
        
        if (!$TestDownloadLocationZip) { 
            write-host "Downloading DellCommandUpdate..."
            Invoke-WebRequest -UseBasicParsing -Uri $DownloadURL -OutFile "$($DownloadLocation)\DellCommandUpdate.exe"
            write-host "Installing DellCommandUpdate..."
            Start-Process -FilePath "$($DownloadLocation)\DellCommandUpdate.exe" -ArgumentList "/s" -Wait
            $DCUExists = Test-Path "$($DCUPath)"
            write-host "Done. Does $DCUPath exist now? $DCUExists"
            set-service -name 'DellClientManagementService' -StartupType Manual 
            write-host "Just set DellClientManagmentService to Manual"  
        }
}
    


$DCUExists = Test-Path "$DCUPath"
write-host "About to run $DCUPath. Lets be sure to be sure. Does it exist? $DCUExists"

Start-Process "$($DCUPath)" -ArgumentList "/scan -report=$($DownloadLocation)" -Wait
write-host "Checking for results."


$XMLExists = Test-Path "$DownloadLocation\DCUApplicableUpdates.xml"
if (!$XMLExists) {
        write-host "Something went wrong. Waiting 60 seconds then trying again..."
     Start-Sleep -s 60
    Start-Process "$($DCUPath)" -ArgumentList "/scan -report=$($DownloadLocation)" -Wait
    $XMLExists = Test-Path "$DownloadLocation\DCUApplicableUpdates.xml"
    write-host "Did the scan work this time? $XMLExists"
}
if ($XMLExists -eq $true) {
    [xml]$XMLReport = get-content "$DownloadLocation\DCUApplicableUpdates.xml"
    $AvailableUpdates = $XMLReport.updates.update
     
    $BIOSUpdates = ($XMLReport.updates.update | Where-Object { $_.type -eq "BIOS" }).name.Count
    $ApplicationUpdates = ($XMLReport.updates.update | Where-Object { $_.type -eq "Application" }).name.Count
    $DriverUpdates = ($XMLReport.updates.update | Where-Object { $_.type -eq "Driver" }).name.Count
    $FirmwareUpdates = ($XMLReport.updates.update | Where-Object { $_.type -eq "Firmware" }).name.Count
    $OtherUpdates = ($XMLReport.updates.update | Where-Object { $_.type -eq "Other" }).name.Count
    $PatchUpdates = ($XMLReport.updates.update | Where-Object { $_.type -eq "Patch" }).name.Count
    $UtilityUpdates = ($XMLReport.updates.update | Where-Object { $_.type -eq "Utility" }).name.Count
    $UrgentUpdates = ($XMLReport.updates.update | Where-Object { $_.Urgency -eq "Urgent" }).name.Count
    
    #Print Results
    write-host "Bios Updates: $BIOSUpdates"
    write-host "Application Updates: $ApplicationUpdates"
    write-host "Driver Updates: $DriverUpdates"
    write-host "Firmware Updates: $FirmwareUpdates"
    write-host "Other Updates: $OtherUpdates"
    write-host "Patch Updates: $PatchUpdates"
    write-host "Utility Updates: $UtilityUpdates"
    write-host "Urgent Updates: $UrgentUpdates"
}

if (!$XMLExists) {
    write-host "We tried again and the scan still didn't run. Not sure what the problem is, but if you run the script again it'll probably work."
    exit 1
}
else {
    #We now remove the item, because we don't need it anymore, and sometimes fails to overwrite
    remove-item "$DownloadLocation\DCUApplicableUpdates.xml" -Force    
}
$Result = $BIOSUpdates + $ApplicationUpdates + $DriverUpdates + $FirmwareUpdates + $OtherUpdates + $PatchUpdates + $UtilityUpdates + $UrgentUpdates
write-host "Total Updates Available: $Result"
if ($Result -gt 0) {

    $OPLogExists = Test-Path "$DownloadLocation\updateOutput.log"
    if ($OPLogExists -eq $true) {
        remove-item "$DownloadLocation\updateOutput.log" -Force
    }

    write-host "Lets do it! Updating Drivers. This may take a while..."
    Start-Process "$($DCUPath)" -ArgumentList "/applyUpdates -autoSuspendBitLocker=enable -reboot=$($Reboot) -outputLog=$($DownloadLocation)\updateOutput.log" -Wait
    Start-Sleep -s 60
    Get-Content -Path '$DownloadLocation\updateOutput.log'
    write-host "Done."
    exit 0
}
}
#'*HP*'{
	# do hp stuff
#}
'*lenovo*' {
Write-Host "***** Update Lenovo Drivers *****" -ForegroundColor Green
choco install lenovo-thinkvantage-system-update -y
Start-Process cmd -ArgumentList "/c PresentationSettings /start" -NoNewWindow
Install-Module -Name 'LSUClient' -Force
Get-LSUpdate | Install-LSUpdate -Verbose
}
		#etc
}
}

function WinUpdates
{
	Write-Host "***** Update Windows *****" -ForegroundColor Green
	Get-WindowsUpdate -AcceptAll -Install
	#-IgnoreRebootRequired #-AutoReboot
}

function InstallPrograms
{
	Write-Host "***** Install Programs *****" -ForegroundColor Green
	$appname = @(
		"chocolateypackageupdater"
		"adobereader"
		"7zip.install"
		"dotnetfx"
		"netfx-4.8"
		"zoom"
		"office365business"
		"vcredist140"
		"firefox"
		"anydesk.install"
		"dotnet4.5.2"
		"directx"
		"speedtest-by-ookla"
		"powershell-core"
		"autoruns"
		"grammarly-for-windows"
		"grammarly-chrome"
		"advanced-ip-scanner"
		"procmon"
		"displaylink"
		"adblockpluschrome"
		"googlechrome"
		"onedrive"
	)

	ForEach($app in $appname)
	{
		choco install $app -y
	}
	
	#Install CrystalDiskInfo
	#choco install crystaldiskinfo.install -y
	
	#Install Dell Command Update
	#choco install dellcommandupdate -y
	
	#Install HP Support Assistant
	#choco install hpsupportassistant -y
	
	#Install PuTTY
	#choco install putty.install -y
	
	#Install NotePad++
	#choco install notepadplusplus -y
	
	#Install Avira Free Antivirus
	#choco install avirafreeantivirus -y
	
	#Install Speccy
	#choco install speccy -y
	
	#Install iCloud
	#choco install icloud -y
	
	#Install LastPass for Chrome
	#choco install lastpass-chrome -y
	
	#Install Slack
	#choco install slack -y
	
	#Install Microsoft RDP client
	#choco install remote-desktop-client -y
	
	#Install mRemoteNG
	#choco install mremoteng -y
}

function PowerSettings
{
	Write-Host "***** Change Power Network *****" -ForegroundColor Green
	$adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement
    foreach ($adapter in $adapters)
        {
        $adapter.AllowComputerToTurnOffDevice = 'Disabled'
        $adapter | Set-NetAdapterPowerManagement
        }
		
	Write-Host "***** Change Power Settings *****" -ForegroundColor Green
	Powercfg /Change monitor-timeout-ac 30
	Powercfg /Change monitor-timeout-dc 15
	Powercfg /Change standby-timeout-ac 0
	Powercfg /Change standby-timeout-dc 30
}

function RegChange
{
	Write-Host "***** UnPin programs from TaskBar *****" -ForegroundColor Green
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 1
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds -Name ShellFeedsTaskbarViewMode -Value 2
	Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5
	Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -Value 1
}

function CreateUsers
{
	Write-Host "***** Create admin users *****" -ForegroundColor Green
	#Create CITadmin user
	$user1 = "CITadmin"
	$fname1 = "CITadmin"
    $password1 = ConvertTo-SecureString "Pft,bcm2" -AsPlainText -Force
    New-LocalUser $user1 -Password $password1 -FullName $fname1 -Description "first admin user"
    Set-LocalUser $user1 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
   	
    #Create Install user
	$user2 = "Install"
	$fname2 = "Install"
    $password2 = ConvertTo-SecureString "CloudIT1!" -AsPlainText -Force
    New-LocalUser $user2 -Password $password2 -FullName $fname2 -Description "the second admin user"
    Set-LocalUser $user2 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
	
	#Add users to yhe groups
	Add-LocalGroupMember -Group "Administrators" -Member $user1, $user2 -ErrorAction stop
	Add-LocalGroupMember -Group "Users" -Member $user1, $user2 -ErrorAction stop
	Add-LocalGroupMember -Group "Users" "User"
    
}

function DelAdminPriv
{
	Write-Host "***** Change an admin privilages *****" -ForegroundColor Green
	$Users = Get-LocalUser | select -Property name, enabled
	Get-LocalUser | select -Property name, enabled
	Write-Host "delete user from admins? Which one?" -ForegroundColor DarkYellow
	foreach ($user in $Users){
	Write-host  $user.Name  -ForegroundColor Cyan
	}
	$chosen = read-host "write the user name (empty to skip)"
		if($chosen){
			try{
				Remove-LocalGroupMember -Group "Administrators" -Member $chosen -ErrorAction Stop
			}catch{
				$errs = $_.Exception.Message
				while ($errs -ne $null){
				foreach ($err in $errs){
					Write-Host $err -ForegroundColor Red
					write-host Try again -ForegroundColor Cyan
						}try{
							$chosen01 = read-host "delete user from admins? Which one? (empty to skip)"
							if([string]::IsNullOrEmpty($chosen01)){
								Write-Host "-----skipped-----"
								$errs=$null
							}else{Remove-LocalGroupMember -Group "Administrators" -Member $chosen01 -ErrorAction Stop}
					}catch{
						$errs = $_.Exception.Message
					}
				}
			}
		}else{Write-Host "-----skipped-----" }
}

ModuleInstall
DriversUpdate
WinUpdates
InstallPrograms
PowerSettings
RegChange
CreateUsers
DelAdminPriv