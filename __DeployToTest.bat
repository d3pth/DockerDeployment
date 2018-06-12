@REM environment=development/test/preprod/prod
@REM %1 = environment
@REM %2 = name
@REM %3 = port=%3
@REM %4 = target1
@REM %5 = target2 OPTIONAL
@CALL _dockerdeploy.bat test defaultdockerimage 5005 server1 server2