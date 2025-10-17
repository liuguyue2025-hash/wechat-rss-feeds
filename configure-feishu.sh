#!/bin/bash

# 飞书Webhook配置脚本
# 交互式配置飞书通知

echo "📱 飞书Webhook配置向导"
echo "==================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取用户输入
get_webhook_url() {
    echo "请按照以下步骤获取飞书Webhook URL："
    echo ""
    echo "1. 在飞书群中点击右上角 '...'"
    echo "2. 选择 '设置' → '机器人'"
    echo "3. 点击 '添加机器人' → '自定义机器人'"
    echo "4. 填写机器人信息并创建"
    echo "5. 复制显示的Webhook URL"
    echo ""
    echo -e "${BLUE}Webhook URL格式通常为：${NC}"
    echo "https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    echo ""

    read -p "请输入您的飞书Webhook URL: " webhook_url

    # 验证URL格式
    if [[ $webhook_url =~ ^https://open\.feishu\.cn/open-apis/bot/v2/hook/[a-f0-9-]{36}$ ]]; then
        echo -e "${GREEN}✅ Webhook URL格式正确${NC}"
        FEISHU_WEBHOOK_URL="$webhook_url"
    else
        echo -e "${YELLOW}⚠️  Webhook URL格式可能不正确，但仍将保存${NC}"
        FEISHU_WEBHOOK_URL="$webhook_url"
    fi
}

get_github_info() {
    echo ""
    echo "📝 GitHub信息配置"
    echo ""

    read -p "请输入您的GitHub用户名: " github_username
    read -p "请输入GitHub仓库名称 (默认: wechat-rss-feeds): " github_repo

    github_repo=${github_repo:-"wechat-rss-feeds"}
    GITHUB_BASE_URL="https://$github_username.github.io/$github_repo"

    echo -e "${GREEN}✅ GitHub Pages URL将为: $GITHUB_BASE_URL${NC}"
}

backup_script() {
    echo ""
    echo "📦 备份原脚本..."
    cp wechat-rss-manager-lark.sh wechat-rss-manager-lark.sh.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${GREEN}✅ 备份完成${NC}"
}

update_script() {
    echo ""
    echo "🔧 更新脚本配置..."

    # 使用sed替换配置
    sed -i.tmp "s|FEISHU_WEBHOOK_URL=\".*\"  # 替换为你的飞书webhook|FEISHU_WEBHOOK_URL=\"$FEISHU_WEBHOOK_URL\"  # 飞书Webhook URL|g" wechat-rss-manager-lark.sh
    sed -i.tmp "s|GITHUB_BASE_URL=\".*\"|GITHUB_BASE_URL=\"$GITHUB_BASE_URL\"|g" wechat-rss-manager-lark.sh

    # 删除临时文件
    rm -f wechat-rss-manager-lark.sh.tmp

    echo -e "${GREEN}✅ 脚本配置更新完成${NC}"
}

test_configuration() {
    echo ""
    echo "🧪 测试配置..."

    # 测试添加一个测试公众号
    echo "正在测试添加新公众号的通知..."
    ./wechat-rss-manager-lark.sh add "飞书测试" "这是一个测试公众号" "test" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 配置测试成功！${NC}"
        echo "请检查您的飞书群是否收到通知。"
    else
        echo -e "${RED}❌ 配置测试失败${NC}"
        echo "请检查Webhook URL是否正确。"
    fi

    # 删除测试公众号
    if [ -f "wechat-rss-accounts.json" ]; then
        jq 'del(.accounts[] | select(.name == "飞书测试"))' wechat-rss-accounts.json > temp.json && mv temp.json wechat-rss-accounts.json
        ./wechat-rss-manager-lark.sh generate-all > /dev/null 2>&1
    fi
}

show_final_info() {
    echo ""
    echo "🎉 飞书配置完成！"
    echo "==================="
    echo ""
    echo "📋 配置信息："
    echo "🔗 飞书Webhook: ${FEISHU_WEBHOOK_URL:0:30}..."
    echo "🌐 GitHub Pages: $GITHUB_BASE_URL"
    echo ""
    echo "🚀 现在您可以："
    echo "  ./wechat-rss-manager-lark.sh add '公众号名' '描述' '分类'  # 添加公众号（会通知飞书）"
    echo "  ./wechat-rss-manager-lark.sh generate-all              # 生成RSS（会通知飞书）"
    echo ""
    echo "📱 飞书通知功能："
    echo "  ✅ 新公众号添加通知"
    echo "  ✅ RSS生成完成通知"
    echo "  ✅ 错误和警告通知"
    echo ""
    echo "📝 下一步："
    echo "  1. 推送代码到GitHub: git add . && git commit -m '配置飞书通知' && git push"
    echo "  2. 等待GitHub Actions部署完成"
    echo "  3. 开始使用RSS系统！"
}

# 主函数
main() {
    echo "开始配置飞书Webhook..."
    echo ""

    # 获取配置信息
    get_webhook_url
    get_github_info

    # 确认配置
    echo ""
    echo "📋 配置确认："
    echo "🔗 飞书Webhook: ${FEISHU_WEBHOOK_URL:0:30}..."
    echo "🌐 GitHub Pages: $GITHUB_BASE_URL"
    echo ""

    read -p "确认配置正确？(y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "配置已取消。"
        exit 0
    fi

    # 执行配置
    backup_script
    update_script

    # 测试配置
    read -p "是否要测试配置？(Y/n): " test_confirm
    test_confirm=${test_confirm:-"y"}
    if [[ $test_confirm =~ ^[Yy]$ ]]; then
        test_configuration
    fi

    # 显示完成信息
    show_final_info
}

# 运行主函数
main "$@"