@ECHO OFF
@REM This Script is not meant to be runned by itself
SET target1=%4
SET target2=%5
SET name=%2
SET port=%3
SET environment=%1

@ECHO stop on %1 node 1 (%target1%)
for /f %%i in ('docker -H %target1%:2375 ps -a -q --filter="name=%name%"') do set id=%%i
docker -H %target1%:2375 stop %id%

IF "%target2%"=="" goto summary
@ECHO stop on %1 node 2 (%target2%)
for /f %%i in ('docker -H %target2%:2375 ps -a -q --filter="name=%name%"') do set id=%%i
docker -H %target2%:2375 stop %id%

:summary
docker -H %target1%:2375 ps
IF NOT "%target2%"=="" docker -H %target2%:2375 ps
timeout /T 30
exit