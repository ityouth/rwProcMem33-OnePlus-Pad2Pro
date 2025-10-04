#!/bin/bash
# OnePlus Pad 2 Pro 本地编译脚本
# Windows WSL2 环境下的编译解决方案

set -e

echo "==================================="
echo "OnePlus Pad 2 Pro 模块编译脚本"
echo "==================================="

# 检查环境
check_environment() {
    echo "检查编译环境..."
    
    # 检查是否在WSL中
    if grep -qi microsoft /proc/version; then
        echo "✓ 检测到WSL环境"
        export WSL_ENV=1
    else
        echo "! 建议使用WSL2环境进行编译"
    fi
    
    # 检查必要工具
    if ! command -v make &> /dev/null; then
        echo "✗ make 未安装，请运行: sudo apt install build-essential"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        echo "✗ git 未安装，请运行: sudo apt install git"
        exit 1
    fi
    
    echo "✓ 基本工具检查完成"
}

# 下载交叉编译工具
setup_toolchain() {
    echo "设置交叉编译工具链..."
    
    TOOLCHAIN_DIR="./toolchain"
    
    if [ ! -d "$TOOLCHAIN_DIR" ]; then
        echo "下载 ARM64 交叉编译工具..."
        
        # 方案1：使用系统包管理器
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y gcc-aarch64-linux-gnu
            export CROSS_COMPILE=aarch64-linux-gnu-
        else
            # 方案2：下载预编译工具链
            mkdir -p $TOOLCHAIN_DIR
            cd $TOOLCHAIN_DIR
            
            echo "下载预编译工具链..."
            wget -q https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz
            tar -xf gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz
            
            export PATH="$(pwd)/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin:$PATH"
            export CROSS_COMPILE=aarch64-linux-gnu-
            
            cd ..
        fi
    else
        echo "✓ 工具链已存在"
        export PATH="$(pwd)/$TOOLCHAIN_DIR/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin:$PATH"
        export CROSS_COMPILE=aarch64-linux-gnu-
    fi
    
    # 验证工具链
    if ${CROSS_COMPILE}gcc --version &> /dev/null; then
        echo "✓ 交叉编译工具链设置成功"
        ${CROSS_COMPILE}gcc --version | head -1
    else
        echo "✗ 交叉编译工具链设置失败"
        exit 1
    fi
}

# 下载内核源码
download_kernel() {
    echo "下载内核源码..."
    
    if [ ! -d "kernel_source" ]; then
        echo "克隆OnePlus官方内核源码..."
        
        # 尝试多个源
        if ! git clone --depth=1 https://github.com/OnePlusOSS/android_kernel_common_oneplus_sm8750.git kernel_source; then
            echo "主源失败，尝试备用源..."
            git clone --depth=1 https://github.com/LineageOS/android_kernel_oneplus_sm8750.git kernel_source || {
                echo "✗ 内核源码下载失败"
                echo "请手动下载内核源码到 kernel_source 目录"
                exit 1
            }
        fi
    else
        echo "✓ 内核源码已存在"
    fi
    
    cd kernel_source
    echo "内核信息:"
    echo "- 最新提交: $(git log --oneline -1)"
    echo "- 分支: $(git branch --show-current)"
    cd ..
}

# 准备内核编译环境
prepare_kernel() {
    echo "准备内核编译环境..."
    
    cd kernel_source
    
    export ARCH=arm64
    
    # 尝试不同的配置
    if [ -f "arch/arm64/configs/oneplus_defconfig" ]; then
        CONFIG_FILE="oneplus_defconfig"
    elif [ -f "arch/arm64/configs/gki_defconfig" ]; then
        CONFIG_FILE="gki_defconfig"
    else
        CONFIG_FILE="defconfig"
    fi
    
    echo "使用配置: $CONFIG_FILE"
    
    # 应用配置
    make ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE $CONFIG_FILE
    
    # 启用模块支持
    if [ -x scripts/config ]; then
        scripts/config --enable CONFIG_MODULES
        scripts/config --enable CONFIG_MODULE_UNLOAD
        scripts/config --disable CONFIG_MODVERSIONS
        scripts/config --disable CONFIG_MODULE_SIG
    fi
    
    # 准备模块编译环境
    make ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE modules_prepare || \
    make ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE prepare
    
    cd ..
    echo "✓ 内核环境准备完成"
}

# 编译模块
build_module() {
    echo "编译rwProcMem模块..."
    
    cd rwProcMem33Module/rwProcMem_module
    
    # 创建编译用Makefile
    cat > Makefile.build << 'EOF'
# 本地编译Makefile
KERNEL_SRC := $(PWD)/../../kernel_source

obj-m := rwProcMem_module.o

# OnePlus Pad 2 Pro 兼容性设置
EXTRA_CFLAGS += -DANDROID_VERSION=150000
EXTRA_CFLAGS += -DPLATFORM_VERSION=15
EXTRA_CFLAGS += -D__ANDROID__
EXTRA_CFLAGS += -DCONFIG_ARM64

# 禁用有问题的警告
EXTRA_CFLAGS += -Wno-error
EXTRA_CFLAGS += -Wno-implicit-function-declaration
EXTRA_CFLAGS += -Wno-incompatible-pointer-types
EXTRA_CFLAGS += -Wno-int-conversion

# 内核兼容性
EXTRA_CFLAGS += -fno-pic
EXTRA_CFLAGS += -fno-pie

all:
	@echo "编译目标: OnePlus Pad 2 Pro (OPD2413)"
	@echo "内核版本: $(shell cd $(KERNEL_SRC) && make kernelversion 2>/dev/null || echo 'unknown')"
	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) \
		ARCH=arm64 \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		CONFIG_MODULE_SIG=n \
		CONFIG_MODVERSIONS=n \
		V=1 \
		modules

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) \
		ARCH=arm64 \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		clean
EOF
    
    # 编译
    export ARCH=arm64
    make -f Makefile.build
    
    # 检查结果
    if [ -f rwProcMem_module.ko ]; then
        echo "✓ 编译成功！"
        echo "模块信息:"
        file rwProcMem_module.ko
        ls -lh rwProcMem_module.ko
        
        # 创建发布目录
        mkdir -p ../../release
        cp rwProcMem_module.ko ../../release/
        
        echo ""
        echo "================================="
        echo "编译完成！"
        echo "输出文件: release/rwProcMem_module.ko"
        echo "================================="
        
    else
        echo "✗ 编译失败"
        exit 1
    fi
    
    cd ../..
}

# 主函数
main() {
    echo "开始编译 OnePlus Pad 2 Pro 内核模块..."
    
    check_environment
    setup_toolchain
    download_kernel
    prepare_kernel
    build_module
    
    echo ""
    echo "🎉 所有步骤完成！"
    echo ""
    echo "安装说明:"
    echo "1. 连接OnePlus Pad 2 Pro并启用USB调试"
    echo "2. 运行: adb push release/rwProcMem_module.ko /data/local/tmp/"
    echo "3. 运行: adb shell su -c 'insmod /data/local/tmp/rwProcMem_module.ko'"
    echo "4. 验证: adb shell lsmod | grep rwProcMem"
}

# 运行主函数
main "$@"