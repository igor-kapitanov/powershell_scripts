function InstallPrograms
{
	Write-Host "***** Install Programs *****" -ForegroundColor Green
	# Install Chocolatey
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

	#Update Chocolatey
	choco upgrade chocolatey -y
	
	# Install Adobe Acrobat DC
	choco install adobereader -y

	# Install Google Chrome
	choco install googlechrome -y

	# Install 7zip
	choco install 7zip.install -y

	# Install Microsoft .NET 4.8
	choco install dotnetfx -y

	# Install Zoom Client
	choco install zoom -y
	
	#Install Microsoft 365 Business
	choco install office365business -y
	
	#Install Microsoft 364 ProPlus
	#choco install office365proplus
	
	#Install Microsoft Visual C++
	choco install vcredist140 -y
	
	#Update OneDrive
	choco upgrade onedrive -y
	
	#Install FireFox
	choco install firefox -y
	
	#Install NotePad++
	choco install notepadplusplus -y
	
	#Install AnyDesk
	choco install anydesk.install -y
	
	#Install Dotnet 3.5
	choco install dotnet3.5 -y
	
	#Install Donnet 4.5
	choco install dotnet4.5.2 -y
	
	#Install Speedtest
	choco install speedtest -y
	
	#Install powershell 7.2.5
	choco install powershell-core -y
	
	#Install Lenovo System Update
	choco install lenovo-thinkvantage-system-update -y
		
}

InstallPrograms