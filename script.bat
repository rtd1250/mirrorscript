@echo off

REM Change to working directory
cd /D "%~dp0\files"

REM Set current version
set /p vernow=<version.txt

REM By default, we assume that this is not our first launch.
set firstLaunch=0

echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------


echo.
echo Checking for updates...
curl --silent -o version2.txt https://raw.githubusercontent.com/rtd1250/mirrorscript/main/files/version.txt
if exist version2.txt (
  set /p vernew=<version2.txt
  goto compare
) else (
  echo.
  echo Updates can't be checked. Please check your internet connection.
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

if exist scrcpy-win64-v1.23.zip (
  echo scrcpy already downloaded, moving on.
) else (
  REM If scrcpy is not downloaded, chances are that this is our first launch
  set firstLaunch=1
  echo Downloading scrcpy...
  curl -L -o scrcpy-win64-v1.23.zip https://github.com/Genymobile/scrcpy/releases/download/v1.23/scrcpy-win64-v1.23.zip
  echo Unpacking scrcpy...
  tar -xf scrcpy-win64-v1.23.zip
)

if exist sndcpy-v1.1.zip (
  echo sndcpy already downloaded, moving on.
) else (
  echo Downloading sndcpy...
  curl -L -o sndcpy-v1.1.zip https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-v1.1.zip
  echo Unpacking sndcpy...
  tar -xf sndcpy-v1.1.zip
)

echo.
echo Some checks...

REM Kill processes associated with scrcpy and sndcpy
tasklist /fi "ImageName eq scrcpy.exe" 2>NUL | find "scrcpy.exe">NUL
if %ERRORLEVEL%==0 (
  taskkill /IM scrcpy.exe
  echo Stopped scrcpy
)
tasklist /fi "ImageName eq vlc.exe" 2>NUL | find "vlc.exe">NUL
if %ERRORLEVEL%==0 (
  taskkill /F /IM vlc.exe
  echo Stopped VLC
)
tasklist /fi "ImageName eq adb.exe" 2>NUL | find "adb.exe">NUL
if %ERRORLEVEL%==0 (
  adb disconnect
  adb kill-server
  echo Stopped ADB
)

REM Check if VLC is installed
set VLC="C:\Program Files\VideoLAN\VLC\vlc.exe"
if exist %VLC% ( goto main )

cls
color 1f
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo Warning - You do not seem to have VLC Media Player installed.
echo It's required for sound playback.
echo If you don't want to use sound capture, feel free to skip this message.
echo Do you want to download it?
echo.
set /p choicev="1 for Yes, 2 for Skip: "
if %choicev%==1 ( start "" https://www.videolan.org/vlc/ )


:main
adb start-server
cls
color 1f
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
if %firstLaunch%==1 (
  echo Welcome!
  echo If you are using this tool for the first time, make sure to:
  echo 1. Unlock your phone
  echo 2. Connect it using USB
  echo 3. Accept the pop-up on the phone with "Remember this PC" ticked
  echo 4. Press any key to continue
) else (
  echo Plug in your phone now and press any key to continue.
)
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
echo 2. Network
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
if %sound%==2 ( continue ) else ( goto wifi )

cls
echo -------------------------------
echo Screen mirroring script
echo %vernow%
echo -------------------------------
echo.
echo After you see the device's screen, return here to enable audio capture.
echo.
pause

:wifi
cls
echo Launching scrcpy!
if [%res%] ==  [] (
  start scrcpy --tcpip
) else (
  start scrcpy --tcpip -m %res%
)

if %sound%==2 (
  echo.
  echo Unplug USB, and press any key for sound capture.
  pause
  color 0f
  echo Launching sndcpy!
  start sndcpy.bat
)
goto end

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
goto end

:end
exit
