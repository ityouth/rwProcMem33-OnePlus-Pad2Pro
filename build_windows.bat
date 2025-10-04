@echo off
chcp 65001
echo ===================================
echo OnePlus Pad 2 Pro 模块编译脚本
echo Windows 环境版本
echo ===================================

REM 检查WSL是否可用
wsl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ WSL 未安装或未启用
    echo 请先安装 WSL2 和 Ubuntu
    echo 参考: https://docs.microsoft.com/zh-cn/windows/wsl/install
    pause
    exit /b 1
)

echo ✓ WSL 环境检测成功

REM 检查Linux环境
echo 检查WSL中的Linux环境...
wsl bash -c "which make gcc git" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 正在安装必要的编译工具...
    wsl bash -c "sudo apt update && sudo apt install -y build-essential git bc bison flex libssl-dev libncurses5-dev curl gcc-aarch64-linux-gnu"
)

echo ✓ 编译环境准备完成

REM 转换路径为WSL格式
set "WSL_PATH=/mnt/d/www/git/rwProcMem33-OnePlus-Pad2Pro"

REM 在WSL中执行编译
echo 开始在WSL中编译...
wsl bash -c "cd %WSL_PATH% && chmod +x local_build.sh && ./local_build.sh"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ 编译完成！
    echo 输出文件位于: release\rwProcMem_module.ko
    echo.
    echo 📱 安装到设备:
    echo 1. adb push release\rwProcMem_module.ko /data/local/tmp/
    echo 2. adb shell su -c "insmod /data/local/tmp/rwProcMem_module.ko"
    echo 3. adb shell lsmod ^| findstr rwProcMem
    echo.
) else (
    echo ✗ 编译失败，请检查错误信息
)

pause