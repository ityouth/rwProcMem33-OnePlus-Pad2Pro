@echo off
chcp 65001 >nul
title OnePlus Pad 2 Pro - GitHub Actions 编译状态监控

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                OnePlus Pad 2 Pro 编译状态监控                 ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:MAIN_MENU
echo 🚀 选择操作:
echo.
echo [1] 检查最新编译状态
echo [2] 查看本地提交历史  
echo [3] 打开 GitHub Actions 页面
echo [4] 触发新的编译
echo [5] 使用本地编译 (WSL)
echo [6] 退出
echo.
set /p choice=请选择 (1-6): 

if "%choice%"=="1" goto CHECK_STATUS
if "%choice%"=="2" goto SHOW_COMMITS
if "%choice%"=="3" goto OPEN_GITHUB
if "%choice%"=="4" goto TRIGGER_BUILD
if "%choice%"=="5" goto LOCAL_BUILD
if "%choice%"=="6" goto EXIT
goto MAIN_MENU

:CHECK_STATUS
echo.
echo ═══════════════════════════════════════════════════════════════
echo 📊 检查编译状态
echo ═══════════════════════════════════════════════════════════════
echo.

cd /d "d:\www\git\rwProcMem33-OnePlus-Pad2Pro"

echo 📋 项目信息:
echo    仓库: ityouth/rwProcMem33-OnePlus-Pad2Pro
echo    设备: OnePlus Pad 2 Pro (OPD2413)
echo    目标: rwProcMem_module.ko
echo.

echo 📈 最新提交:
git log --oneline -3
echo.

echo 🔄 同步状态:
git fetch origin >nul 2>&1
for /f %%i in ('git rev-parse HEAD') do set LOCAL_COMMIT=%%i
for /f %%i in ('git rev-parse origin/main') do set REMOTE_COMMIT=%%i

if "%LOCAL_COMMIT%"=="%REMOTE_COMMIT%" (
    echo    ✅ 本地与远程已同步
) else (
    echo    ⚠️  本地与远程不同步
    echo    本地: %LOCAL_COMMIT:~0,8%
    echo    远程: %REMOTE_COMMIT:~0,8%
)
echo.

echo 🌐 GitHub Actions 页面:
echo    https://github.com/ityouth/rwProcMem33-OnePlus-Pad2Pro/actions
echo.

echo 📖 状态说明:
echo    🟡 黄色圆点 = 正在编译中 (约10-15分钟)
echo    🟢 绿色勾号 = 编译成功 (可下载.ko文件)
echo    🔴 红色 X   = 编译失败 (查看日志)
echo.

echo 📥 编译成功后:
echo    1. 点击成功的工作流
echo    2. 向下滚动到 "Artifacts" 部分  
echo    3. 下载 "rwProcMem33-module-xxxxx"
echo    4. 解压获得 rwProcMem_module.ko
echo.

pause
goto MAIN_MENU

:SHOW_COMMITS
echo.
echo ═══════════════════════════════════════════════════════════════
echo 📝 本地提交历史
echo ═══════════════════════════════════════════════════════════════
echo.

cd /d "d:\www\git\rwProcMem33-OnePlus-Pad2Pro"
git log --oneline --graph -10
echo.

pause
goto MAIN_MENU

:OPEN_GITHUB
echo.
echo ═══════════════════════════════════════════════════════════════
echo 🌐 打开 GitHub Actions 页面
echo ═══════════════════════════════════════════════════════════════
echo.

echo 正在打开浏览器...
start https://github.com/ityouth/rwProcMem33-OnePlus-Pad2Pro/actions
echo.
echo ✅ 已在浏览器中打开 Actions 页面
echo.

pause
goto MAIN_MENU

:TRIGGER_BUILD
echo.
echo ═══════════════════════════════════════════════════════════════
echo 🔄 触发新的编译
echo ═══════════════════════════════════════════════════════════════
echo.

cd /d "d:\www\git\rwProcMem33-OnePlus-Pad2Pro"

echo 创建触发文件...
echo # Build trigger %date% %time% > BUILD_TRIGGER_%random%.txt

echo 提交并推送...
git add .
git commit -m "Trigger new build - %date% %time%"
git push

echo.
echo ✅ 新的编译已触发！
echo 🔗 查看进度: https://github.com/ityouth/rwProcMem33-OnePlus-Pad2Pro/actions
echo ⏱️  预计时间: 10-15分钟
echo.

pause
goto MAIN_MENU

:LOCAL_BUILD
echo.
echo ═══════════════════════════════════════════════════════════════
echo 🔧 本地编译 (WSL)
echo ═══════════════════════════════════════════════════════════════
echo.

echo 检查WSL环境...
wsl --version >nul 2>&1
if errorlevel 1 (
    echo ❌ WSL 未安装或未启用
    echo 请先安装 WSL2: https://docs.microsoft.com/zh-cn/windows/wsl/install
    pause
    goto MAIN_MENU
)

echo ✅ WSL 环境可用
echo.

set /p confirm=确定要开始本地编译吗? (Y/N): 
if /i not "%confirm%"=="Y" goto MAIN_MENU

echo.
echo 🔄 开始本地编译...
echo.

cd /d "d:\www\git\rwProcMem33-OnePlus-Pad2Pro"

echo 在WSL中执行编译脚本...
wsl bash -c "chmod +x build_windows.bat && ./build_windows.bat"

if errorlevel 0 (
    echo.
    echo ✅ 本地编译完成！
    echo 📂 输出文件: release\rwProcMem_module.ko
) else (
    echo.
    echo ❌ 本地编译失败
    echo 建议使用 GitHub Actions 编译
)

echo.
pause
goto MAIN_MENU

:EXIT
echo.
echo 👋 再见！
timeout /t 2 >nul
exit

:ERROR
echo ❌ 发生错误，请重试
pause
goto MAIN_MENU