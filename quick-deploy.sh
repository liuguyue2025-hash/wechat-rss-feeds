#!/bin/bash

# 🚀 快速GitHub部署脚本
# 使用默认配置快速部署

echo "🎉 微信公众号RSS系统 - 快速GitHub部署"
echo "==================================="
echo ""

# 默认配置
DEFAULT_GITHUB_USERNAME="guyue"
DEFAULT_REPO_NAME="wechat-rss-feeds"

echo "📋 使用默认配置："
echo "GitHub用户名: $DEFAULT_GITHUB_USERNAME"
echo "仓库名称: $DEFAULT_REPO_NAME"
echo ""

# 确认部署
read -p "确认使用此配置部署？(y/N): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "部署已取消。"
    exit 0
fi

# 进入项目目录
cd /Users/guyue/wechat-rss-feeds

# 准备Git仓库
echo "🔧 准备Git仓库..."
if [ ! -d ".git" ]; then
    git init
fi

git add .
git commit -m "🚀 GitHub Pages部署准备

✨ 功能特性:
- 17个优质微信公众号RSS源
- 支持NotebookLM使用
- 完全免费托管

📊 统计:
- 公众号: $(ls -1 rss/*.xml | wc -l)个
- 分类: 7个

🚀 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# 配置远程仓库
GITHUB_URL="https://github.com/$DEFAULT_GITHUB_USERNAME/$DEFAULT_REPO_NAME.git"
GITHUB_PAGES_URL="https://$DEFAULT_GITHUB_USERNAME.github.io/$DEFAULT_REPO_NAME"

echo "🔗 配置远程仓库..."
git remote remove origin 2>/dev/null || true
git remote add origin $GITHUB_URL

# 推送代码
echo "🚀 推送代码到GitHub..."
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ 代码推送成功！"
else
    echo "❌ 代码推送失败"
    echo "请先在GitHub上创建仓库：$GITHUB_URL"
    echo "然后重新运行此脚本"
    exit 1
fi

# 生成成功指南
cat > DEPLOYMENT_SUCCESS.md << EOF
# 🎉 GitHub部署成功！

## 📋 您的信息
- **GitHub用户名**: $DEFAULT_GITHUB_USERNAME
- **仓库地址**: $GITHUB_URL
- **Pages地址**: $GITHUB_PAGES_URL

## 🚀 下一步：启用GitHub Pages

1. **访问GitHub仓库**: [点击这里]($GITHUB_URL)

2. **进入Settings**:
   - 在仓库页面点击右上角的 "Settings" 标签

3. **配置Pages**:
   - 左侧菜单找到 "Pages"
   - Source 选择 "Deploy from a branch"
   - Branch 选择 "main"
   - Folder 选择 "/ (root)"
   - 点击 "Save"

4. **等待部署**: 2-5分钟后完成

## 📱 NotebookLM可用链接

部署完成后，使用这些链接：

- **孟岩**: $GITHUB_PAGES_URL/rss/mengyan.xml
- **辉哥奇谭**: $GITHUB_PAGES_URL/rss/huigeqitan.xml
- **数字生命卡兹克**: $GITHUB_PAGES_URL/rss/digitallife.xml

## 🎯 在NotebookLM中使用

1. 打开 https://notebooklm.google.com/
2. 创建新笔记本
3. 添加源 → Website
4. 粘贴RSS链接
5. 开始AI对话！

---
部署时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF

echo ""
echo "🎉 部署准备完成！"
echo ""
echo "📋 下一步操作："
echo "1. 🔗 访问GitHub仓库: $GITHUB_URL"
echo "2. ⚙️  启用GitHub Pages: Settings → Pages"
echo "3. 📖 查看详细指南: DEPLOYMENT_SUCCESS.md"
echo "4. 🎯 在NotebookLM中开始使用RSS链接"
echo ""
echo "🚀 您的RSS系统即将完全可用！"