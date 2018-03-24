@ECHO OFF

set config=%~dp0.%~n0_config
CALL :ea
IF defined VIRTUAL_ENV (
    set aenv=%VIRTUAL_ENV%
) ELSE (
    set aenv=
)

REM //////////////////////////////////////////////////////

REM # parse args

REM ## check if command
IF "%1"=="" python && GOTO :EOF
IF "%1"=="/e" CALL :tenv %2 && GOTO :EOF
IF "%1"=="/f" CALL :freeze %2 && GOTO :EOF
IF "%1"=="/ea" GOTO :tea

REM ## python agrs
set pa= 
:pargs
set "arg=%~1"
if not "%arg:-=%" == "%arg%" (
    set "pa=%pa% %arg%"
    shift
    GOTO :pargs
)

REM ## script name
set file=%1.py
shift

REM ## other args
set fa=
:fargs
set "arg=%~1"
IF "%arg%"=="" GOTO :fc
IF NOT "%arg:/=%" == "%arg%" GOTO :fc
set "fa=%fa% %1"
shift
GOTO :fargs

REM ## final command
:fc
IF "%1"=="/e" CALL :tenv %2

REM # run script
CALL :srun
GOTO :EOF

REM //////////////////////////////////////////////////////

REM activate env and run script
:srun
    IF NOT EXIST %file% (
        ECHO Error: file "%file%" doesn't exist
        GOTO :EOF
    )

    IF %eauto%==false (
        CALL :r
        GOTO :EOF
    )
    IF defined VIRTUAL_ENV (
        CALL :r
    ) ELSE (
        CALL :fenv
        CALL :aenv
        CALL :r
        CALL deactivate
    )
    GOTO :EOF

    :r  
        python %pa% %file% %fa%
        GOTO :EOF

REM find env (first)
:fenv
    if defined aenv GOTO :EOF
    FOR /D %%f IN (*) DO (
        IF EXIST %%f\Scripts\activate (
            CALL :setaenv %%f\Scripts\activate
            GOTO :EOF
        )
    )
    ECHO Error: can't find environment
    GOTO :EOF
    :setaenv
    set aenv=%1
    GOTO :EOF

REM toggle or crate env
:tenv
    REM toggle
    IF "%1"=="" (
        IF defined aenv (
            CALL deactivate
        ) ELSE (
            CALL :fenv
            CALL :aenv
        )
    REM create or choose
    ) ELSE (
        IF EXIST %1\Scripts\activate (
            set "aenv=%1\Scripts\activate"
            CALL :aenv
        ) ELSE (
            CALL :cenv %1
        )
    )
    GOTO :EOF

REM create environment
:cenv 
    ECHO Environment "%1" doesn't exist.
    CHOICE /M "Create one?"
    set ch=%errorlevel%
    IF %ch%==1 (
        virtualenv %1
    )

REM activate environment
:aenv
    CALL %aenv%
    GOTO :EOF

REM freeze requirements
:freeze
    IF NOT "%1"=="" (
        IF EXIST %1\Scripts\activate (
            set aenv=%1\Scripts\activate
            CALL :aenv
        ) ELSE (
            ECHO Error: environment "%1" doesn't exist
        )
    )
    IF NOT defined aenv (
        echo Error: no activate environment
        GOTO :EOF
    )
    CALL pip freeze > requirements.txt
    CALL deactivate
    ECHO freezed to requirements.txt
    GOTO :EOF

:ea
    IF NOT EXIST %config% (
        echo false>%config%
    )
    set /p eauto=<%config%
    GOTO :EOF

:tea
    IF %eauto%==false (
        set eauto=true
        echo environment auto search is ON
    ) ELSE (
        set eauto=false
        echo environment auto search is OFF
    )
    echo %eauto%>%config%
    GOTO :EOF