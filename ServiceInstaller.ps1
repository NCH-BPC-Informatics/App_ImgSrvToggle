$nssm = (Get-Command "C:\NSSM\nssm-2.24\win64\nssm.exe").Source
$serviceName = 'AperioServiceFlagFileWatcher'
$powershellpath = (Get-Command powershell).Source
$scriptPath = 'C:\App_ImgSrvToggle\AperioServiceFlagFileWatcher.ps1'
$arguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $scriptPath

# Remove service if it already exists
if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
    If ((Get-Service $serviceName).Status -eq 'Running') {
        Stop-Service $serviceName
        Write-Host "Stopping $serviceName"
    }
	& $nssm remove $serviceName confirm
} 

$username = 'HOSPITAL\SA_BPCImageScanning'
$password = Read-Host "Enter the password for $username" -AsSecureString
$user = New-Object PSCredential $username,$password
$passwordRaw = $user.GetNetworkCredential().Password

& $nssm install $serviceName $powershellpath $arguments
& $nssm set $serviceName ObjectName $username $passwordRaw
& $nssm set $serviceName Description 'Watches for flag files to toggle Aperio services.'

& $nssm status $serviceName
Start-Service $serviceName
Get-Service $serviceName