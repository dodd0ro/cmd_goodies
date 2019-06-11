@ECHO OFF
SETLOCAL EnableDelayedExpansion

:loop
REM # print tree
ECHO %CD%
set /A n = 1
ECHO [0] ..
FOR /D %%f IN (*) DO (
    set flist[!n!]=%%f
    ECHO [!n!] %%f
    set /A n+=1
)

REM # user input
set fid= 
set /p fid=">> "
ECHO.

IF "%fid%"=="" GOTO :end
IF "%fid: =%"=="" GOTO :end

set /a fnum=%fid%
IF NOT "%fid%"=="%fnum%" GOTO :loop

IF "%fid%"=="0" (
    set "f=.."
) ELSE (
    set f=!flist[%fid%]!
)

REM # loop end
cd %f%
GOTO :loop

REM # finaly
:end
ENDLOCAL & SET nd=%cd%
cd %nd%





