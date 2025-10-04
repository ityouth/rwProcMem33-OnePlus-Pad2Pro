#!/bin/bash
# 快速状态检查脚本

clear
echo "=================================="
echo "🔍 GitHub Actions 快速状态检查"
echo "=================================="
echo ""

# 基本信息
REPO="ityouth/rwProcMem33-OnePlus-Pad2Pro"
ACTIONS_URL="https://github.com/$REPO/actions"

echo "📍 项目: $REPO"
echo "🎯 目标: OnePlus Pad 2 Pro (OPD2413)"
echo ""

# 检查Git状态
if [ -d .git ]; then
    echo "📋 最新提交:"
    git log --oneline -2
    echo ""
    
    # 检查同步状态
    echo "🔄 检查同步状态..."
    git fetch origin >/dev/null 2>&1
    
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse origin/main 2>/dev/null)
    
    if [ "$LOCAL" = "$REMOTE" ]; then
        echo "✅ 本地与远程已同步"
    else
        echo "⚠️  本地与远程不同步"
        echo "   本地: ${LOCAL:0:8}"
        echo "   远程: ${REMOTE:0:8}"
    fi
else
    echo "⚠️  不在Git仓库中"
fi

echo ""
echo "🌐 检查编译状态:"
echo "   访问: $ACTIONS_URL"
echo ""

echo "📖 状态指南:"
echo "   🟡 = 正在编译 (10-15分钟)"
echo "   🟢 = 成功 (可下载.ko文件)"  
echo "   🔴 = 失败 (需要修复)"
echo ""

echo "📥 成功后下载:"
echo "   1. 打开上面的链接"
echo "   2. 点击绿色✅的工作流"
echo "   3. 下载 'Artifacts' 中的文件"
echo ""

# 检查是否需要新编译
if command -v curl >/dev/null 2>&1; then
    echo "⚡ 快速操作:"
    echo "   [Enter] 打开GitHub Actions页面"
    echo "   [t] 触发新编译"
    echo "   [q] 退出"
    echo ""
    
    read -p "选择操作: " choice
    
    case $choice in
        "t"|"T")
            echo ""
            echo "🔄 触发新编译..."
            echo "# Build trigger $(date)" > "BUILD_TRIGGER_$(date +%s).txt"
            git add .
            git commit -m "Trigger build - $(date)"
            git push
            echo "✅ 编译已触发！"
            echo "🔗 查看: $ACTIONS_URL"
            ;;
        "q"|"Q")
            echo "👋 退出"
            exit 0
            ;;
        *)
            if command -v xdg-open >/dev/null 2>&1; then
                xdg-open "$ACTIONS_URL" 2>/dev/null
            elif command -v open >/dev/null 2>&1; then
                open "$ACTIONS_URL" 2>/dev/null
            else
                echo "请手动打开: $ACTIONS_URL"
            fi
            ;;
    esac
else
    echo "请访问 GitHub Actions 页面查看状态："
    echo "$ACTIONS_URL"
fi

echo ""