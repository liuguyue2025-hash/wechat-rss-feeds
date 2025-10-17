# 微信公众号RSS生成器

自动化将微信公众号文章转换为RSS订阅源，支持NotebookLM使用。

## 功能特性

- ✅ 支持14+个优质微信公众号
- 🚀 自动生成RSS 2.0格式
- 📱 飞书集成通知
- ➕ 动态添加新账号
- 📦 GitHub Pages免费托管
- ⏰ 每日自动更新
- 💰 成本≤50元/月（免费方案）

## 支持的公众号

| 公众号 | 分类 | RSS链接 |
|--------|------|---------|
| 金渐成 | 投资理财 | [jinjincheng.xml](rss/jinjincheng.xml) |
| 自我的SZ | 个人成长 | [ziwodesz.xml](rss/ziwodesz.xml) |
| 孟岩 | 投资思考 | [mengyan.xml](rss/mengyan.xml) |
| 辉哥奇谭 | 职场发展 | [huigeqitan.xml](rss/huigeqitan.xml) |
| 生财有术 | 商业思维 | [shengcai.xml](rss/shengcai.xml) |
| 刘小排r | 产品运营 | [liuxiaopai.xml](rss/liuxiaopai.xml) |
| 哥飞 | AI科技 | [gefei.xml](rss/gefei.xml) |
| 丹喵的无限游戏 | 思维方法 | [danmiao.xml](rss/danmiao.xml) |
| 成甲 | 学习方法 | [chengjia.xml](rss/chengjia.xml) |
| 数字生命卡兹克 | AI前沿 | [digitallife.xml](rss/digitallife.xml) |
| 孤独大脑 | 未来思考 | [gududanao.xml](rss/gududanao.xml) |
| 也谈钱 | 理财消费 | [yetanqian.xml](rss/yetanqian.xml) |
| 饼干哥哥AGI | AI技术 | [binganage.xml](rss/binganage.xml) |
| 老华的博客 | 投资商业 | [老华的博客.xml](rss/老华的博客.xml) |

## 使用方法

### 1. 订阅RSS源

直接复制下面的RSS链接到NotebookLM或其他RSS阅读器：

```
https://your-username.github.io/wechat-rss-feeds/rss/jinjincheng.xml
```

### 2. 动态添加公众号

```bash
# 添加新公众号
./wechat-rss-manager-lark.sh add "公众号名称" "描述" "分类"

# 生成所有RSS
./wechat-rss-manager-lark.sh generate-all

# 查看所有公众号
./wechat-rss-manager-lark.sh list
```

### 3. 飞书集成配置

1. 在飞书群创建自定义机器人
2. 复制Webhook URL
3. 修改脚本中的配置：
   ```bash
   FEISHU_WEBHOOK_URL="your-webhook-url"
   GITHUB_BASE_URL="https://your-username.github.io/wechat-rss-feeds"
   ```

## 自动化部署

### GitHub Actions（推荐）

在GitHub仓库中创建 `.github/workflows/update-rss.yml`:

```yaml
name: Update RSS Feeds
on:
  schedule:
    - cron: '0 2 * * *'  # 每日2点更新
  workflow_dispatch:
jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'
      - name: Generate RSS
        run: |
          chmod +x ./wechat-rss-manager-lark.sh
          ./wechat-rss-manager-lark.sh generate-all
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./
```

### 本地定时任务

```bash
# 编辑crontab
crontab -e

# 添加每日更新任务（每日2点执行）
0 2 * * * /Users/guyue/wechat-rss-manager-lark.sh generate-all
```

## 系统架构

```
微信公众号文章 → Shell脚本 → RSS XML → GitHub Pages → NotebookLM
                      ↓
                  飞书通知
```

## 成本分析

- **GitHub Pages**: 免费
- **GitHub Actions**: 每月2000分钟免费额度
- **飞书API**: 免费
- **总成本**: 0元/月

## 文件说明

- `wechat-rss-accounts.json` - 公众号配置文件
- `wechat-rss-manager-lark.sh` - 主管理脚本
- `rss/` - RSS文件目录
- `README.md` - 项目说明文档

## 技术栈

- **Shell Script**: 自动化脚本
- **RSS 2.0**: 标准RSS格式
- **GitHub Pages**: 静态网站托管
- **Feishu Webhook**: 即时通知
- **GitHub Actions**: CI/CD自动化

## 许可证

MIT License - 可自由使用和修改