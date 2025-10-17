#!/bin/bash

# 微信公众号RSS生成器 - 自动化设置脚本
# 一键配置GitHub仓库、自动化部署和本地定时任务

echo "🚀 微信公众号RSS生成器 - 自动化设置"
echo "================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查Git是否已安装
check_git() {
    if ! command -v git &> /dev/null; then
        echo -e "${RED}❌ Git未安装，请先安装Git${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Git已安装${NC}"
}

# 检查GitHub CLI是否安装（可选）
check_gh() {
    if command -v gh &> /dev/null; then
        echo -e "${GREEN}✅ GitHub CLI已安装${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  GitHub CLI未安装（可选）${NC}"
        return 1
    fi
}

# 初始化Git仓库
init_git() {
    if [ ! -d ".git" ]; then
        echo "📦 初始化Git仓库..."
        git init
        echo -e "${GREEN}✅ Git仓库初始化完成${NC}"
    else
        echo -e "${YELLOW}⚠️  Git仓库已存在${NC}"
    fi
}

# 配置GitHub仓库（如果安装了gh CLI）
setup_github_repo() {
    if check_gh; then
        echo "🔗 设置GitHub仓库..."

        # 获取用户输入
        read -p "请输入GitHub仓库名称 (默认: wechat-rss-feeds): " repo_name
        repo_name=${repo_name:-"wechat-rss-feeds"}

        read -p "是否创建私有仓库？(y/N): " private_repo
        if [[ $private_repo =~ ^[Yy]$ ]]; then
            private_flag="--private"
        else
            private_flag="--public"
        fi

        # 创建仓库
        if gh repo create "$repo_name" $private_flag --source=. --push; then
            echo -e "${GREEN}✅ GitHub仓库创建成功: $repo_name${NC}"

            # 更新脚本中的GitHub URL
            GITHUB_URL="https://$(gh api user --jq '.login').github.io/$repo_name"
            echo "📝 GitHub Pages URL: $GITHUB_URL"

            # 更新脚本配置
            sed -i.bak "s|https://your-username.github.io/wechat-rss-feeds|$GITHUB_URL|g" wechat-rss-manager-lark.sh

        else
            echo -e "${RED}❌ GitHub仓库创建失败${NC}"
            echo "请手动创建GitHub仓库并推送代码"
        fi
    else
        echo "请手动完成以下步骤："
        echo "1. 在GitHub上创建新仓库"
        echo "2. 添加远程仓库：git remote add origin https://github.com/username/repo.git"
        echo "3. 推送代码：git push -u origin main"
    fi
}

# 设置本地定时任务
setup_cron() {
    echo "⏰ 设置本地定时任务..."

    # 获取脚本绝对路径
    SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/wechat-rss-manager-lark.sh"

    # 创建cron任务
    CRON_JOB="0 2 * * * $SCRIPT_PATH generate-all"

    # 检查是否已存在相同的cron任务
    if crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
        echo -e "${YELLOW}⚠️  定时任务已存在${NC}"
    else
        # 添加新的cron任务
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo -e "${GREEN}✅ 定时任务设置成功（每日2点执行）${NC}"
    fi
}

# 配置飞书Webhook（可选）
setup_feishu() {
    echo "📱 配置飞书通知（可选）..."

    read -p "是否要配置飞书Webhook通知？(y/N): " setup_feishu
    if [[ $setup_feishu =~ ^[Yy]$ ]]; then
        read -p "请输入飞书Webhook URL: " webhook_url

        if [ ! -z "$webhook_url" ]; then
            # 更新脚本中的webhook配置
            sed -i.bak "s|FEISHU_WEBHOOK_URL=\"\"|FEISHU_WEBHOOK_URL=\"$webhook_url\"|g" wechat-rss-manager-lark.sh
            echo -e "${GREEN}✅ 飞书Webhook配置完成${NC}"
        else
            echo -e "${YELLOW}⚠️  Webhook URL为空，跳过配置${NC}"
        fi
    fi
}

# 生成初始RSS
generate_initial_rss() {
    echo "📡 生成初始RSS文件..."

    if [ -f "wechat-rss-manager-lark.sh" ]; then
        chmod +x wechat-rss-manager-lark.sh
        ./wechat-rss-manager-lark.sh generate-all
        echo -e "${GREEN}✅ RSS文件生成完成${NC}"
    else
        echo -e "${RED}❌ 管理脚本不存在${NC}"
    fi
}

# 显示使用说明
show_usage() {
    echo ""
    echo "🎉 设置完成！使用说明："
    echo "====================="
    echo ""
    echo "📋 基本命令："
    echo "  ./wechat-rss-manager-lark.sh list                    - 列出所有公众号"
    echo "  ./wechat-rss-manager-lark.sh generate-all            - 生成所有RSS"
    echo "  ./wechat-rss-manager-lark.sh add '名称' '描述' '分类' - 添加新公众号"
    echo ""
    echo "🔗 RSS链接格式："
    echo "  https://your-username.github.io/wechat-rss-feeds/rss/公众号名称.xml"
    echo ""
    echo "📝 下一步："
    echo "  1. 推送代码到GitHub仓库"
    echo "  2. 在GitHub仓库设置中启用GitHub Pages"
    echo "  3. 将RSS链接添加到NotebookLM"
    echo ""
}

# 主函数
main() {
    echo "开始设置微信公众号RSS生成器..."
    echo ""

    # 检查环境
    check_git

    # 初始化Git仓库
    init_git

    # 配置GitHub仓库
    read -p "是否要自动创建GitHub仓库？(y/N): " create_repo
    if [[ $create_repo =~ ^[Yy]$ ]]; then
        setup_github_repo
    fi

    # 设置定时任务
    read -p "是否要设置本地定时任务？(y/N): " setup_cron_job
    if [[ $setup_cron_job =~ ^[Yy]$ ]]; then
        setup_cron
    fi

    # 配置飞书
    setup_feishu

    # 生成初始RSS
    generate_initial_rss

    # 显示使用说明
    show_usage
}

# 运行主函数
main "$@"