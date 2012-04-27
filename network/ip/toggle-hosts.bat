@echo off
rem ### Toggle HOSTS File Entries #########
rem # Version 20120427-1 by Scott Garrett #
rem # Wintervenom [(at)] archlinux.us     #
rem #######################################

rem ###############
rem ### Globals ###
rem ###############

rem Path to the HOSTS file.
set hosts=%SYSTEMROOT%\system32\drivers\etc\HOSTS

rem Which IP should this script toggle the entries of?
rem This will be used as a regular expression, so the
rem octet delimiters must be escaped.
set ip=205.234.234.93

rem What domains should point to the IP defined above?
set tld=dreamviews.com
set domains=(%tld% www.%tld% irc.%tld% webchat.%tld%)



rem ############
rem ### Main ###
rem ############

echo Toggle HOSTS File Entries
echo Version 20120427-1 by Scott Garrett
echo Wintervenom [(at)] archlinux.us
echo.

rem Look for existing entries.  If they are found, assume the user is
rem running this script again to remove them.
findstr /b /m /l "%ip%" %hosts%
set add_entries=%ERRORLEVEL%

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

    echo.
    rem Remove existing entries pointing to the address in %IP%.
    rem We can't redirect to the same file that is being read, so we'll
    rem write to a different file...
    echo Getting rid of existing entries pointing to %ip%...
    findstr /b /v /l "%ip%" %hosts% > %hosts%.new
    rem ...then replace the old one.
    move /y %hosts%.new %hosts%
) ELSE (
    rem If, for some reason, the user doesn't have a HOSTS file, then we
    rem need to create one.
    echo For some reason, you do not have a HOSTS file.
    echo One will be created for you.
    echo 127.0.0.1 localhost > %hosts%
    echo ::1 localhost >> %hosts%
)

rem Append new entries for the domain listed in the %domains% array if
rem there were no entries previously found.
set action=removed
if %add_entries% EQU 0 goto the_end

echo.
set action=added
for %%h in %domains% do (
    echo %ip% %%h >> %hosts%
    echo Added entry:  %ip% %%h
)

:the_end
rem Clear the DNS resolver cache to make sure changes take effect now.
echo.
echo Clearing DNS cache...
ipconfig /flushdns

rem We're done here.
echo.
echo HOSTS file entries have been %action% for %ip%.
echo Run this script again to toggle.
pause
