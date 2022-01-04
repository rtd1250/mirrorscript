# mirrorscript
A very simple batch script for Android screen mirroring using [scrcpy](https://github.com/Genymobile/scrcpy) and [sndcpy](https://github.com/rom1v/sndcpy) under Windows.\
Downloads both projects and allows for simultaneous video and audio mirroring.

## Usage
The script assumes you have already turned on USB Debugging on your device.
If you don't have it enabled, follow the first section of this tutorial:
https://developer.android.com/studio/debug/dev-options#enable

To start, open the file "script.bat".
*Windows may complain that the app developer isn't verified, in that case you can click more info and accept.*


## Issues
 - adb keeps on running even after the screenshare ends. If you want to stop adb (allowing to delete the "files/" folder for example), run adbstop from the "utilities" folder.
 - If you're using USB Debugging for the first time ever, scrcpy might crash before you can accept the pop-up on your phone. In that case, tick the "Remember" option, accept the pop-up on your phone, and try again.
