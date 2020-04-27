<####

# Call NSSM from Powershell prompt to install start/stop script as service
$nssm = (Get-Command "C:\NSSM\nssm-2.24\win64\nssm.exe").Source
$serviceName = 'ImgSrvControl'
$powershellpath = (Get-Command powershell).Source
$scriptPath = 'C:\ImgSrvControl\ImgSrvStartStop.ps1'
$arguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $scriptPath
& $nssm install $serviceName $powershellpath $arguments
& $nssm status $serviceName
Start-Service $serviceName
Get-Service $serviceName

#Remove-Service -Name "ImgSrvControl"

####>

$watcher = New-Object System.IO.FileSystemWatcher
#$watcher.Path = "\\crii.org\shares\Research\RESBPC_Digital_Imaging_Core\Flag Files"
$watcher.Path = "C:\ImgSrvControl\FlagFiles"
$watcher.Filter = "*.flag"
$watcher.EnableRaisingEvents = $true  

$action = { 
    $flag_path = $Event.SourceEventArgs.FullPath
    $logline = "$(Get-Date); Found flag file $($Event.SourceEventArgs.ChangeType): $flag_path; Contents: $(Get-Content -Path $flag_path)"
       #Add-Content ("\\crii.org\shares\Research\RESBPC_Digital_Imaging_Core\Flag Files\log.txt") ($logline)
        Add-Content ("C:\ImgSrvControl\log.txt") ($logline)
    #
    # DO STUFF HERE (case/switch to decide and act; e.g stop service)
      # If (Test-Path -LiteralPath C:\ImgSrvControl\FlagFiles\stop.flag -PathType Leaf) {
	    If (Test-Path -LiteralPath 	\\crii.org\shares\Research\RESBPC_Digital_Imaging_Core\Aperio\ImageServer\StartStopControl\stop.flag -PathType Leaf) {
            write-host -foregroundcolor yellow "Stopping ImageServer service"
            Stop-Service ApImageService

            write-host -foregroundcolor cyan "Sending Email notification - stopping ImageServer"
	
        # EMAIL NOTIFICATION
          # Send Email to notify service is going down to allow Image Archive maintenance...
            [string[]]$EmailFrom = "BPCInformatics@NationwideChildrens.org"
            [string[]]$EmailTo = "<William.Beyer@NationwideChildrens.org>"
          # [string[]]$EmailTo = "<William.Beyer@NationwideChildrens.org, Jason.Weis@NationwideChildrens.org>"
          # [string[]]$EmailTo = "<VMWorkingGroup@NationwideChildrens.org>,<William.Beyer@NationwideChildrens.org>"
            $Subject = "R1DWBPCIMGDSR01 MAINT: Stopping ImageServer on development DSR..." 
            $Body = "NOTICE!  Stopping Aperio ImageServer on imaging development DSR R1DWBPCIMGDSR01 following maintenance of Image Archive.

            Thanks,
            BPC-Informatics
            "
            $SMTPServer = "res2k3ms01.crii.org"
            $SMTPClient = New-Object Net.Mail.SMTPClient($SMTPServer) 
            $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
     #  } elseif (Test-Path -LiteralPath C:\ImgSrvControl\FlagFiles\start.flag -PathType Leaf) {
		} elseif (Test-Path -LiteralPath 	\\crii.org\shares\Research\RESBPC_Digital_Imaging_Core\Aperio\ImageServer\StartStopControl\start.flag -PathType Leaf) {
            write-host -foregroundcolor green "Starting ImageServer service"
            Start-Service ApImageService
			
            write-host -foregroundcolor cyan "Sending Email notification - starting ImageServer"
	
          # EMAIL NOTIFICATION
          # Send Email to notify service is starting up again after Image Archive maintenance...
            [string[]]$EmailFrom = "BPCInformatics@NationwideChildrens.org"
            [string[]]$EmailTo = "<William.Beyer@NationwideChildrens.org>"
          # [string[]]$EmailTo = "<William.Beyer@NationwideChildrens.org, Jason.Weis@NationwideChildrens.org>"
          # [string[]]$EmailTo = "<VMWorkingGroup@NationwideChildrens.org>,<William.Beyer@NationwideChildrens.org>"
            $Subject = "R1DWBPCIMGDSR01 MAINT: Starting ImageServer on development DSR..." 
            $Body = "NOTICE!  Starting Aperio ImageServer on imaging development DSR R1DWBPCIMGDSR01 following maintenance of Image Archive.

            Thanks,
            BPC-Informatics
            "
            $SMTPServer = "res2k3ms01.crii.org"
            $SMTPClient = New-Object Net.Mail.SMTPClient($SMTPServer) 
            $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)

        }
        else {
            write-host -foregroundcolor yellow "No flag file found"
        }
    
  # Remove-Item -Path $flag_path
	Remove-Item -Path C:\ImgSrvControl\FlagFiles\*.*
}
Get-Service ApImageService
Register-ObjectEvent $watcher "Created" -Action $action
Write-Output "Listening for '$($watcher.Filter)' in '$($watcher.Path)'..."
while ($true) {sleep 3}