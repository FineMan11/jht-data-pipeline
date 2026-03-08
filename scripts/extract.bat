@echo off
:: ============================================================
:: download.bat
:: Description : Downloads daily JHT production CSV files from
::               FTP server to local Office PC folder
:: Author      : FineMan11
:: Scheduled   : Daily @ 02:00 via Windows Task Scheduler
:: ============================================================

:: Get today's date in YYYYMMDD format
for /f "tokens=2 delims==" %%G in ('wmic os get LocalDateTime /value') do set DT=%%G
set DATE_TODAY=%DT:~0,4%%DT:~4,2%%DT:~6,2%

:: ── FTP Configuration ──────────────────────────────────────
:: Replace these with your actual FTP server details
set FTP_SERVER=YOUR_FTP_SERVER_IP
set FTP_USER=YOUR_FTP_USERNAME
set FTP_PASS=YOUR_FTP_PASSWORD
set FTP_FOLDER=/MAINT/WW_JAM/DATA_EXTRACTION
:: ───────────────────────────────────────────────────────────

:: ── Local Save Path ─────────────────────────────────────────
:: Replace this with your actual local destination folder
set SAVE_PATH=YOUR_LOCAL_SAVE_PATH
:: Example: set SAVE_PATH=C:\JHT_Data\Downloads
:: ───────────────────────────────────────────────────────────

echo ============================
echo Downloading JHT Data
echo Date : %DATE_TODAY%
echo Time : %time%
echo ============================

:: Build FTP download script
echo open %FTP_SERVER%> "%SAVE_PATH%\ftp_download.txt"
echo %FTP_USER%>> "%SAVE_PATH%\ftp_download.txt"
echo %FTP_PASS%>> "%SAVE_PATH%\ftp_download.txt"
echo cd %FTP_FOLDER%>> "%SAVE_PATH%\ftp_download.txt"
echo lcd "%SAVE_PATH%">> "%SAVE_PATH%\ftp_download.txt"
echo prompt>> "%SAVE_PATH%\ftp_download.txt"
echo mget *.csv>> "%SAVE_PATH%\ftp_download.txt"
echo bye>> "%SAVE_PATH%\ftp_download.txt"

:: Execute FTP Download
echo Downloading files...
ftp -s:"%SAVE_PATH%\ftp_download.txt"

echo ============================
echo DONE! Files saved to %SAVE_PATH%
echo ============================

:: Log completion
echo %DATE_TODAY% %time% - Download Completed >> "%SAVE_PATH%\download_log.txt"
exit
