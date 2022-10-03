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
"*Photos*" #Photos, Video editor
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

RemoveMcAfee