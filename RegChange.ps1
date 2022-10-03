function RegChange
{
	Write-Host "***** UnPin programs from TaskBar *****" -ForegroundColor Green
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 1
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0
	Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds -Name ShellFeedsTaskbarViewMode -Value 2
	Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5
}

RegChange