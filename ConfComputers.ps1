function LenovoUpdates
{
	Write-Host "***** Update Drivers *****" -ForegroundColor Green
	Start-Process cmd -ArgumentList "/c PresentationSettings /start" -NoNewWindow
	Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
	Install-PackageProvider -Name NuGet -Force
	Install-Module -Name 'LSUClient' -Force
	$updates = Get-LSUpdate
	$updates | Install-LSUpdate -Verbose
	
}

function WinUpdates
{
	Write-Host "***** Update Windows *****" -ForegroundColor Green
	Install-Module PSWindowsUpdate -Force
	Get-WindowsUpdate -AcceptAll -IgnoreRebootRequired -Install #-AutoReboot
}

function InstallPrograms
{
	Write-Host "***** Install Programs *****" -ForegroundColor Green
	# Install Chocolatey
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

	#Update Chocolatey
	choco upgrade chocolatey -y
	
	#Install Chocolatey Auto Package Updater
	choco install chocolateypackageupdater -y
	
	# Install Adobe Acrobat DC
	choco install adobereader -y

	# Install Google Chrome
	choco install googlechrome -y

	# Install 7zip
	choco install 7zip.install -y

	# Install Microsoft .NET 4.8
	choco install dotnetfx -y
	
	#Install Microsoft .NET 4.8
	choco install netfx-4.8 -y

	# Install Zoom Client
	choco install zoom -y
	
	#Install Microsoft 365 Business
	choco install office365business -y
	
	#Install Microsoft Visual C++
	choco install vcredist140 -y
	
	#Update OneDrive
	choco upgrade onedrive -y
	
	#Install FireFox
	choco install firefox -y
	
	#Install AnyDesk
	choco install anydesk.install -y
	
	#Install Dotnet 3.5
	choco install dotnet3.5 -y
	
	#Install Donnet 4.5
	choco install dotnet4.5.2 -y
	
	#Install DirectX 9.29
	choco install directx -y
	
	#Install Speedtest
	choco install speedtest-by-ookla -y
	
	#Install powershell 7.2.5
	choco install powershell-core -y
	
	#Install Autoruns
	choco install autoruns -y
	
	#Install Lenovo System Update
	choco install lenovo-thinkvantage-system-update -y
	
	#Install Grammarly for Windows
	choco install grammarly-for-windows -y
	
	#Install Grammarly for Chrome
	choco install grammarly-chrome -y
	
	#Install IP Scanner
	choco install advanced-ip-scanner -y
	
	#Install Process Monitor
	choco install procmon -y
	
	#Install DisplayLink 10.2
	choco install displaylink -y
	
	#Install Adblock Plus for Chrome
	choco install adblockpluschrome -y
	
	#Install CrystalDiskInfo
	choco install crystaldiskinfo.install -y
	
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
	
	
		
}

function PowerNetwork
{
	 $adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement
    foreach ($adapter in $adapters)
        {
        $adapter.AllowComputerToTurnOffDevice = 'Disabled'
        $adapter | Set-NetAdapterPowerManagement
        }
}

function UnpinApp([string]$appname) {
	Write-Host "***** UnPin programs from TaskBar *****" -ForegroundColor Green
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() |
        ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt()}
}

function RegChange
{
	Write-Host "***** UnPin programs from TaskBar *****" -ForegroundColor Green
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 1
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds -Name ShellFeedsTaskbarViewMode -Value 2
	Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5
}

function StartUnpin
{
Write-Host "***** Delete preInstall programs *****" -ForegroundColor Green

$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

$layoutFile="C:\Windows\StartMenuLayout.xml"

#Delete layout file if it already exists
If(Test-Path $layoutFile)
{
    Remove-Item $layoutFile
}

#Creates the blank layout file
$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

$regAliases = @("HKLM", "HKCU")

#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    IF(!(Test-Path -Path $keyPath)) { 
        New-Item -Path $basePath -Name "Explorer"
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
}

#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
Stop-Process -name explorer
Start-Sleep -s 5
$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
Start-Sleep -s 5

#Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}

#Restart Explorer and delete the layout file
Stop-Process -name explorer

# Uncomment the next line to make clean start menu default for all new users
#Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

Remove-Item $layoutFile
}

function RemoveMcAfee
{
Write-Host "***** Delete preInstall programs *****" -ForegroundColor Green
$appname = @(
"E046963F.LenovoCompanion"
"*E0469640.LenovoUtility"
"*SkypeApp*"
"*LinkedIn*"
"*Xbox*"
"*3DViewer*"
"*SolitaireCollection*"
"*FeedbackHub*"
"*Maps*"
"*YourPhone*"
"*Portal"
"*Getstarted*"
"*Alarms*"
"*GetHelp*"
"*Messaging"
"*People"
"*news*"
"*office*"
"*Print3D*"
"*Wallet*"
"Windows PC Health Check"
"*SmartAudio3*"
"*communicationsapps*" #Mail, calendar
"*Disney*"
"*Spotify*"
"*Dolby*"
"*ScreenSketch*"
"*IntelGraphicsExperience*"
"*MSPaint*" #Paint 3D
"*Bing*"
"*PrimeVideo*"
"*TikTok*"
"*AdobePhotoshopExpress*"
"*SoundRecorder*"
"*549981C3F5F10*" #Cortana
#"*Photos*" #Photos, Video editor
"*GlancebyMirametrix*"
"*LenovoSettingsforEnterprise*"
"*RealtekAudioControl*"
"*NVIDIAControlPanel*"
"*SynapticsUtilities*"
)

ForEach($app in $appname)
{
Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
Get-Package -Name $app | Uninstall-Package -Name $app -ErrorAction SilentlyContinue
Get-AppXProvisionedPackage -Online | where DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

### Download McAfee Consumer Product Removal Tool ###

## Create Temp Directory ##
New-Item -ItemType Directory -Force -Path C:\Temp\RemoveMcafee

# Download Source
$URL = 'http://download.mcafee.com/molbin/iss-loc/SupportTools/MCPR/MCPR.exe'

# Set Save Directory
$destination = 'C:\Temp\RemoveMcafee\MCPR.EXE'

#Download the file
Invoke-WebRequest -Uri $URL -OutFile $destination

## Navigate to directory
cd C:\Temp\RemoveMcafee

# Run Tool
Start-Process -WindowStyle minimized  -FilePath "MCPR.exe"
## Sleep for 20 seconds file fike extracts
Start-sleep -Seconds 20

# Navigate to temp folder
cd $Env:LocalAppdata\Temp

# Copy Temp Files
copy-item -Path .\MCPR\ -Destination c:\Temp\RemoveMcAfee -Recurse -Force

# Kill Mcafee Consumer Product Removal Tool
#Taskkill /IM "McClnUI.exe" /F

# Automate Removal and kill services
#cd c:\Temp\RemoveMcAfee\MCPR\
#.\Mccleanup.exe -p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s


}

function CreateUsers
{
    Write-Host "***** Create admin users *****" -ForegroundColor Green
	#Create CITadmin user
	$user1 = "CITadmin"
	$fname1 = "CITadmin"
    $password1 = ConvertTo-SecureString "Pft,bcm2" -AsPlainText -Force
    New-LocalUser $user1 -Password $password1 -FullName $fname1 -Description "CIT admin user"
    Set-LocalUser $user1 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
    Add-LocalGroupMember -Group "Administrators" -Member $user1 -ErrorAction stop
	
    #Create Install user
	$user2 = "Install"
	$fname2 = "Install"
    $password2 = ConvertTo-SecureString "CloudIT1!" -AsPlainText -Force
    New-LocalUser $user2 -Password $password2 -FullName $fname2 -Description "second CIT admin user"
    Set-LocalUser $user2 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
    Add-LocalGroupMember -Group "Administrators" -Member $user2 -ErrorAction stop
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

LenovoUpdates
WinUpdates
InstallPrograms
PowerNetwork
UnpinApp("Microsoft Store")
UnpinApp("Microsoft Edge")
RegChange
StartUnpin
RemoveMcAfee
CreateUsers
DelAdminPriv
Restart-Computer -Force