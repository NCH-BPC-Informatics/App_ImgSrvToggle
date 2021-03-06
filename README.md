# App_ImgSrvToggle

This repo contains the code to create a flag file watcher on DSR. The watcher toggles Aperio services based on the type of flag.

## Installation
1. Install [NSSM](https://nssm.cc/to) `C:\NSSM`
1. Clone this repo to `C:\App_ImgSrvToggle`
1. Run `ServiceInstaller.ps1` in an elevated PowerShell window to create a Windows service to watch for flags

## Components
 - `AperioImageServerToggle.bat` the client piece that creates flag files
 - `AperioServiceFlagFileWatcher.ps1` a watcher script to watch for the flag files
 - `ServiceInstaller.ps1` a script that creates a Windows Service of the file watcher

## Helpful Commands
During troubleshooting you may need to run the service as both:
1. The service account, since it can see research shares but you cannot
1. Elevated powershell, to manage services.
```
Start-Process powershell.exe -Credential "HOSPITAL\SA_BPCImageScanning" -ArgumentList "Start-Process powershell.exe -Verb runAs"
```