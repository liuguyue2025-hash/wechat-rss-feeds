# GitHub仓库设置指南

## 🚀 请按照以下步骤操作

### 第一步：在GitHub上创建新仓库

1. **登录GitHub**：
   - 打开 https://github.com
   - 登录您的账户

2. **创建新仓库**：
   - 点击右上角的 "+" 号
   - 选择 "New repository"

3. **填写仓库信息**：
   ```
   Repository name: wechat-rss-feeds
   Description: 微信公众号RSS生成器 - 为NotebookLM提供知识库内容
   Public: ✅ (选择公开仓库，免费)
   Private: ❌ (私有仓库需要付费)
   ```

4. **初始化设置**：
   - ❌ 不要勾选 "Add a README file" (我们已经有了)
   - ❌ 不要勾选 "Add .gitignore"
   - ❌ 不要勾选 "Choose a license"

5. **点击 "Create repository"**

### 第二步：推送代码到GitHub

创建仓库后，GitHub会显示快速设置页面。请复制以下命令并执行：

```bash
# 添加远程仓库（替换 YOUR_USERNAME 为您的GitHub用户名）
git remote add origin https://github.com/YOUR_USERNAME/wechat-rss-feeds.git

# 推送代码到GitHub
git push -u origin main
```

### 第三步：启用GitHub Pages

1. **进入仓库设置**：
   - 在您的仓库页面
   - 点击顶部的 "Settings" 标签

2. **配置Pages**：
   - 在左侧菜单中找到 "Pages"
   - 在 "Source" 部分选择 "Deploy from a branch"
   - Branch 选择 "main"
   - Folder 选择 "/ (root)"
   - 点击 "Save"

3. **等待部署**：
   - GitHub会自动构建和部署
   - 几分钟后，您的RSS文件就可以通过以下格式访问：
   ```
   https://YOUR_USERNAME.github.io/wechat-rss-feeds/rss/公众号名称.xml
   ```

### 第四步：验证RSS链接

部署完成后，您可以测试以下链接：

- 金渐成: `https://YOUR_USERNAME.github.io/wechat-rss-feeds/rss/jinjincheng.xml`
- 孟岩: `https://YOUR_USERNAME.github.io/wechat-rss-feeds/rss/mengyan.xml`
- 辉哥奇谭: `https://YOUR_USERNAME.github.io/wechat-rss-feeds/rss/huigeqitan.xml`

### 第五步：在NotebookLM中使用

1. **打开NotebookLM**： https://notebooklm.google.com/

2. **创建新笔记本**：
   - 点击 "Create new notebook"
   - 给笔记本命名，例如 "微信公众号精选"

3. **添加RSS源**：
   - 点击 "Add source"
   - 选择 "Website"
   - 粘贴RSS链接，例如：
   ```
   https://YOUR_USERNAME.github.io/wechat-rss-feeds/rss/jinjincheng.xml
   ```

4. **开始使用**：
   - NotebookLM会自动解析RSS内容
   - 您可以提问、总结、分析文章内容

## 🔧 高级配置（可选）

### 配置飞书通知

1. **创建飞书机器人**：
   - 在飞书群中点击右上角 "..."
   - 选择 "设置" → "机器人" → "添加机器人"
   - 选择 "自定义机器人"
   - 复制Webhook URL

2. **更新脚本配置**：
   ```bash
   # 编辑脚本
   nano wechat-rss-manager-lark.sh

   # 找到这一行并替换
   FEISHU_WEBHOOK_URL="your-webhook-url"
   # 改为
   FEISHU_WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/your-webhook-url"
   ```

3. **重新部署**：
   ```bash
   git add .
   git commit -m "配置飞书通知"
   git push
   ```

### 自动化更新

GitHub Actions已经配置好了，会：
- 每日2点（UTC时间）自动更新RSS
- 每次推送代码时自动更新
- 自动部署到GitHub Pages

## 📞 需要帮助？

如果遇到问题，请检查：

1. **GitHub用户名**：确保替换了 `YOUR_USERNAME`
2. **网络连接**：确保可以访问GitHub
3. **权限设置**：确保仓库是公开的
4. **文件路径**：确保RSS文件在 `rss/` 目录中

## 🎉 完成！

设置完成后，您就拥有了一个完全自动化的微信公众号RSS系统！

- ✅ 15个优质公众号源
- ✅ 每日自动更新
- ✅ 免费托管
- ✅ 支持NotebookLM
- ✅ 动态添加新账号