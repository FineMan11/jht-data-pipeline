' ============================================================
' run_download.vbs
' Description : Silently runs download.bat without showing
'               a command prompt window
' Author      : FineMan11
' Scheduled   : Daily @ 02:00 hrs via Windows Task Scheduler
' ============================================================

' Replace YOUR_LOCAL_SAVE_PATH with your actual path to download.bat
CreateObject("Wscript.Shell").Run "cmd.exe /c ""YOUR_LOCAL_SAVE_PATH\download.bat""", 0, True
