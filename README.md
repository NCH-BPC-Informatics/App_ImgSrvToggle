# App_ImgSrvToggle
PowerShell app to allow remote users capability to toggle Aperio ImageServer service

Stop or Start execution of Aperio ImageServer (IS) on DSR (R1PWBPCIMGDSR01).

IS ON renders labels and thumbnails in eSlide Manager, assists VM team with adding slide metadata, 
	but IS places lock on image files in storage share, blocking moves/edits
	
IS OFF removes locks on image files to allow VM team rename files, move files into their preferred organizational hierarchy

CMD: 'powershell' to start interpreter.
CMD: 'exit' to return.
Navigate to folder containing script
To execute as Powershell script, change extension to "ps1"
.\ImgSrvRemoteControl.ps1

Make sure Execution Policy on system is set to allow script execution !!
 i.e.  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine
