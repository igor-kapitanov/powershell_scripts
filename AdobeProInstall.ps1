
	Write-Host "***** Install Adobe Acrobat Pro *****" -ForegroundColor Green
	Set-ExecutionPolicy Bypass -Scope Process -Force
	#######Script Starts#########

	# Silent Install Adobe Acrobat

	# Path for the workdir
	$workdir = "c:\temp\"

	# Check if work directory exists if not create it
	If (Test-Path -Path $workdir -PathType Container){
	Write-Host "$workdir already exists" -ForegroundColor Red
	} ELSE {
	New-Item -Path $workdir -ItemType directory
	}

	# Download the installer
	$URL = "https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/win32/Acrobat_DC_Web_x64_WWMUI.zip"
	$destination = "$workdir\acrobat.zip"
	Invoke-WebRequest -Uri $URL -OutFile $destination
	
	#unzip the archive
	Expand-Archive -LiteralPath 'C:\temp\acrobat.zip' -DestinationPath C:\temp\

	# Start the installation
	Start-Process -FilePath "C:\temp\Adobe Acrobat\Setup.exe" -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES" -Verb RunAs

