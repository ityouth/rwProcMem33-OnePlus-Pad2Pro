#ifndef KERNEL_COMPAT_H_
#define KERNEL_COMPAT_H_

#include <linux/version.h>

/* Linux 6.6+ 兼容性修复 */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(6,6,0)
    #ifndef __user
        #define __user
    #endif
    
    /* Android 15 内核兼容性 */
    #ifndef ANDROID_VERSION
        #define ANDROID_VERSION 150000
    #endif
    
    /* 确保旧的API函数可用 */
    #ifndef copy_from_user
        #define copy_from_user(to, from, n) \
            _copy_from_user(to, from, n)
    #endif
    
    #ifndef copy_to_user  
        #define copy_to_user(to, from, n) \
            _copy_to_user(to, from, n)
    #endif
#endif

/* ARM64 Android 特定修复 */
#ifdef CONFIG_ARM64
    #ifndef __aarch64__
        #define __aarch64__
    #endif
#endif

/* 模块签名禁用 */
#ifdef CONFIG_MODULE_SIG
    #undef CONFIG_MODULE_SIG
#endif

#ifdef CONFIG_MODVERSIONS
    #undef CONFIG_MODVERSIONS  
#endif

/* 调试宏兼容性 */
#ifndef printk_debug
    #ifdef DEBUG
        #define printk_debug(fmt, ...) printk(fmt, ##__VA_ARGS__)
    #else
        #define printk_debug(fmt, ...) do {} while(0)
    #endif
#endif

#endif /* KERNEL_COMPAT_H_ */