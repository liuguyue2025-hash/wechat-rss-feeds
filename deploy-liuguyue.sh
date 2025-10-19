#!/bin/bash

# 🚀 liuguyue2025-hash 专属GitHub部署脚本
# 一键部署RSS系统到GitHub Pages

echo "🎉 微信公众号RSS系统 - liuguyue2025-hash 专属部署"
echo "============================================="
echo ""

# 配置信息
GITHUB_USERNAME="liuguyue2025-hash"
GITHUB_REPO="wechat-rss-feeds"
GITHUB_URL="https://github.com/liuguyue2025-hash/wechat-rss-feeds.git"
GITHUB_PAGES_URL="https://liuguyue2025-hash.github.io/wechat-rss-feeds"

echo "📋 您的配置信息："
echo "GitHub用户名: $GITHUB_USERNAME"
echo "仓库地址: $GITHUB_URL"
echo "Pages地址: $GITHUB_PAGES_URL"
echo ""

# 进入项目目录
cd /Users/guyue/wechat-rss-feeds

# 准备Git仓库
echo "🔧 准备Git仓库..."
if [ ! -d ".git" ]; then
    git init
    echo "✅ Git仓库初始化完成"
fi

# 添加所有文件
git add .

# 提交代码
echo "📦 提交代码..."
git commit -m "🚀 GitHub Pages部署准备 - 用户: liuguyue2025-hash

✨ 功能特性:
- 17个优质微信公众号RSS源
- 支持NotebookLM使用
- 完全免费GitHub Pages托管
- 自动化GitHub Actions部署

📊 统计:
- 公众号: $(ls -1 rss/*.xml | wc -l)个
- 分类: $(cat wechat-rss-accounts.json | jq -r '.accounts | map(.category) | unique | length')个

🎯 NotebookLM可用链接示例:
- 孟岩: $GITHUB_PAGES_URL/rss/mengyan.xml
- 辉哥奇谭: $GITHUB_PAGES_URL/rss/huigeqitan.xml
- 数字生命卡兹克: $GITHUB_PAGES_URL/rss/digitallife.xml

🚀 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# 配置远程仓库
echo "🔗 配置远程仓库..."
git remote remove origin 2>/dev/null || true
git remote add origin $GITHUB_URL

# 切换到main分支
git branch -M main

echo ""
echo "✅ 代码准备完成！"
echo ""
echo "🚀 下一步操作："
echo "1. 先在GitHub上创建仓库（如果还没有创建）"
echo "2. 然后推送代码"
echo ""
echo "📋 GitHub仓库创建步骤："
echo "1. 访问: https://github.com/liuguyue2025-hash"
echo "2. 点击右上角 '+' → 'New repository'"
echo "3. 仓库名: wechat-rss-feeds"
echo "4. 选择 Public（公开）"
echo "5. 点击 'Create repository'"
echo ""

read -p "仓库创建完成后，按Enter键继续推送代码..."

# 推送代码
echo "🚀 正在推送代码到GitHub..."
if git push -u origin main; then
    echo "✅ 代码推送成功！"
else
    echo "❌ 代码推送失败，请检查："
    echo "1. 是否已登录GitHub"
    echo "2. 仓库是否已创建"
    echo "3. 网络连接是否正常"
    echo ""
    echo "请手动执行: git push -u origin main"
    exit 1
fi

# 生成成功指南
cat > DEPLOYMENT_COMPLETE.md << EOF
# 🎉 GitHub部署完成！liuguyue2025-hash

## ✅ 部署状态
- **GitHub用户名**: liuguyue2025-hash
- **仓库地址**: $GITHUB_URL
- **Pages地址**: $GITHUB_PAGES_URL
- **部署状态**: 代码已推送成功

## 🚀 下一步：启用GitHub Pages

### 1. 访问GitHub仓库
点击这里: $GITHUB_URL

### 2. 启用GitHub Pages
1. 在仓库页面点击右上角的 **"Settings"** 标签
2. 在左侧菜单中找到 **"Pages"**
3. 在 **"Source"** 部分选择 **"Deploy from a branch"**
4. **Branch** 选择 **"main"**
5. **Folder** 选择 **"/ (root)"**
6. 点击 **"Save"**

### 3. 等待部署完成
- GitHub需要2-5分钟时间部署
- 完成后会显示: "Your site is published at $GITHUB_PAGES_URL"

## 📱 NotebookLM可用RSS链接

启用GitHub Pages后，使用这些链接：

### 🎯 热门推荐（先试这些）
- **孟岩**: $GITHUB_PAGES_URL/rss/mengyan.xml
- **辉哥奇谭**: $GITHUB_PAGES_URL/rss/huigeqitan.xml
- **数字生命卡兹克**: $GITHUB_PAGES_URL/rss/digitallife.xml

### 💰 投资理财类
- **金渐成**: $GITHUB_PAGES_URL/rss/jinjincheng.xml
- **也谈钱**: $GITHUB_PAGES_URL/rss/yetanqian.xml
- **老华的博客**: $GITHUB_PAGES_URL/rss/老华的博客.xml

### 🌱 个人成长类
- **自我的SZ**: $GITHUB_PAGES_URL/rss/ziwodesz.xml
- **丹喵的无限游戏**: $GITHUB_PAGES_URL/rss/danmiao.xml
- **成甲**: $GITHUB_PAGES_URL/rss/chengjia.xml
- **孤独大脑**: $GITHUB_PAGES_URL/rss/gududanao.xml

### 🚀 AI科技类
- **哥飞**: $GITHUB_PAGES_URL/rss/gefei.xml
- **饼干哥哥AGI**: $GITHUB_PAGES_URL/rss/binganage.xml
- **硅基逆族**: $GITHUB_PAGES_URL/rss/硅基逆族.xml

### 💼 商业创业类
- **生财有术**: $GITHUB_PAGES_URL/rss/shengcai.xml
- **刘小排r**: $GITHUB_PAGES_URL/rss/liuxiaopai.xml
- **caoz的梦呓**: $GITHUB_PAGES_URL/rss/caoz的梦呓.xml
- **小道消息**: $GITHUB_PAGES_URL/rss/小道消息.xml

## 🎯 在NotebookLM中使用

1. **打开NotebookLM**: https://notebooklm.google.com/
2. **创建新笔记本**: 点击 "+ New notebook"
3. **添加RSS源**: 点击 "添加源" → "Website"
4. **粘贴RSS链接**: 复制上面的任意链接
5. **开始AI对话**: 等待处理完成后开始提问

### 💡 使用示例
- "请总结孟岩的主要投资观点"
- "辉哥奇谭对职业发展有什么建议？"
- "AI领域有哪些最新趋势？"

## 🤖 自动化功能

✅ **GitHub Actions已配置**：
- 每日2点（UTC时间）自动更新RSS
- 每次推送代码时自动更新
- 自动部署到GitHub Pages

## 📊 最终统计

✅ **您现在拥有**：
- 17个优质微信公众号RSS源
- 真实在线链接（可在NotebookLM中使用）
- 完全免费GitHub Pages托管
- 自动化更新系统
- 多设备访问能力

---

## 🎊 恭喜！

您的微信公众号RSS系统已完全部署完成！

开始享受AI驱动的阅读体验吧！🚀

---
部署完成时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF

echo ""
echo "🎉 部署准备完成！"
echo ""
echo "📋 下一步操作："
echo "1. 🔗 访问GitHub仓库: $GITHUB_URL"
echo "2. ⚙️  启用GitHub Pages: Settings → Pages"
echo "3. ⏳ 等待2-5分钟部署完成"
echo "4. 📖 查看详细指南: DEPLOYMENT_COMPLETE.md"
echo "5. 🎯 在NotebookLM中开始使用RSS链接"
echo ""
echo "🚀 您的RSS系统即将完全可用！"