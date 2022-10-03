function CreateUsers
{
    Write-Host "***** Create admin users *****" -ForegroundColor Green
	#Create CITadmin user
	$user1 = "CITadmin"
	$fname1 = "CITadmin"
    $password1 = ConvertTo-SecureString "Pft,bcm2" -AsPlainText -Force
    New-LocalUser $user1 -Password $password1 -FullName $fname1 -Description "CIT admin user"
    Set-LocalUser $user1 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
    Add-LocalGroupMember -Group "Administrators" -Member $user1 -ErrorAction stop
	
    #Create Install user
	$user2 = "Install"
	$fname2 = "Install"
    $password2 = ConvertTo-SecureString "CloudIT1!" -AsPlainText -Force
    New-LocalUser $user2 -Password $password2 -FullName $fname2 -Description "second CIT admin user"
    Set-LocalUser $user2 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
    Add-LocalGroupMember -Group "Administrators" -Member $user2 -ErrorAction stop
}