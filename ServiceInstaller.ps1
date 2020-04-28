$nssm = (Get-Command "C:\NSSM\nssm-2.24\win64\nssm.exe").Source
$serviceName = 'AperioServiceFlagFileWatcher'
$powershellpath = (Get-Command powershell).Source
$scriptPath = 'C:\App_ImgSrvToggle\AperioServiceFlagFileWatcher.ps1'
$arguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $scriptPath

$username = 'HOSPITAL\SA_BPCImageScanning'
$password = Read-Host "Enter the password for $username" -AsSecureString
$user = New-Object PSCredential $username,$password
$passwordRaw = $user.GetNetworkCredential().Password

& $nssm install $serviceName $powershellpath $arguments
& $nssm set $serviceName ObjectName $username $passwordRaw

& $nssm status $serviceName
Start-Service $serviceName
Get-Service $serviceName