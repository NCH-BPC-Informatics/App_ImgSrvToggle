$watcherPath = "\\crii.org\shares\Research\RESBPC_ImgStaging\FlagFiles"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watcherPath
$watcher.Filter = "*.flag"
$watcher.EnableRaisingEvents = $true  

$action = { 
    $flag_path = $Event.SourceEventArgs.FullPath
    $userRequested = $(Get-Content -Path $flag_path)
    $logline = "INFO - $(Get-Date); Found flag file $($Event.SourceEventArgs.ChangeType): $flag_path; Contents: $userRequested"
    Add-Content ("$watcherPath\log.txt") ($logline)

	$fileName = Split-Path -Path $flag_path -Leaf
	
    If ($fileName == 'ImageServerStop.flag') {
        write-host -foregroundcolor yellow "Stopping ImageServer service"
        Stop-Service ApImageService
		Remove-Item -Path $flag_path
    } elseif ($fileName == 'ImageServerStart.flag')) {
        write-host -foregroundcolor green "Starting ImageServer service"
        Start-Service ApImageService
		Remove-Item -Path $flag_path
    } else {
		$logline = "ERROR - $(Get-Date); Unknown flag file $fileName"
		Add-Content ("$watcherPath\log.txt") ($logline)
        write-host -foregroundcolor yellow $logline
    }
}

Get-Service ApImageService
Register-ObjectEvent $watcher "Created" -Action $action
Write-Output "Listening for '$($watcher.Filter)' in '$($watcher.Path)'..."
while ($true) {sleep 3}