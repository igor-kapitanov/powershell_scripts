#######Script Starts#########

# Silent Install Chrome

# Path for the workdir
$workdir = "c:\temp\"

$sixtyFourBit = Test-Path -Path "C:\Program Files"

$ChromeInstalled = Test-Path -Path "C:\Program Files\Google"

If ($ChromeInstalled){
Write-Host "Chrome Already Installed!"
} ELSE {
Write-Host "Begining the installation"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container){
Write-Host "$workdir already exists" -ForegroundColor Red
} ELSE {
New-Item -Path $workdir -ItemType directory
}

# Download the installer

$source = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B3003BD0A-F0DB-FA76-98BA-CD085B17CBB4%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"
$destination = "$workdir\ChromeSetup.exe"

Invoke-WebRequest -Uri $source -OutFile $destination

# Start the installation
Start-Process -FilePath "$workdir\ChromeSetup.exe"

#Start-Sleep -s 35
}

#######Script Ends#########