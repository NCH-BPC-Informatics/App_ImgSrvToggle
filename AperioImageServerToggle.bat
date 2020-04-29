@echo off
@echo Please make a selection:
@echo 1) Stop ImageServer
@echo 2) Start ImageServer

set /p choice=""

if "%choice%"=="1" (
	@echo Stopping Image Server
	@echo %USERNAME% > "\\crii.org\shares\Research\RESBPC_ImgStaging\FlagFiles\ImageServerStop.flag"
) else if "%choice%"=="2" (
	@echo Starting Image Server
	@echo %USERNAME% > "\\crii.org\shares\Research\RESBPC_ImgStaging\FlagFiles\ImageServerStart.flag"
) else (
	@echo Invalid choice: %choice%
)

PAUSE