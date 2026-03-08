' ============================================================
' run_extract.vbs
' Description : Silently runs extract.bat without showing
'               a command prompt window
' Author      : FineMan11
' Scheduled   : Daily @ 23:59 hrs via Windows Task Scheduler
' ============================================================

CreateObject("Wscript.Shell").Run "cmd.exe /c D:\JHT_Data\extract.bat", 0, True
