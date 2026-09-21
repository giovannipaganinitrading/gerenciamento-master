@echo off
chcp 65001 >nul
echo ======================================================
echo    Instalando Gerenciamento Master no MetaTrader 5
echo ======================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "SOURCE_DIR=%SCRIPT_DIR%Gerenciamento Master"
if not exist "%SOURCE_DIR%" set "SOURCE_DIR=%SCRIPT_DIR%"

set "COUNT=0"
set "BASE_DIR=%APPDATA%\MetaQuotes\Terminal"

if not exist "%BASE_DIR%" (
    echo [ERRO] Pasta de dados do MetaTrader 5 nao encontrada em %BASE_DIR%.
    goto FIM
)

for /d %%D in ("%BASE_DIR%\*") do (
    if exist "%%D\MQL5\Experts" (
        if not exist "%%D\MQL5\Experts\Gerenciamento Master" mkdir "%%D\MQL5\Experts\Gerenciamento Master"
        copy /y "%SOURCE_DIR%\Gerenciamento Master.ex5" "%%D\MQL5\Experts\Gerenciamento Master\" >nul
        echo  [OK] Instalado com sucesso no terminal: %%~nxD
        set /a COUNT+=1
    )
)

echo.
if %COUNT% gtr 0 (
    echo [SUCESSO] RobÃ´ instalado em %COUNT% terminal(is) do MetaTrader 5!
    echo Agora abra ou reinicie seu MetaTrader 5 e confira no Navegador.
) else (
    echo [AVISO] Nenhuma pasta MQL5\Experts encontrada nos terminais.
)

:FIM
echo.
pause
