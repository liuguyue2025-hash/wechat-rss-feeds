# 🚀 快速开始指南

## 📊 当前配置
- GitHub用户名: guyue
- 仓库名称: wechat-rss-feeds
- Pages地址: https://guyue.github.io/wechat-rss-feeds

## 🎯 立即使用（本地）

### 在NotebookLM中使用本地RSS文件
1. 打开 https://notebooklm.google.com/
2. 创建新笔记本
3. 添加源 → Website
4. 粘贴以下任意链接：

```
file:///Users/guyue/wechat-rss-feeds/rss/jinjincheng.xml
file:///Users/guyue/wechat-rss-feeds/rss/mengyan.xml
file:///Users/guyue/wechat-rss-feeds/rss/huigeqitan.xml
```

## 📱 添加新公众号
```bash
./wechat-rss-manager-lark.sh add "公众号名" "描述" "分类"
```

## 📋 查看所有公众号
```bash
./wechat-rss-manager-lark.sh list
```

## 🌐 部署到GitHub（可选）
1. 在GitHub创建仓库: wechat-rss-feeds
2. 推送代码:
```bash
git remote add origin https://github.com/guyue/wechat-rss-feeds.git
git push -u origin main
```
3. 启用GitHub Pages
4. 使用在线RSS: https://guyue.github.io/wechat-rss-feeds/rss/公众号名称.xml

---
配置完成时间: 2025-10-17 14:24:25
