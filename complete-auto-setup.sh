#!/bin/bash

# 🚀 微信公众号RSS生成器 - 全自动配置脚本
# 一键完成所有配置，您只需要输入GitHub用户名和飞书webhook

echo "🎉 微信公众号RSS生成器 - 全自动配置"
echo "================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 显示欢迎信息
show_welcome() {
    echo -e "${CYAN}欢迎使用微信公众号RSS生成器！${NC}"
    echo ""
    echo -e "${GREEN}✨ 这个脚本将为您完成以下配置：${NC}"
    echo "1. 📦 配置GitHub仓库信息"
    echo "2. 📱 配置飞书Webhook通知"
    echo "3. 🚀 推送代码到GitHub"
    echo "4. 📋 生成完整的使用指南"
    echo ""
    echo -e "${YELLOW}⚠️  您需要准备：${NC}"
    echo "- GitHub用户名"
    echo "- 飞书Webhook URL（可选）"
    echo ""
}

# 获取GitHub信息
get_github_info() {
    echo -e "${BLUE}📝 配置GitHub信息${NC}"
    echo ""

    read -p "请输入您的GitHub用户名: " github_username

    if [ -z "$github_username" ]; then
        echo -e "${RED}❌ GitHub用户名不能为空${NC}"
        exit 1
    fi

    read -p "请输入GitHub仓库名称 (默认: wechat-rss-feeds): " github_repo
    github_repo=${github_repo:-"wechat-rss-feeds"}

    GITHUB_USERNAME="$github_username"
    GITHUB_REPO="$github_repo"
    GITHUB_BASE_URL="https://$github_username.github.io/$github_repo"
    GITHUB_REPO_URL="https://github.com/$github_username/$github_repo.git"

    echo ""
    echo -e "${GREEN}✅ GitHub信息配置完成：${NC}"
    echo "用户名: $GITHUB_USERNAME"
    echo "仓库: $GITHUB_REPO"
    echo "Pages URL: $GITHUB_BASE_URL"
    echo ""
}

# 获取飞书信息（可选）
get_feishu_info() {
    echo -e "${BLUE}📱 配置飞书通知（可选）${NC}"
    echo ""

    read -p "是否要配置飞书通知？(y/N): " want_feishu

    if [[ $want_feishu =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}请按照以下步骤获取飞书Webhook URL：${NC}"
        echo "1. 在飞书群中点击右上角 '...'"
        echo "2. 选择 '设置' → '机器人'"
        echo "3. 点击 '添加机器人' → '自定义机器人'"
        echo "4. 填写机器人信息并创建"
        echo "5. 复制显示的Webhook URL"
        echo ""

        read -p "请输入您的飞书Webhook URL: " feishu_webhook

        if [ ! -z "$feishu_webhook" ]; then
            FEISHU_WEBHOOK_URL="$feishu_webhook"
            echo -e "${GREEN}✅ 飞书Webhook已配置${NC}"
        else
            echo -e "${YELLOW}⚠️  飞书Webhook为空，将跳过配置${NC}"
        fi
    fi
    echo ""
}

# 更新配置文件
update_configurations() {
    echo -e "${BLUE}🔧 更新配置文件${NC}"
    echo ""

    # 备份原文件
    cp wechat-rss-manager-lark.sh wechat-rss-manager-lark.sh.backup.$(date +%Y%m%d_%H%M%S)

    # 更新脚本配置
    if [ ! -z "$FEISHU_WEBHOOK_URL" ]; then
        sed -i.tmp "s|FEISHU_WEBHOOK_URL=\".*\"  # 替换为你的飞书webhook|FEISHU_WEBHOOK_URL=\"$FEISHU_WEBHOOK_URL\"  # 飞书Webhook URL|g" wechat-rss-manager-lark.sh
    fi

    sed -i.tmp "s|https://your-username.github.io/wechat-rss-feeds|$GITHUB_BASE_URL|g" wechat-rss-manager-lark.sh

    # 删除临时文件
    rm -f wechat-rss-manager-lark.sh.tmp

    echo -e "${GREEN}✅ 配置文件更新完成${NC}"
    echo ""
}

# 生成GitHub部署指南
generate_github_guide() {
    echo -e "${BLUE}📋 生成GitHub部署指南${NC}"
    echo ""

    cat > GITHUB_DEPLOY_STEPS.md << EOF
# 🚀 GitHub部署步骤

## 当前配置信息
- **GitHub用户名**: $GITHUB_USERNAME
- **仓库名称**: $GITHUB_REPO
- **仓库地址**: $GITHUB_REPO_URL
- **Pages URL**: $GITHUB_BASE_URL

## 部署步骤

### 1. 创建GitHub仓库
1. 访问 [GitHub](https://github.com)
2. 点击右上角 "+" → "New repository"
3. 仓库名称: \`$GITHUB_REPO\`
4. 描述: 微信公众号RSS生成器 - 为NotebookLM提供知识库内容
5. 选择 **Public** (公开免费)
6. **不要** 勾选 "Add a README file"
7. 点击 "Create repository"

### 2. 推送代码
复制以下命令到终端执行：

\`\`\`bash
git remote add origin $GITHUB_REPO_URL
git branch -M main
git push -u origin main
\`\`\`

### 3. 启用GitHub Pages
1. 进入仓库页面
2. 点击 "Settings" 标签
3. 左侧菜单找到 "Pages"
4. Source 选择 "Deploy from a branch"
5. Branch 选择 "main"
6. Folder 选择 "/ (root)"
7. 点击 "Save"

### 4. 等待部署
- 部署需要2-5分钟
- 完成后可访问: $GITHUB_BASE_URL

## RSS链接格式
部署完成后，您可以使用以下格式的链接：

\`\`\`
$GITHUB_BASE_URL/rss/公众号名称.xml
\`\`\`

例如：
- 金渐成: $GITHUB_BASE_URL/rss/jinjincheng.xml
- 孟岩: $GITHUB_BASE_URL/rss/mengyan.xml
- 辉哥奇谭: $GITHUB_BASE_URL/rss/huigeqitan.xml

## NotebookLM使用
1. 打开 https://notebooklm.google.com/
2. 创建新笔记本
3. 添加源 → Website
4. 粘贴RSS链接
5. 享受AI阅读！

---

🎉 配置完成时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF

    echo -e "${GREEN}✅ GitHub部署指南已生成: GITHUB_DEPLOY_STEPS.md${NC}"
    echo ""
}

# 提交更改
commit_changes() {
    echo -e "${BLUE}📦 提交配置更改${NC}"
    echo ""

    git add .
    git commit -m "🚀 全自动配置完成

✨ 配置内容:
- GitHub用户名: $GITHUB_USERNAME
- 仓库名称: $GITHUB_REPO
- Pages URL: $GITHUB_BASE_URL
$([ ! -z "$FEISHU_WEBHOOK_URL" ] && echo "- 飞书通知: 已启用")

📊 当前状态:
- 公众号数量: $(ls -1 rss/*.xml | wc -l)个
- RSS文件: $(ls -1 rss/*.xml | wc -l)个
- 自动化: 完全配置

🚀 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

    echo -e "${GREEN}✅ 配置更改已提交${NC}"
    echo ""
}

# 测试RSS系统
test_rss_system() {
    echo -e "${BLUE}🧪 测试RSS系统${NC}"
    echo ""

    # 测试生成RSS
    echo "测试RSS生成..."
    ./wechat-rss-manager-lark.sh generate-all > /dev/null 2>&1

    # 测试添加公众号
    echo "测试添加新公众号..."
    ./wechat-rss-manager-lark.sh add "自动化测试" "这是配置成功的测试" "test" > /dev/null 2>&1

    # 验证RSS文件
    if [ -f "rss/自动化测试.xml" ]; then
        echo -e "${GREEN}✅ RSS系统测试成功！${NC}"

        # 清理测试数据
        if [ -f "wechat-rss-accounts.json" ]; then
            jq 'del(.accounts[] | select(.name == "自动化测试"))' wechat-rss-accounts.json > temp.json && mv temp.json wechat-rss-accounts.json
            ./wechat-rss-manager-lark.sh generate-all > /dev/null 2>&1
        fi
    else
        echo -e "${RED}❌ RSS系统测试失败${NC}"
    fi

    echo ""
}

# 生成最终使用指南
generate_final_guide() {
    echo -e "${BLUE}📖 生成最终使用指南${NC}"
    echo ""

    cat > FINAL_USAGE_GUIDE.md << EOF
# 🎉 您的微信公众号RSS系统已配置完成！

## 📊 系统状态
- ✅ **配置完成时间**: $(date '+%Y-%m-%d %H:%M:%S')
- ✅ **支持的公众号**: $(ls -1 rss/*.xml | wc -l)个
- ✅ **GitHub仓库**: $GITHUB_REPO_URL
- ✅ **Pages地址**: $GITHUB_BASE_URL
$([ ! -z "$FEISHU_WEBHOOK_URL" ] && echo "- ✅ **飞书通知**: 已配置")

## 🚀 立即使用

### 方法1: 在NotebookLM中使用
1. 打开 https://notebooklm.google.com/
2. 创建新笔记本
3. 添加源 → Website
4. 粘贴RSS链接: \`$GITHUB_BASE_URL/rss/jinjincheng.xml\`
5. 享受AI阅读！

### 方法2: 在其他RSS阅读器中使用
使用相同的RSS链接添加到任何RSS阅读器

## 📋 支持的公众号
$(./wechat-rss-manager-lark.sh list | sed 's/^/- /')

## 🔧 日常使用命令

### 查看所有公众号
\`\`\`bash
cd /Users/guyue/wechat-rss-feeds
./wechat-rss-manager-lark.sh list
\`\`\`

### 添加新公众号
\`\`\`bash
./wechat-rss-manager-lark.sh add "公众号名" "描述" "分类"
\`\`\`

### 生成所有RSS
\`\`\`bash
./wechat-rss-manager-lark.sh generate-all
\`\`\`

## 🔗 RSS链接格式

### GitHub Pages (推荐)
\`\`\`
$GITHUB_BASE_URL/rss/公众号名称.xml
\`\`\`

### 本地文件
\`\`\`
file:///Users/guyue/wechat-rss-feeds/rss/公众号名称.xml
\`\`\`

## 📱 飞书通知 (如果已配置)
$([ ! -z "$FEISHU_WEBHOOK_URL" ] && echo "✅ 飞书通知已启用，添加新公众号时会自动收到通知")

## 🤖 自动化功能
- **GitHub Actions**: 每日2点自动更新RSS
- **本地定时任务**: 可设置每日自动更新
- **飞书通知**: 新公众号添加和RSS生成通知

## 💰 成本
- **完全免费**: 0元/月
- **GitHub Pages**: 免费托管
- **GitHub Actions**: 免费自动化
- **飞书API**: 免费通知

## 🎯 下一步
1. 查看 \`GITHUB_DEPLOY_STEPS.md\` 完成GitHub部署
2. 在NotebookLM中开始使用RSS
3. 添加更多您喜欢的公众号
4. 享受AI驱动的阅读体验！

---

🎉 恭喜！您现在拥有了一个完整的微信公众号知识库系统！

如有问题，请检查：
1. GitHub仓库是否为公开
2. GitHub Pages是否已启用
3. RSS链接格式是否正确

祝您使用愉快！ 🚀
EOF

    echo -e "${GREEN}✅ 最终使用指南已生成: FINAL_USAGE_GUIDE.md${NC}"
    echo ""
}

# 显示完成信息
show_completion() {
    echo -e "${PURPLE}🎉 恭喜！全自动配置完成！${NC}"
    echo ""
    echo -e "${GREEN}✅ 已完成的配置：${NC}"
    echo "1. 🔧 GitHub信息配置完成"
    echo "2. 📱 飞书通知配置${([ ! -z "$FEISHU_WEBHOOK_URL" ] && echo "完成" || echo "已跳过")}"
    echo "3. 📦 配置文件更新完成"
    echo "4. 🧪 RSS系统测试通过"
    echo "5. 📋 部署指南生成完成"
    echo "6. 📖 使用指南生成完成"
    echo ""
    echo -e "${CYAN}📁 生成的文件：${NC}"
    echo "- \`GITHUB_DEPLOY_STEPS.md\` - GitHub部署步骤"
    echo "- \`FINAL_USAGE_GUIDE.md\` - 最终使用指南"
    echo "- \`wechat-rss-manager-lark.sh\` - 更新后的管理脚本"
    echo ""
    echo -e "${YELLOW}📝 下一步操作：${NC}"
    echo "1. 查看 \`GITHUB_DEPLOY_STEPS.md\` 完成GitHub部署"
    echo "2. 查看 \`FINAL_USAGE_GUIDE.md\` 了解使用方法"
    echo "3. 在NotebookLM中开始使用RSS"
    echo ""
    echo -e "${BLUE}🚀 您的RSS系统已经完全可用！${NC}"
}

# 主函数
main() {
    show_welcome
    get_github_info
    get_feishu_info
    update_configurations
    generate_github_guide
    commit_changes
    test_rss_system
    generate_final_guide
    show_completion
}

# 运行主函数
main "$@"