

:GETTOTALBALANCES
rem
setlocal enabledelayedexpansion

%JQ_FILE% -r "to_entries[] | .value" %JSON_DATA_FILE% > %RESULT_FILE%

rem
for /f "delims=" %%A in (%RESULT_FILE%) do (
    set "LINE=%%A"
    set /a COUNT+=1
    if !COUNT! == 1 set "TRANSPARENTBALANCES=!LINE!"
    if !COUNT! == 2 set "PRIVATEBALANCES=!LINE!"
    if !COUNT! == 3 set "TOTALBALANCES=!LINE!"
)

rem 
echo ====================================================
echo         Transparent  ^| %TRANSPARENTBALANCES% BTCZ
echo         Private      ^| %PRIVATEBALANCES% BTCZ
echo.
echo         Total        ^| %TOTALBALANCES% BTCZ
echo ====================================================
del "%RESULT_FILE%"
endlocal
goto :eof