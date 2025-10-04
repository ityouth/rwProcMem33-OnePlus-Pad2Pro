# OnePlus Pad 2 Pro rwProcMem 内核模块

[![Build rwProcMem33 Module for OnePlus Pad 2 Pro](https://github.com/YOUR_USERNAME/rwProcMem33-OnePlus-Pad2Pro/actions/workflows/build-module.yml/badge.svg)](https://github.com/YOUR_USERNAME/rwProcMem33-OnePlus-Pad2Pro/actions/workflows/build-module.yml)

## 📱 设备信息

- **设备型号**: OnePlus Pad 2 Pro (OPD2413)
- **系统版本**: Android 15
- **内核版本**: 6.6.57-android15-8-g4dc61d72e02f-abogki415959920-4k  
- **处理器**: Qualcomm SM8750 (Snapdragon 8 Gen 4)
- **架构**: ARM64 (aarch64)

## 🎯 项目简介

这是一个专为OnePlus Pad 2 Pro设计的rwProcMem内核模块，用于进程内存读写操作。

### ✨ 特性
- ✅ 完全适配OnePlus Pad 2 Pro硬件
- ✅ 基于OnePlus官方SM8750内核源码编译
- ✅ 支持Android 15系统
- ✅ 自动化GitHub Actions编译
- ✅ 一键部署到设备

### 🔧 驱动接口列表
1. **驱动_打开进程**: OpenProcess
2. **驱动_读取进程内存**: ReadProcessMemory
3. **驱动_写入进程内存**: WriteProcessMemory
4. **驱动_关闭进程**: CloseHandle
5. **驱动_获取进程内存块列表**: VirtualQueryExFull（可选：显示全部内存、仅显示物理内存）
6. **驱动_获取进程PID列表**: GetPidList

## 🚀 快速开始

### 方法1: GitHub Actions自动编译 (推荐)

1. **Fork本仓库**
2. **推送代码触发Actions编译**
3. **等待约15分钟自动编译完成**  
4. **在Actions页面下载编译好的 `rwProcMem_module.ko`**

### 方法2: 手动触发编译

1. 点击仓库的 **Actions** 标签页
2. 选择 **Build rwProcMem33 Module for OnePlus Pad 2 Pro** 工作流
3. 点击 **Run workflow** 按钮
4. 等待编译完成并下载结果

## 📦 安装和使用

### 前提条件
- ✅ OnePlus Pad 2 Pro 已获得root权限
- ✅ 已开启USB调试
- ✅ 已安装adb工具

### 安装步骤

```bash
# 1. 连接设备
adb devices

# 2. 推送模块到设备
adb push rwProcMem_module.ko /data/local/tmp/

# 3. 加载内核模块 (需要root)
adb shell su -c "insmod /data/local/tmp/rwProcMem_module.ko"

# 4. 验证模块加载
adb shell lsmod | grep rwProcMem

# 5. 查看加载日志
adb shell dmesg | tail -20
```

### 卸载模块

```bash
# 卸载模块
adb shell su -c "rmmod rwProcMem_module"
```

## 🔧 开发信息

### 编译环境
- **操作系统**: Ubuntu 22.04 LTS (GitHub Actions)
- **编译器**: Android NDK r26c CLANG 17.0.2
- **内核源码**: OnePlus官方SM8750内核
- **目标架构**: ARM64

### 本地编译

```bash
# 进入模块目录
cd rwProcMem33Module/rwProcMem_module/

# 编译模块 (需要配置内核源码路径)
make

# 清理编译文件
make clean
```

## 📋 项目结构

```
├── .github/workflows/
│   └── build-module.yml          # GitHub Actions自动编译配置
├── rwProcMem33Module/
│   └── rwProcMem_module/
│       ├── rwProcMem_module.c    # 主模块源码
│       ├── rwProcMem_module.h    # 模块头文件
│       ├── Makefile              # 编译配置
│       ├── phy_mem.h             # 物理内存操作
│       ├── proc_maps.h           # 进程内存映射
│       └── *.h                   # 其他功能头文件
├── README.md                     # 本文件
└── COMPILATION_SUMMARY.md        # 详细编译指南
```

## 🎯 技术亮点

### 设备完美适配
- **100%匹配** OnePlus Pad 2 Pro 硬件规格
- **内核版本完全一致** - 6.6.57-android15
- **使用OnePlus官方内核源码** - 确保最佳兼容性

### 自动化编译流程
- **GitHub Actions** 自动下载OnePlus官方内核源码
- **Android NDK r26c** 专业编译工具链
- **零配置编译** - 推送代码即可自动编译

## ⚠️ 重要提醒

- **⚠️ 仅适用于OnePlus Pad 2 Pro (OPD2413)**
- **⚠️ 需要root权限才能加载内核模块**
- **⚠️ 使用内核模块可能影响系统稳定性**
- **⚠️ 建议在测试环境中使用**
- **⚠️ 使用前请备份重要数据**

## 🤝 贡献指南

欢迎提交Issue和Pull Request来改进这个项目！

### 贡献方式
1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/新功能`)
3. 提交更改 (`git commit -am '添加新功能'`)
4. 推送到分支 (`git push origin feature/新功能`)
5. 创建 Pull Request

## 📞 技术支持

- **Issues**: [提交问题](https://github.com/YOUR_USERNAME/rwProcMem33-OnePlus-Pad2Pro/issues)
- **Discussions**: [技术讨论](https://github.com/YOUR_USERNAME/rwProcMem33-OnePlus-Pad2Pro/discussions)

## 🔗 相关链接

- [OnePlus官方内核源码](https://github.com/OnePlusOSS/android_kernel_oneplus_sm8750)
- [Android NDK下载](https://developer.android.com/ndk/downloads)
- [详细编译指南](COMPILATION_SUMMARY.md)

## 📄 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

---

**⚡ 由GitHub Actions自动编译 | 🎯 专为OnePlus Pad 2 Pro优化 | 🚀 一键部署**