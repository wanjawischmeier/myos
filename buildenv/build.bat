@echo off

:: docker build buildenv -t myos-buildenv
docker run --rm -it -v %cd%:/root/env myos-buildenv

if %ERRORLEVEL% == 0 goto RunEmulator
if %ERRORLEVEL% neq 0 goto RunFailed
exit

:RunFailed
echo RunFailed: Trying to rebuild docker image

docker build buildenv -t myos-buildenv
if %ERRORLEVEL% == 0 goto RunEmulator
if %ERRORLEVEL% neq 0 goto BuildFailed
exit

:BuildFailed
docker
if %ERRORLEVEL% neq 0 echo BuildFailed: The docker command is not working, try restarting docker
echo Launching off old iso file...
goto RunEmulator
exit

:RunEmulator
echo Build succeeded

qemu-system-x86_64 -L "C:\Users\wanja\Documents\dev\lib\qemu" -cdrom dist/x86_64/kernel.iso
if %ERRORLEVEL% neq 0 echo EmulatorFailed: The qemu-system-x86_64 emulator crashed
exit /b 0