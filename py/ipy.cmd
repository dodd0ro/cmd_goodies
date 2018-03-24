@ECHO OFF
IF "%1"=="" ECHO error && GOTO :EOF

set file=%1.py
IF NOT EXIST %file% echo "Error: file %file% doesn't exist" && GOTO :EOF

REM find env ///////////////
IF defined VIRTUAL_ENV (
    CALL :rs
) ELSE (
    FOR /D %%f IN (*) DO (IF EXIST %%f\Scripts\activate set aenv=%%f\Scripts\activate && GOTO :br)
    :br
    IF NOT %aenv%=="NULL" (CALL %aenv%)
    CALL :rs
    CALL deactivate
)
GOTO :EOF

REM run script /////////////
:rs
    ipython %2 %file%
    GOTO :EOF

