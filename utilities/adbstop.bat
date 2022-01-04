@echo off

REM changes the directory
cd /D "%~dp0\..\files"

adb disconnect
adb kill-server

echo Done.
pause