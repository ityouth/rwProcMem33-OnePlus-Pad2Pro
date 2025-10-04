# OnePlus Pad 2 Pro rwProcMem内核模块 Makefile
# 适用于GitHub Actions自动编译

obj-m := rwProcMem_module.o

# 内核路径 - GitHub Actions中会自动设置
KERNEL_DIR ?= $(shell pwd)/../../kernel_source

# 编译器设置
ARCH := arm64
CROSS_COMPILE := aarch64-linux-android31-

# OnePlus Pad 2 Pro 特定编译标志
EXTRA_CFLAGS += -DANDROID_VERSION=150000
EXTRA_CFLAGS += -DPLATFORM_VERSION=15
EXTRA_CFLAGS += -D__ANDROID__
EXTRA_CFLAGS += -DCONFIG_ARM64
EXTRA_CFLAGS += -Wno-error
EXTRA_CFLAGS += -fno-pic
EXTRA_CFLAGS += -fno-pie

PWD := $(shell pwd)

all:
	@echo "编译 OnePlus Pad 2 Pro (OPD2413) 内核模块..."
	@echo "目标设备: OnePlus Pad 2 Pro"  
	@echo "内核版本: 6.6.57-android15"
	@echo "架构: ARM64"
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) \
		ARCH=$(ARCH) \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		CONFIG_MODULE_SIG=n \
		CONFIG_MODVERSIONS=n \
		CONFIG_MODULE_SRCVERSION_ALL=n \
		modules

clean:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) \
		ARCH=$(ARCH) \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		clean

install:
	@echo "安装模块到设备 (需要adb和root权限):"
	@echo "adb push rwProcMem_module.ko /data/local/tmp/"
	@echo "adb shell su -c \"insmod /data/local/tmp/rwProcMem_module.ko\""

.PHONY: all clean install