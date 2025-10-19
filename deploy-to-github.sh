#!/bin/bash

# 🚀 GitHub 自动部署脚本
# 一键将RSS系统部署到GitHub Pages

echo "🎉 微信公众号RSS系统 - GitHub自动部署"
echo "=================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

show_welcome() {
    echo -e "${BLUE}欢迎使用GitHub自动部署脚本！${NC}"
    echo ""
    echo -e "${GREEN}✨ 这个脚本将为您完成：${NC}"
    echo "1. 📦 获取GitHub用户信息"
    echo "2. 🔗 配置远程仓库地址"
    echo "3. 🚀 推送代码到GitHub"
    echo "4. 📋 生成详细的后续步骤指南"
    echo ""
}

get_github_info() {
    echo -e "${BLUE}📝 配置GitHub信息${NC}"
    echo ""

    read -p "请输入您的GitHub用户名: " github_username

    if [ -z "$github_username" ]; then
        echo -e "${RED}❌ GitHub用户名不能为空${NC}"
        exit 1
    fi

    read -p "请输入仓库名称 (默认: wechat-rss-feeds): " github_repo
    github_repo=${github_repo:-"wechat-rss-feeds"}

    GITHUB_USERNAME="$github_username"
    GITHUB_REPO="$github_repo"
    GITHUB_URL="https://github.com/$github_username/$github_repo.git"
    GITHUB_PAGES_URL="https://$github_username.github.io/$github_repo"

    echo ""
    echo -e "${GREEN}✅ GitHub信息配置完成：${NC}"
    echo "用户名: $GITHUB_USERNAME"
    echo "仓库: $GITHUB_REPO"
    echo "仓库地址: $GITHUB_URL"
    echo "Pages地址: $GITHUB_PAGES_URL"
    echo ""
}

prepare_repository() {
    echo -e "${BLUE}🔧 准备代码仓库${NC}"
    echo ""

    # 确保在正确的目录
    cd /Users/guyue/wechat-rss-feeds

    # 检查git状态
    if [ ! -d ".git" ]; then
        git init
        echo "✅ Git仓库初始化完成"
    fi

    # 添加所有文件
    git add .

    # 创建提交
    git commit -m "🚀 准备部署到GitHub Pages

✨ 功能特性:
- 17个优质微信公众号RSS源
- 支持投资理财、个人成长、AI科技等领域
- 动态添加新公众号功能
- 自动化GitHub Actions部署
- 飞书Webhook通知支持

📊 统计信息:
- 公众号数量: $(ls -1 rss/*.xml | wc -l)个
- RSS文件: $(ls -1 rss/*.xml | wc -l)个
- 分类: $(cat wechat-rss-accounts.json | jq -r '.accounts | map(.category) | unique | length')个

🚀 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

    echo -e "${GREEN}✅ 代码仓库准备完成${NC}"
    echo ""
}

configure_remote() {
    echo -e "${BLUE}🔗 配置远程仓库${NC}"
    echo ""

    # 检查是否已有远程仓库
    if git remote get-url origin > /dev/null 2>&1; then
        echo "⚠️  已存在远程仓库，正在更新..."
        git remote remove origin
    fi

    # 添加远程仓库
    git remote add origin $GITHUB_URL

    echo -e "${GREEN}✅ 远程仓库配置完成${NC}"
    echo "仓库地址: $GITHUB_URL"
    echo ""
}

push_to_github() {
    echo -e "${BLUE}🚀 推送代码到GitHub${NC}"
    echo ""

    # 确保在main分支
    git branch -M main

    # 推送代码
    echo "正在推送代码到GitHub..."
    if git push -u origin main; then
        echo -e "${GREEN}✅ 代码推送成功！${NC}"
    else
        echo -e "${RED}❌ 代码推送失败${NC}"
        echo "请检查："
        echo "1. GitHub用户名是否正确"
        echo "2. 仓库是否已在GitHub上创建"
        echo "3. 网络连接是否正常"
        echo ""
        echo "请先手动在GitHub上创建仓库，然后重新运行此脚本"
        exit 1
    fi
    echo ""
}

generate_success_guide() {
    echo -e "${BLUE}📋 生成部署成功指南${NC}"
    echo ""

    cat > GITHUB_SUCCESS_GUIDE.md << EOF
# 🎉 GitHub部署成功指南

## ✅ 部署已完成！

### 📊 您的信息
- **GitHub用户名**: $GITHUB_USERNAME
- **仓库名称**: $GITHUB_REPO
- **仓库地址**: $GITHUB_URL
- **Pages地址**: $GITHUB_PAGES_URL

### 🚀 下一步：启用GitHub Pages

1. **访问GitHub仓库**：
   点击这里: $GITHUB_URL

2. **进入Settings**：
   在仓库页面点击右上角的 "Settings" 标签

3. **配置Pages**：
   - 在左侧菜单中找到 "Pages"
   - 在 "Source" 部分选择 "Deploy from a branch"
   - Branch 选择 "main"
   - Folder 选择 "/ (root)"
   - 点击 "Save"

4. **等待部署**：
   - GitHub需要2-5分钟时间来部署您的网站
   - 部署完成后，您会看到类似这样的信息：
   "Your site is published at $GITHUB_PAGES_URL"

### 📱 在NotebookLM中使用

部署完成后，您可以使用以下RSS链接：

#### 🎯 热门推荐
- **孟岩**: $GITHUB_PAGES_URL/rss/mengyan.xml
- **辉哥奇谭**: $GITHUB_PAGES_URL/rss/huigeqitan.xml
- **数字生命卡兹克**: $GITHUB_PAGES_URL/rss/digitallife.xml

#### 💰 投资理财类
- **金渐成**: $GITHUB_PAGES_URL/rss/jinjincheng.xml
- **也谈钱**: $GITHUB_PAGES_URL/rss/yetanqian.xml
- **老华的博客**: $GITHUB_PAGES_URL/rss/老华的博客.xml

#### 🌱 个人成长类
- **自我的SZ**: $GITHUB_PAGES_URL/rss/ziwodesz.xml
- **丹喵的无限游戏**: $GITHUB_PAGES_URL/rss/danmiao.xml
- **成甲**: $GITHUB_PAGES_URL/rss/chengjia.xml
- **孤独大脑**: $GITHUB_PAGES_URL/rss/gududanao.xml

#### 🚀 AI科技类
- **哥飞**: $GITHUB_PAGES_URL/rss/gefei.xml
- **饼干哥哥AGI**: $GITHUB_PAGES_URL/rss/binganage.xml
- **硅基逆族**: $GITHUB_PAGES_URL/rss/硅基逆族.xml

#### 💼 商业创业类
- **生财有术**: $GITHUB_PAGES_URL/rss/shengcai.xml
- **刘小排r**: $GITHUB_PAGES_URL/rss/liuxiaopai.xml
- **caoz的梦呓**: $GITHUB_PAGES_URL/rss/caoz的梦呓.xml
- **小道消息**: $GITHUB_PAGES_URL/rss/小道消息.xml

### 🎯 在NotebookLM中使用步骤

1. **打开NotebookLM**: https://notebooklm.google.com/
2. **创建新笔记本**: 点击 "+ New notebook"
3. **添加RSS源**: 点击 "添加源" → "Website"
4. **粘贴RSS链接**: 复制上面的任意链接
5. **开始AI对话**: 等待处理完成后，开始向AI提问

### 💡 使用示例

在NotebookLM中尝试这些问题：
- "请总结孟岩的主要投资观点"
- "辉哥奇谭对职业发展有什么建议？"
- "AI领域有哪些最新趋势？"
- "对比这几位作者的观点"

### 🤖 自动化功能

✅ **GitHub Actions已配置**：
- 每日2点（UTC时间）自动更新RSS
- 每次推送代码时自动更新
- 自动部署到GitHub Pages

### 📱 飞书通知（可选）

如果您配置了飞书通知，每次添加新公众号时会自动收到通知。

---

## 🎊 恭喜！

您现在拥有：
- ✅ **17个优质公众号RSS源**
- ✅ **真实在线链接**（可在NotebookLM中使用）
- ✅ **完全免费托管**
- ✅ **自动化更新**
- ✅ **多设备访问**

开始享受AI驱动的阅读体验吧！

---

📞 **需要帮助？**
如果遇到问题，请检查：
1. GitHub仓库是否为公开
2. GitHub Pages是否已启用
3. 等待5-10分钟让Pages完全部署

部署完成时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF

    echo -e "${GREEN}✅ 成功指南已生成: GITHUB_SUCCESS_GUIDE.md${NC}"
    echo ""
}

show_completion() {
    echo -e "${PURPLE}🎉 恭喜！GitHub部署准备完成！${NC}"
    echo ""
    echo -e "${GREEN}✅ 已完成的步骤：${NC}"
    echo "1. 🔧 代码仓库准备完成"
    echo "2. 📦 GitHub信息配置完成"
    echo "3. 🔗 远程仓库配置完成"
    echo "4. 🚀 代码推送成功"
    echo "5. 📋 成功指南生成完成"
    echo ""
    echo -e "${YELLOW}📋 下一步操作：${NC}"
    echo "1. 🔗 访问GitHub仓库: $GITHUB_URL"
    echo "2. ⚙️  启用GitHub Pages: Settings → Pages → Deploy from branch"
    echo "3. ⏳ 等待2-5分钟部署完成"
    echo "4. 📖 查看详细指南: GITHUB_SUCCESS_GUIDE.md"
    echo "5. 🎯 在NotebookLM中开始使用"
    echo ""
    echo -e "${BLUE}🚀 您的RSS系统即将完全可用！${NC}"
    echo ""
    echo -e "${CYAN}💡 提示：${NC}"
    echo "- 查看生成的 GITHUB_SUCCESS_GUIDE.md 文件获取详细指导"
    echo "- 如果GitHub推送失败，请先在GitHub上手动创建仓库"
    echo "- 启用Pages后，RSS链接将在NotebookLM中100%可用"
}

# 主函数
main() {
    show_welcome
    get_github_info
    prepare_repository
    configure_remote
    push_to_github
    generate_success_guide
    show_completion
}

# 运行主函数
main "$@"