#######Script Starts#########

# Silent Install Chrome

# Path for the workdir
$workdir = "c:\temp\"

$sixtyFourBit = Test-Path -Path "C:\Program Files"

#$ChromeInstalled = Test-Path -Path "C:\Program Files\Google"

#If ($ChromeInstalled){
#Write-Host "OneDrive Already Installed!"
#} ELSE {
#Write-Host "Begining the installation"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container){
Write-Host "$workdir already exists" -ForegroundColor Red
} ELSE {
New-Item -Path $workdir -ItemType directory
}

# Download the installer

$source = "https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x1009&culture=en-ca&country=CA"
$destination = "$workdir\OneDriveSetup.exe"

Invoke-WebRequest -Uri $source -OutFile $destination

# Start the installation
Start-Process -FilePath "$workdir\OneDriveSetup.exe" -ArgumentList "--quiet"

#Start-Sleep -s 35

#######Script Ends#########