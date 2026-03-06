@echo off
chcp 65001 >nul
setlocal

set "SCRIPT_DIR=%~dp0"
set "PUSH_SCRIPT=%SCRIPT_DIR%auto_push_windows.bat"
set "TASK_NAME=LongmenAutoPush"

echo === 龙门计划 自动上传 - 安装程序 ===
echo.

:: 检查 git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：未检测到 Git
    echo 请先安装 Git：https://git-scm.com/download/win
    pause
    exit /b 1
)

:: 删除旧任务（如有）
schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1

:: 创建每天 23:00 运行的计划任务
schtasks /create ^
    /tn "%TASK_NAME%" ^
    /tr "\"%PUSH_SCRIPT%\"" ^
    /sc daily ^
    /st 23:00 ^
    /f

if %errorlevel% equ 0 (
    echo.
    echo 安装完成！
    echo.
    echo   自动上传时间：每天 23:00
    echo   日志位置：%SCRIPT_DIR%.longmen\auto_push.log
    echo.
    echo 如需立即测试上传，双击运行 auto_push_windows.bat
) else (
    echo.
    echo 安装失败！请右键本文件，选择"以管理员身份运行"
)

pause
endlocal
