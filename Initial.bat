@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ============================================
::  Initial.bat - запуск todo-менеджера на Rust
:: ============================================

set "SCRIPT=Initial.rs"
set "EXE=Initial.exe"

:: Проверяем наличие rustc
where rustc >nul 2>&1
if errorlevel 1 (
    echo [ОШИБКА] Rust не установлен или не добавлен в PATH.
    echo Скачай с https://rustup.rs и перезапусти терминал.
    pause
    exit /b 1
)

:: Если нет .rs файла
if not exist "%SCRIPT%" (
    echo [ОШИБКА] Файл %SCRIPT% не найден в текущей папке.
    pause
    exit /b 1
)

:: Компилируем только если .exe нет или .rs новее
if not exist "%EXE%" (
    echo Компилирую %SCRIPT%...
    rustc "%SCRIPT%" -o "%EXE%"
    if errorlevel 1 (
        echo [ОШИБКА] Компиляция не удалась.
        pause
        exit /b 1
    )
    echo Готово.
) else (
    for %%A in ("%SCRIPT%") do set "RS_TIME=%%~tA"
    for %%A in ("%EXE%") do set "EXE_TIME=%%~tA"
    if "!RS_TIME!" GTR "!EXE_TIME!" (
        echo Исходник обновлён. Перекомпилирую...
        rustc "%SCRIPT%" -o "%EXE%"
        if errorlevel 1 (
            echo [ОШИБКА] Компиляция не удалась.
            pause
            exit /b 1
        )
    )
)

:: Передаём все аргументы в программу
if "%~1"=="" (
    "%EXE%"
) else (
    "%EXE%" %*
)

endlocal
