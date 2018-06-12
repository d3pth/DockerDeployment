@ECHO OFF
@REM This Script is not meant to be runned by itself, use Deploy<Environment>
SET target1=%4
SET target2=%5
SET name=%2
SET port=%3
SET environment=%1

@echo deploy to %1 node 1 (%target1%)
for /f %%i in ('docker -H %target1%:2375 ps -a -q --filter="name=%name%"') do set id=%%i
docker -H %target1%:2375 stop %id%

docker -H %target1%:2375 rm -f %name%
docker -H %target1%:2375 rmi -f %name%
docker -H %target1%:2375 build -t %name% .
timeout /T 1
docker -H %target1%:2375 run -d -p %port%:%port% --restart=always --mount source=DBVOL,target=/dbconfig -e "ASPNETCORE_ENVIRONMENT=%environment%" -e "COMPUTERNAME=%target1%" --name %name% %name%

IF "%target2%"=="" goto summary
@echo deploy to %1 node 2 (%target2%)
for /f %%i in ('docker -H %target2%:2375 ps -a -q --filter="name=%name%"') do set id=%%i
docker -H %target2%:2375 stop %id%

docker -H %target2%:2375 rm -f %name%
docker -H %target2%:2375 rmi -f %name%
docker -H %target2%:2375 build -t %name% .
timeout /T 1
docker -H %target2%:2375 run -d -p %port%:%port% --restart=always --mount source=DBVOL,target=/dbconfig -e "ASPNETCORE_ENVIRONMENT=%environment%" -e "COMPUTERNAME=%target2%" --name %name% %name%

:summary
docker -H %target1%:2375 ps
IF NOT "%target2%"=="" docker -H %target2%:2375 ps
timeout /T 30
exit