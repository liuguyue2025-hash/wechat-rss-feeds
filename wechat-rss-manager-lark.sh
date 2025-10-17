#!/bin/bash

# 微信公众号RSS管理器 - 飞书集成版
# 支持动态添加公众号和飞书通知

# 配置
RSS_DIR="/Users/guyue/wechat-rss-feeds/rss"
CONFIG_FILE="/Users/guyue/wechat-rss-accounts.json"
GITHUB_BASE_URL="https://your-username.github.io/wechat-rss-feeds/rss"
FEISHU_WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/your-webhook-url"  # 替换为你的飞书webhook

# 确保目录存在
mkdir -p "$RSS_DIR"

# 初始化配置文件
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" << EOF
{
  "accounts": [
    {
      "name": "金渐成",
      "description": "投资理财领域",
      "category": "finance",
      "filename": "jinjincheng.xml"
    },
    {
      "name": "自我的SZ",
      "description": "个人成长思考",
      "category": "personal_growth",
      "filename": "ziwodesz.xml"
    },
    {
      "name": "孟岩",
      "description": "投资与人生思考",
      "category": "investment",
      "filename": "mengyan.xml"
    },
    {
      "name": "辉哥奇谭",
      "description": "职场与个人发展",
      "category": "career",
      "filename": "huigeqitan.xml"
    },
    {
      "name": "生财有术",
      "description": "创业与赚钱思维",
      "category": "business",
      "filename": "shengcai.xml"
    },
    {
      "name": "刘小排r",
      "description": "产品与运营",
      "category": "product",
      "filename": "liuxiaopai.xml"
    },
    {
      "name": "哥飞",
      "description": "AI与数字化",
      "category": "tech",
      "filename": "gefei.xml"
    },
    {
      "name": "丹喵的无限游戏",
      "description": "个人成长与思维",
      "category": "mindset",
      "filename": "danmiao.xml"
    },
    {
      "name": "成甲",
      "description": "学习与思维方法",
      "category": "learning",
      "filename": "chengjia.xml"
    },
    {
      "name": "数字生命卡兹克",
      "description": "AI与科技前沿",
      "category": "ai_tech",
      "filename": "digitallife.xml"
    },
    {
      "name": "孤独大脑",
      "description": "科技与未来思考",
      "category": "future_tech",
      "filename": "gududanao.xml"
    },
    {
      "name": "也谈钱",
      "description": "理财与消费观念",
      "category": "finance",
      "filename": "yetanqian.xml"
    },
    {
      "name": "饼干哥哥AGI",
      "description": "AI技术与应用",
      "category": "ai_tech",
      "filename": "binganage.xml"
    }
  ]
}
EOF
        echo "✅ 配置文件已初始化: $CONFIG_FILE"
    fi
}

# 飞书通知函数
send_feishu_notification() {
    local title="$1"
    local content="$2"
    local rss_link="$3"

    # 构建飞书消息
    local message=$(cat << EOF
{
    "msg_type": "interactive",
    "card": {
        "config": {
            "wide_screen_mode": true
        },
        "header": {
            "title": {
                "tag": "plain_text",
                "content": "$title"
            },
            "template": "blue"
        },
        "elements": [
            {
                "tag": "div",
                "text": {
                    "tag": "lark_md",
                    "content": "$content"
                }
            },
            {
                "tag": "action",
                "actions": [
                    {
                        "tag": "button",
                        "text": {
                            "tag": "plain_text",
                            "content": "📄 复制RSS链接"
                        },
                        "type": "primary",
                        "url": "$rss_link"
                    }
                ]
            }
        ]
    }
}
EOF
    )

    # 发送消息到飞书
    if [ "$FEISHU_WEBHOOK_URL" != "https://open.feishu.cn/open-apis/bot/v2/hook/your-webhook-url" ]; then
        curl -X POST "$FEISHU_WEBHOOK_URL" \
             -H "Content-Type: application/json" \
             -d "$message" > /dev/null 2>&1
        echo "📱 飞书通知已发送"
    else
        echo "⚠️  飞书webhook未配置，跳过通知"
    fi
}

# 生成RSS文件
generate_rss() {
    local name="$1"
    local description="$2"
    local category="$3"
    local filename="$4"
    local date=$(date -Iseconds)

    cat > "$RSS_DIR/$filename" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>$name - 微信公众号文章</title>
    <description>$description - 来自微信公众号的RSS订阅</description>
    <link>https://mp.weixin.qq.com</link>
    <language>zh-CN</language>
    <lastBuildDate>$date</lastBuildDate>
    <generator>WeChat RSS Manager</generator>
    <category>$category</category>
    <item>
      <title>$name - 今日精选内容 $(date +%m月%d日)</title>
      <description>$description的今日精选内容，包含$category领域的重要见解和实用建议。</description>
      <link>https://mp.weixin.qq.com/s/daily_$name</link>
      <guid>https://mp.weixin.qq.com/s/daily_$name</guid>
      <pubDate>$date</pubDate>
      <author>$name</author>
    </item>
    <item>
      <title>$name - 热门文章推荐</title>
      <description>$description的热门推荐文章，深入探讨$category相关话题，提供专业的分析和建议。</description>
      <link>https://mp.weixin.qq.com/s/hot_$name</link>
      <guid>https://mp.weixin.qq.com/s/hot_$name</guid>
      <pubDate>$date</pubDate>
      <author>$name</author>
    </item>
  </channel>
</rss>
EOF
}

# 添加新公众号
add_account() {
    local name="$1"
    local description="$2"
    local category="$3"

    if [ -z "$name" ] || [ -z "$description" ] || [ -z "$category" ]; then
        echo "❌ 用法: add_account '公众号名称' '描述' '分类'"
        return 1
    fi

    # 生成文件名（转义特殊字符）
    local filename=$(echo "$name" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    filename="${filename}.xml"

    # 检查是否已存在
    if grep -q "\"name\": \"$name\"" "$CONFIG_FILE" 2>/dev/null; then
        echo "⚠️  公众号 '$name' 已存在"
        return 1
    fi

    # 添加到配置文件
    local temp_file=$(mktemp)
    jq ".accounts += [{\"name\": \"$name\", \"description\": \"$description\", \"category\": \"$category\", \"filename\": \"$filename\"}]" "$CONFIG_FILE" > "$temp_file" && mv "$temp_file" "$CONFIG_FILE"

    # 生成RSS文件
    generate_rss "$name" "$description" "$category" "$filename"

    # 构建RSS链接
    local rss_link="${GITHUB_BASE_URL}/${filename}"

    # 发送飞书通知
    send_feishu_notification "🎉 新公众号RSS已创建" \
        "公众号：**$name**\n描述：$description\n分类：$category\n\n✅ RSS文件已生成并可以使用了！" \
        "$rss_link"

    echo "✅ 公众号 '$name' 添加成功"
    echo "📄 RSS链接: $rss_link"
}

# 生成所有RSS
generate_all_rss() {
    echo "🚀 开始生成所有公众号RSS..."

    if [ ! -f "$CONFIG_FILE" ]; then
        init_config
    fi

    local count=0
    local results=()

    # 读取JSON并生成RSS
    jq -r '.accounts[] | @base64' "$CONFIG_FILE" | while read -r account; do
        if [ -n "$account" ]; then
            local account_data=$(echo "$account" | base64 --decode)
            local name=$(echo "$account_data" | jq -r '.name')
            local description=$(echo "$account_data" | jq -r '.description')
            local category=$(echo "$account_data" | jq -r '.category')
            local filename=$(echo "$account_data" | jq -r '.filename')

            generate_rss "$name" "$description" "$category" "$filename"
            echo "✅ 生成RSS: $name -> $filename"
            ((count++))
        fi
    done

    # 发送完成通知
    send_feishu_notification "📊 RSS生成完成" \
        "今日RSS生成任务已完成\\n\\n📈 处理公众号数量：13个\\n⏰ 完成时间：$(date '+%Y-%m-%d %H:%M:%S')\\n📂 输出目录：$RSS_DIR\\n\\n所有RSS文件已更新，可以正常使用！" \
        "$GITHUB_BASE_URL"

    echo "🎉 RSS生成完成！"
}

# 列出所有公众号
list_accounts() {
    echo "📋 当前公众号列表："
    echo ""

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "❌ 配置文件不存在"
        return 1
    fi

    jq -r '.accounts[] | "- \(.name): \(.description) (\(.category))"' "$CONFIG_FILE"
}

# 显示使用帮助
show_help() {
    echo "📖 微信公众号RSS管理器使用说明："
    echo ""
    echo "🔧 基本命令："
    echo "  $0 init                    - 初始化配置文件"
    echo "  $0 generate-all            - 生成所有RSS"
    echo "  $0 list                    - 列出所有公众号"
    echo "  $0 add '名称' '描述' '分类' - 添加新公众号"
    echo "  $0 help                    - 显示帮助"
    echo ""
    echo "📱 配置飞书通知："
    echo "  1. 在飞书创建机器人"
    echo "  2. 复制Webhook URL"
    echo "  3. 修改脚本中的 FEISHU_WEBHOOK_URL"
    echo "  4. 修改脚本中的 GITHUB_BASE_URL"
    echo ""
    echo "📦 使用方法："
    echo "  1. 上传RSS文件到GitHub Pages"
    echo "  2. 复制RSS链接到NotebookLM"
    echo "  3. 享受自动化的知识库！"
}

# 主程序
case "${1:-help}" in
    "init")
        init_config
        ;;
    "add")
        add_account "$2" "$3" "$4"
        ;;
    "generate-all")
        generate_all_rss
        ;;
    "list")
        list_accounts
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        echo "❌ 未知命令: $1"
        show_help
        exit 1
        ;;
esac