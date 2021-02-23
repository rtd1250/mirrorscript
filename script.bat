@echo off
echo -------------------------------
echo simple screen mirroring script
echo using scrcpy and sndcpy!
echo -------------------------------

echo Changing the directory...
cd /D "%~dp0\files"

echo some checks...
if exist adb.exe (
  adb disconnect
  adb kill-server
)

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
echo ........
echo Plug in your phone now and press any key to continue.
echo ........
pause
:choice
set /p mode=Type 1 for USB or 2 for WIFI: 
if %mode%==1 goto usb

echo ........
echo Listing ADB IPs...
adb shell ip route | gawk "{print $9}"
echo ........

echo You should see your phone's IP (typically starting with 192.xxx) above.
set /p IP=Type it in here: 
adb tcpip 5555
adb connect %IP%

echo ........
echo Disconnect the cable now and make sure the phone is unlocked.
echo ........
pause

:usb
echo Launching scrcpy!
start scrcpy -m 1600
echo Launching sndcpy!
start sndcpy.bat