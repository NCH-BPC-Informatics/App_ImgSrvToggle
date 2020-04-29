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
    
    If ($fileName -eq 'ImageServerStop.flag') {
        $logline = "INFO - $(Get-Date); Stopping ImageServer service"
        Add-Content ("$watcherPath\log.txt") ($logline)
        write-host -foregroundcolor yellow $logline
        Stop-Service ApImageService
        Remove-Item -Path $flag_path
    } elseif ($fileName -eq 'ImageServerStart.flag') {
        $logline = "INFO - $(Get-Date); Starting ImageServer service"
        Add-Content ("$watcherPath\log.txt") ($logline)
        write-host -foregroundcolor yellow $logline
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