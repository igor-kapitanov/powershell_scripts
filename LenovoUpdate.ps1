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

LenovoUpdates