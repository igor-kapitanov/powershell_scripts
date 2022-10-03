# powershell_scripts
1. LenovoUpdates – Installing Lenovo System update program, download and install drivers (include Bios).
2. WinUpdates – Installing updates for Windows.
3. InstallPrograms – Installing the most basic programs:
4.	PowerNetwork - Turn off power management for network cards (Wi-Fi and ethernet)
5.	UnpinApp – unpin programs from taskbar
6.	RegChange – delete “Task View Button”, “Cortana” and change “Search” from box to icon.
7.	StartUnpin – unpin programs from the start menu
8.	RemoveMcAfee – remove windows pre-install programs, download, and run the tool for delete pre-install McAfee (you’ll need to click “Next” a few times and type the capture). Unfortunately, I didn’t find the solution for auto-    deleting McAfee but I’m working on it. 
9.	CreateUsers – create our admin users with our general passwords and add them to the “admin” group.
10.	DelAdminPriv – you got the list of users from the “admin” group and the script asks you which one of them you want to delete from there.

All these scripts includes “ConfComputers”
