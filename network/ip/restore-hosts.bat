@echo off
rem ### Restore HOSTS File ################
rem # Version 20120428-1 by Scott Garrett #
rem # Wintervenom [(at)] archlinux.us     #
rem #######################################
rem
rem ### WHAT THIS SCRIPT DOES ###
rem Restores your hosts file to Windows default.
rem
rem ### HOW TO USE THIS SCRIPT ###
rem - (GitHub):  Right-click 'Raw' at the top-
rem   right of this this page.
rem - Save the script to your desktop.
rem - If you use Windows Vista or 7:
rem   Right-click and 'Run as Administrator.'
rem - If you use Windows XP:
rem   Just launch the script.
rem
rem #######################################

rem ###############
rem ### Globals ###
rem ###############

rem Path to the HOSTS file.
set hosts=%SYSTEMROOT%\system32\drivers\etc\HOSTS



rem ############
rem ### Main ###
rem ############

echo Restore HOSTS File
echo Version 20120428-1 by Scott Garrett
echo Wintervenom [(at)] archlinux.us
echo.

rem Can't modify the HOSTS file without the script being executed as
rem Administrator.  Let's check for that.
>nul 2>&1 cacls %SYSTEMROOT%\system32\config\system
if not errorlevel 0 (
    echo You will need to execute this script as administrator to use it.
    pause
    exit 1
)

if exist %hosts% (
    rem Back up the original HOSTS file, just in case.
    echo Backing up current HOSTS file to "HOSTS.old"...
    copy /y %hosts% %hosts%.old || (
        echo Could not back up your HOSTS file - error code %ERRORLEVEL%.
        echo Press [Enter] if you like to try to edit the entries, anyway, or
        echo Press [Control]-[C] to bail out of here.
        pause
    )
    rem Delete the old HOSTS file.
    echo.
    del /f /q %hosts%
)

rem Make a new HOSTS.
echo Creating a new hosts file.
echo 127.0.0.1 localhost > %hosts%
echo ::1 localhost >> %hosts%

rem Clear the DNS resolver cache to make sure changes take effect now.
echo.
echo Clearing DNS cache...
ipconfig /flushdns

rem We're done here.
echo.
echo HOSTS file restored to default.
pause
