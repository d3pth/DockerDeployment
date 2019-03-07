@echo off
@set env=%1
@set port=2375
@set name=%2

@if "%env%"=="test" @set target1=testserver1
@if "%env%"=="test" @set target2=testserver2
@if "%env%"=="test" goto logs
@if "%env%"=="uat" @set target1=uatserver1
@if "%env%"=="uat" @set target2=uatserver2
@if "%env%"=="uat" goto logs
@if "%env%"=="prod" @set target1=prodserver1
@if "%env%"=="prod" @set target2=prodserver2
@if "%env%"=="prod" goto logs

:logs
@if %target1%=="" @goto summary
@set go1=docker -H %target1%:%port% logs --tail 50 --follow --timestamps %name%
@start cmd /C "%go1%"
@if %target2%=="" @goto summary
@set go2=docker -H %target2%:%port% logs --tail 50 --follow --timestamps %name%
@start cmd /C "%go2%"

:summary
@echo Started container logs for %name% on separate windows for %target1% and %target2%
