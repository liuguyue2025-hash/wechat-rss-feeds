#!/bin/bash

# 🚀 快速配置脚本 - 无需输入，使用默认配置
# 适合不想手动配置的用户

echo "🚀 微信公众号RSS生成器 - 快速配置"
echo "=============================="
echo ""

# 默认配置
DEFAULT_GITHUB_USERNAME="guyue"  # 请根据您的实际用户名修改
DEFAULT_REPO_NAME="wechat-rss-feeds"

echo "📋 使用默认配置："
echo "GitHub用户名: $DEFAULT_GITHUB_USERNAME"
echo "仓库名称: $DEFAULT_REPO_NAME"
echo ""

# 更新脚本配置
echo "🔧 更新配置文件..."

# 备份原文件
cp wechat-rss-manager-lark.sh wechat-rss-manager-lark.sh.backup.$(date +%Y%m%d_%H%M%S)

# 更新GitHub URL
GITHUB_BASE_URL="https://$DEFAULT_GITHUB_USERNAME.github.io/$DEFAULT_REPO_NAME"
sed -i.tmp "s|https://your-username.github.io/wechat-rss-feeds|$GITHUB_BASE_URL|g" wechat-rss-manager-lark.sh

# 删除临时文件
rm -f wechat-rss-manager-lark.sh.tmp

echo "✅ 配置更新完成"
echo ""

# 生成快速使用指南
cat > QUICK_START.md << EOF
# 🚀 快速开始指南

## 📊 当前配置
- GitHub用户名: $DEFAULT_GITHUB_USERNAME
- 仓库名称: $DEFAULT_REPO_NAME
- Pages地址: $GITHUB_BASE_URL

## 🎯 立即使用（本地）

### 在NotebookLM中使用本地RSS文件
1. 打开 https://notebooklm.google.com/
2. 创建新笔记本
3. 添加源 → Website
4. 粘贴以下任意链接：

\`\`\`
file:///Users/guyue/wechat-rss-feeds/rss/jinjincheng.xml
file:///Users/guyue/wechat-rss-feeds/rss/mengyan.xml
file:///Users/guyue/wechat-rss-feeds/rss/huigeqitan.xml
\`\`\`

## 📱 添加新公众号
\`\`\`bash
./wechat-rss-manager-lark.sh add "公众号名" "描述" "分类"
\`\`\`

## 📋 查看所有公众号
\`\`\`bash
./wechat-rss-manager-lark.sh list
\`\`\`

## 🌐 部署到GitHub（可选）
1. 在GitHub创建仓库: $DEFAULT_REPO_NAME
2. 推送代码:
\`\`\`bash
git remote add origin https://github.com/$DEFAULT_GITHUB_USERNAME/$DEFAULT_REPO_NAME.git
git push -u origin main
\`\`\`
3. 启用GitHub Pages
4. 使用在线RSS: $GITHUB_BASE_URL/rss/公众号名称.xml

---
配置完成时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF

echo "📖 快速开始指南已生成: QUICK_START.md"

# 提交更改
git add .
git commit -m "🚀 快速配置完成

✨ 配置内容:
- GitHub用户名: $DEFAULT_GITHUB_USERNAME
- Pages URL: $GITHUB_BASE_URL

📊 当前状态:
- 公众号数量: $(ls -1 rss/*.xml | wc -l)个
- 本地可用: 立即可用

🚀 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo ""
echo "🎉 配置完成！"
echo ""
echo "📁 生成的文件："
echo "- QUICK_START.md - 快速开始指南"
echo "- wechat-rss-manager-lark.sh - 更新后的脚本"
echo ""
echo "🚀 立即可用："
echo "1. 查看 QUICK_START.md"
echo "2. 在NotebookLM中使用本地RSS文件"
echo "3. 添加您喜欢的公众号"
echo ""
echo "🔗 本地RSS链接示例："
echo "file:///Users/guyue/wechat-rss-feeds/rss/jinjincheng.xml"