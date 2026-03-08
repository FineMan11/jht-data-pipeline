@echo off
:: ============================================================
:: extract.bat
:: Description : Extracts daily production data from JHT machine
::               SQL database and uploads CSV files to FTP server
:: Author      : FineMan11
:: Scheduled   : Daily @ 23:59 hrs via Windows Task Scheduler
:: ============================================================

:: Get today's date in YYYYMMDD format
for /f "tokens=2 delims==" %%G in ('wmic os get LocalDateTime /value') do set DT=%%G
set DATE_TODAY=%DT:~0,4%%DT:~4,2%%DT:~6,2%

:: Get machine hostname
for /f "tokens=*" %%a in ('hostname') do set MACHINE=%%a

:: ── FTP Configuration ──────────────────────────────────────
:: Replace these with your actual FTP server details
set FTP_SERVER=YOUR_FTP_SERVER_IP
set FTP_USER=YOUR_FTP_USERNAME
set FTP_PASS=YOUR_FTP_PASSWORD
set FTP_FOLDER=/MAINT/WW_JAM/DATA_EXTRACTION
:: ───────────────────────────────────────────────────────────

:: Create local folders if they don't exist
if not exist "D:\JHT_Data" mkdir "D:\JHT_Data"
if not exist "D:\JHT_Data\SPCHistory" mkdir "D:\JHT_Data\SPCHistory"
if not exist "D:\JHT_Data\History" mkdir "D:\JHT_Data\History"
if not exist "D:\JHT_Data\Log" mkdir "D:\JHT_Data\Log"

echo ============================
echo Machine : %MACHINE%
echo Date    : %DATE_TODAY%
echo Time    : %time%
echo ============================

:: Step 1 — Extract SPCHistory from SQL
echo [1/4] Extracting SPCHistory...
sqlcmd -S .\SQLEXPRESS -d PnPhDB -Q "SELECT * FROM SPCHistory WHERE DateCode >= CONVERT(varchar, GETDATE(), 112)" -s"," -W -o "D:\JHT_Data\SPCHistory\%MACHINE%_SPCHistory_%DATE_TODAY%.csv"
if %ERRORLEVEL% EQU 0 (echo SPCHistory OK!) else (echo SPCHistory FAILED!)

:: Step 2 — Extract History from SQL
echo [2/4] Extracting History...
sqlcmd -S .\SQLEXPRESS -d PnPhDB -Q "SELECT * FROM History WHERE DateTime >= CONVERT(varchar, GETDATE(), 112)" -s"," -W -o "D:\JHT_Data\History\%MACHINE%_History_%DATE_TODAY%.csv"
if %ERRORLEVEL% EQU 0 (echo History OK!) else (echo History FAILED!)

:: Step 3 — Build FTP script
echo [3/4] Preparing FTP Upload...
echo open %FTP_SERVER%> "D:\JHT_Data\ftp_script.txt"
echo %FTP_USER%>> "D:\JHT_Data\ftp_script.txt"
echo %FTP_PASS%>> "D:\JHT_Data\ftp_script.txt"
echo cd %FTP_FOLDER%>> "D:\JHT_Data\ftp_script.txt"
echo put "D:\JHT_Data\SPCHistory\%MACHINE%_SPCHistory_%DATE_TODAY%.csv">> "D:\JHT_Data\ftp_script.txt"
echo put "D:\JHT_Data\History\%MACHINE%_History_%DATE_TODAY%.csv">> "D:\JHT_Data\ftp_script.txt"
echo bye>> "D:\JHT_Data\ftp_script.txt"

:: Step 4 — Execute FTP Upload
echo [4/4] Uploading to FTP...
ftp -s:"D:\JHT_Data\ftp_script.txt"
if %ERRORLEVEL% EQU 0 (echo FTP Upload OK!) else (echo FTP Upload FAILED!)

echo ============================
echo DONE! %MACHINE% %DATE_TODAY%
echo ============================

:: Log completion
echo %DATE_TODAY% %time% - %MACHINE% - Completed >> "D:\JHT_Data\Log\log.txt"
exit
