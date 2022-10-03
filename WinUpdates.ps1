function WinUpdates
{
	Write-Host "***** Update Windows *****" -ForegroundColor Green
	Install-Module PSWindowsUpdate -Force
	Get-WindowsUpdate -AcceptAll -IgnoreRebootRequired -Install #-AutoReboot
}

WinUpdates