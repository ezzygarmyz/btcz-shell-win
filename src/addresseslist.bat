

:ADDRESSESLIST

setlocal enabledelayedexpansion
set /a counter=1

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ================================================================================
echo                                  Addresses List
echo ================================================================================
echo.

rem
if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

rem
if "%ADDRESS_TYPE%"=="transparent" (
    start "" /B "%BITCOINZCLI_FILE%" getaddressesbyaccount "" > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%YELLOW_FG%"
) else if "%ADDRESS_TYPE%"=="private" (
    start "" /B "%BITCOINZCLI_FILE%" z_listaddresses > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%CYAN_FG%"
)

rem
timeout /t 1 /nobreak >nul

rem
for /f "tokens=* delims=" %%A in ('powershell -command "Get-Content %JSON_DATA_FILE% | ConvertFrom-Json | ForEach-Object { $_ }"') do (
    echo  [%CYAN_FG%!counter!%RESET%] ^| %ADDRESS_COLOR%%%A%RESET%
    set "address[!counter!]=%%A"
    set /a counter+=1
)

echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p "choice=| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

rem
set "choice=%choice: =%"

if "%choice%"=="0" (
    del "%JSON_DATA_FILE%"
    endlocal
    goto :eof
) else if not defined address[%choice%] (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto ADDRESSESLIST
)

set "SELECTED_ADDRESS=!address[%choice%]!"
goto MANAGEADDRESS



:MANAGEADDRESS
setlocal enabledelayedexpansion
cls

type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Manage Address %RESET% ^|
echo.
echo ================================================================================
echo  Selected Address : %ADDRESS_COLOR%%SELECTED_ADDRESS%%RESET%
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| Balance
echo  [%CYAN_FG%2%RESET%] ^| Show Private Key
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p "choice=| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    del "%JSON_DATA_FILE%"
    goto GETBALANCE
) else if "%choice%"=="2" (
    del "%JSON_DATA_FILE%"
    goto SHOWPRIVATEKEY
) else if "%choice%"=="0" (
    del "%JSON_DATA_FILE%"
    goto ADDRESSESLIST
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto MANAGEADDRESS
)



:GETBALANCE
setlocal enabledelayedexpansion
cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Manage Address %RESET% ^|
echo.
echo ================================================================================
echo  Selected Address : %ADDRESS_COLOR%%SELECTED_ADDRESS%%RESET%
echo ================================================================================
echo.

rem
start "" /B "%BITCOINZCLI_FILE%" z_getbalance "%SELECTED_ADDRESS%" 0 > "%JSON_DATA_FILE%"

timeout /t 1 /nobreak >nul

rem
for /f "usebackq tokens=*" %%i in ("%JSON_DATA_FILE%") do (
    set "BALANCE=%%i"
)

echo    Balance : %ADDRESS_COLOR%%BALANCE%%RESET% BTCZ
echo.

pause
endlocal
goto MANAGEADDRESS



:SHOWPRIVATEKEY
setlocal enabledelayedexpansion
cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Manage Address %RESET% ^|
echo.
echo ================================================================================
echo  Selected Address : %ADDRESS_COLOR%%SELECTED_ADDRESS%%RESET%
echo ================================================================================
echo.

rem
if "%ADDRESS_TYPE%"=="transparent" (
    start "" /B "%BITCOINZCLI_FILE%" dumpprivkey "%SELECTED_ADDRESS%" > "%JSON_DATA_FILE%"
) else if "%ADDRESS_TYPE%"=="private" (
    start "" /B "%BITCOINZCLI_FILE%" z_exportkey "%SELECTED_ADDRESS%" > "%JSON_DATA_FILE%"
)

timeout /t 1 /nobreak >nul

rem
for /f "usebackq tokens=*" %%i in ("%JSON_DATA_FILE%") do (
    set "ADDRESSPRIVATEKEY=%%i"
)

echo    Key : [%BLACK_FG%%BLACK_BG%%ADDRESSPRIVATEKEY%%RESET%]
echo.
echo  [%CYAN_FG%1%RESET%] ^| ^Copy Clipboard
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p "choice=| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    type "%JSON_DATA_FILE%" | clip
    echo.
    echo  %GREEN_FG%Private key copied to Clipboard !%RESET%
    timeout /t 2 /nobreak >nul
) else if "%choice%"=="0" (
    set "ADDRESSPRIVATEKEY="
    del "%JSON_DATA_FILE%"
    goto MANAGEADDRESS
)

set "ADDRESSPRIVATEKEY="
del "%JSON_DATA_FILE%"


goto MANAGEADDRESS