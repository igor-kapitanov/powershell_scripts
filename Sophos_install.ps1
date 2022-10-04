#######Script Starts#########

# Silent Install Sophos AV Client

# Script by Alan O'Brien 2020


# Path for the workdir
$workdir = "c:\temp\"

$sixtyFourBit = Test-Path -Path "C:\Program Files"

$SophosInstalled = Test-Path -Path "C:\Program Files\Sophos"

If ($SophosInstalled){
Write-Host "Sophos Already Installed!"
} ELSE {
Write-Host "Begining the installation"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container){
Write-Host "$workdir already exists" -ForegroundColor Red
} ELSE {
New-Item -Path $workdir -ItemType directory
}

# Download the installer

$source = "Insert your Endpoint link from Sopho central dashboard for the client - right-click to get link location and copy"
$destination = "$workdir\SophosSetup.exe"

# Check if Invoke-Webrequest exists otherwise execute WebClient

if (Get-Command 'Invoke-Webrequest'){
Invoke-WebRequest $source -OutFile $destination
} else {
$WebClient = New-Object System.Net.WebClient
$webclient.DownloadFile($source, $destination)
}

# Start the installation
Start-Process -FilePath "$workdir\SophosSetup.exe" -ArgumentList "--quiet"

Start-Sleep -s 35

Start-Process -FilePath "C:\Program Files\Sophos\Sophos UI\Sophos UI.exe" -ArgumentList "/AUTO"
}

#######Script Ends#########