function CreateUsers
{
    Write-Host "***** Create admin users *****" -ForegroundColor Green
	#Create "name" user
	$user1 = "type the user name"
	$fname1 = "type the first name"
    $password1 = ConvertTo-SecureString "type the password" -AsPlainText -Force
    New-LocalUser $user1 -Password $password1 -FullName $fname1 -Description "the first admin user"
    Set-LocalUser $user1 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
    Add-LocalGroupMember -Group "Administrators" -Member $user1 -ErrorAction stop
	
    #Create Install user
	$user2 = "type the user name"
	$fname2 = "type the first name"
    $password2 = ConvertTo-SecureString "type the password" -AsPlainText -Force
    New-LocalUser $user2 -Password $password2 -FullName $fname2 -Description "the second admin user"
    Set-LocalUser $user2 -AccountNeverExpires -PasswordNeverExpires $true -UserMayChangePassword $false
    Add-LocalGroupMember -Group "Administrators" -Member $user2 -ErrorAction stop
}
