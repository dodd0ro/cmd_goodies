@ECHO OFF
setlocal EnableDelayedExpansion

:loop
REM # print tree
echo %CD%
set /A n = 1
FOR /D %%f IN (*) DO (
    set flist[!n!]=%%f
    ECHO [!n!] %%f
    set /A n+=1
)

REM # user input
set fid=
set /p fid=">> "
echo.
IF "%fid%"=="" GOTO :end
IF "%fid: =%"=="" GOTO :end

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
echo %CD%| clip




