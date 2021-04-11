@echo off

REM changes the directory
cd /D "%~dp0\files"

REM setting the variables once doesn't work sometimes. no idea why
set vernow=""
set /p vernow=<version.txt

echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------


echo.
echo Checking for updates...
curl --silent -o version2.txt https://raw.githubusercontent.com/rtd1250/mirrorscript/main/files/version.txt
set vernew=""
set /p vernew=<version2.txt
if exist version.txt (
  goto compare
) else (
  echo.
  echo Updates can't be checked. Check your internet connection.
  pause
  goto adb
)

:compare
if %vernow% LSS %vernew% (
  echo.
  echo Current version: %vernow%
  echo New version: %vernew%
  echo.
  echo New version available. Download?
  echo 1 for yes, 2 for no.
) else (
  echo.
  echo Up to date.
  del version2.txt
  goto adb
)
set /p choiced="Type your choice: "
if %choiced%==1 (
  del version.txt
  rename version2.txt version.txt
  curl -o ..\script.bat https://raw.githubusercontent.com/rtd1250/mirrorscript/main/script.bat
  exit
) else (
  del version2.txt
)

:adb
echo.
echo some checks...
if exist adb.exe (
  adb disconnect
  adb kill-server
  taskkill /IM vlc.exe
  taskkill /IM scrcpy.exe
  taskkill /IM sndcpy.bat
)
echo.

if exist scrcpy-win64-v1.17.zip (
  echo scrcpy already downloaded, moving on.
) else (
  echo Downloading scrcpy...
  curl -L -o scrcpy-win64-v1.17.zip https://github.com/Genymobile/scrcpy/releases/download/v1.17/scrcpy-win64-v1.17.zip
  echo Unpacking scrcpy...
  tar -xf scrcpy-win64-v1.17.zip
)

if exist sndcpy-v1.0.zip (
  echo sndcpy already downloaded, moving on.
) else (
  echo Downloading sndcpy...
  curl -L -o sndcpy-v1.0.zip https://github.com/rom1v/sndcpy/releases/download/v1.0/sndcpy-v1.0.zip
  echo Unpacking sndcpy...
  tar -xf sndcpy-v1.0.zip
)
adb start-server

cls
color 1f
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo Plug in your phone now and press any key to continue.
echo.
pause

cls
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo 1. Screen mirroring
echo 2. Screen and sound mirroring
echo.
set /p sound="Type your choice here: "

cls
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo 1. USB
echo 2. Wi-Fi
echo.
set /p mode="Type your choice here: "

cls
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo Resolution to pass to scrcpy? (-m parameter)
echo Leave empty if unsure.
echo.
set /p res="Max size: "
if %mode%==1 goto usb

cls
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo Listing ADB IPs...
adb shell ip route | gawk "{print $9}"
echo.

echo You should see your phone's IP (typically starting with 192.xxx) above.
set /p IP=Type it in here: 
adb tcpip 5555
adb connect %IP%

cls
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo Disconnect the cable now and make sure the phone is unlocked.
echo.
pause

:usb
cls
color 0f
echo Launching scrcpy!
if [%res%] ==  [] (
  start scrcpy
) else (
  start scrcpy -m %res%
)

if %sound%==2 (
  echo Launching sndcpy!
  start sndcpy.bat
)
