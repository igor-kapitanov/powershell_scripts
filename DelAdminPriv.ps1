function DelAdminPriv
{	
	Write-Host "***** Change an admin privilages *****" -ForegroundColor Green
	$Users = Get-LocalUser | select -Property name, enabled
	Get-LocalUser | select -Property name, enabled
	Write-Host "delete user from admins? Which one?" -ForegroundColor DarkYellow
	foreach ($user in $Users){
	Write-host  $user.Name  -ForegroundColor Cyan
	}
	$chosen = read-host "write the user name (empty to skip)"
		if($chosen){
			try{
				Remove-LocalGroupMember -Group "Administrators" -Member $chosen -ErrorAction Stop
			}catch{
				$errs = $_.Exception.Message
				while ($errs -ne $null){
				foreach ($err in $errs){
					Write-Host $err -ForegroundColor Red
					write-host Try again -ForegroundColor Cyan
						}try{
							$chosen01 = read-host "delete user from admins? Which one? (empty to skip)"
							if([string]::IsNullOrEmpty($chosen01)){
								Write-Host "-----skipped-----"
								$errs=$null
							}else{Remove-LocalGroupMember -Group "Administrators" -Member $chosen01 -ErrorAction Stop}
					}catch{
						$errs = $_.Exception.Message
					}
				}
			}
		}else{Write-Host "-----skipped-----" }
}

DelAdminPriv