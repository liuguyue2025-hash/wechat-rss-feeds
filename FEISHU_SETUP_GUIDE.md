# 飞书Webhook配置指南

## 📱 步骤1：创建飞书自定义机器人

### 1.1 在飞书群中添加机器人
1. 打开您的飞书群聊
2. 点击右上角的 "..."
3. 选择 "设置" → "机器人"
4. 点击 "添加机器人"

### 1.2 创建自定义机器人
1. 选择 "自定义机器人"
2. 点击 "添加"
3. 填写机器人信息：
   - 机器人名称：`微信公众号RSS通知`
   - 描述：`自动通知新公众号添加和RSS链接更新`
4. 点击 "下一步"

### 1.3 获取Webhook URL
1. 复制显示的 **Webhook URL**（格式类似）：
   ```
   https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```
2. 保存这个URL，下一步需要用到

## ⚙️ 步骤2：配置RSS生成器

### 2.1 编辑配置文件
运行以下命令编辑脚本：

```bash
# 在项目目录下执行
nano wechat-rss-manager-lark.sh
```

### 2.2 修改Webhook配置
找到以下两行：
```bash
# 飞书配置（请修改为您的实际配置）
FEISHU_WEBHOOK_URL=""
GITHUB_BASE_URL="https://your-username.github.io/wechat-rss-feeds"
```

修改为：
```bash
# 飞书配置（请修改为您的实际配置）
FEISHU_WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/您的webhook-id"
GITHUB_BASE_URL="https://您的用户名.github.io/wechat-rss-feeds"
```

### 2.3 保存并退出
- 按 `Ctrl + X`
- 按 `Y` 确认保存
- 按 `Enter` 确认文件名

## 🧪 步骤3：测试飞书通知

### 3.1 测试添加新公众号
```bash
./wechat-rss-manager-lark.sh add "测试公众号" "这是一个测试" "test"
```

如果配置正确，您应该在飞书群中收到类似这样的通知：
```
🎉 新公众号已添加

📱 公众号：测试公众号
📝 描述：这是一个测试
🏷️  分类：test
🔗 RSS链接：https://您的用户名.github.io/wechat-rss-feeds/rss/测试公众号.xml

⏰ 添加时间：2025-10-17 14:20:30
```

### 3.2 测试RSS生成
```bash
./wechat-rss-manager-lark.sh generate-all
```

您应该收到：
```
✅ RSS生成完成

📊 生成统计：
- 公众号数量：16个
- RSS文件：16个
- 完成时间：2025-10-17 14:20:45

🔗 访问地址：https://您的用户名.github.io/wechat-rss-feeds
```

## 🔧 步骤4：高级配置（可选）

### 4.1 自定义通知消息
您可以在脚本中修改 `send_feishu_notification` 函数来自定义消息格式。

### 4.2 配置消息模板
```bash
# 在脚本中可以自定义这些变量
TITLE="🎉 微信公众号RSS更新"
AVATAR_URL="https://example.com/avatar.png"  # 机器人头像
```

### 4.3 通知类型
脚本支持以下通知：
- ✅ 添加新公众号
- 🚀 RSS生成完成
- ⚠️ 错误和警告

## 📋 步骤5：完整配置示例

### 5.1 最终配置示例
```bash
# 飞书配置（请修改为您的实际配置）
FEISHU_WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/69b8xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
GITHUB_BASE_URL="https://zhangsan.github.io/wechat-rss-feeds"
```

### 5.2 测试命令
```bash
# 添加新公众号（会触发飞书通知）
./wechat-rss-manager-lark.sh add "小道消息" "科技与创业资讯" "tech"

# 生成RSS（会触发飞书通知）
./wechat-rss-manager-lark.sh generate-all
```

## 🚨 故障排除

### 问题1：没有收到飞书通知
**可能原因：**
- Webhook URL输入错误
- 机器人没有正确添加到群聊
- 网络连接问题

**解决方法：**
1. 检查Webhook URL是否正确复制
2. 确认机器人在群聊中并启用
3. 手动测试Webhook：
   ```bash
   curl -X POST "您的webhook-url" \
        -H "Content-Type: application/json" \
        -d '{"msg_type":"text","content":{"text":"测试消息"}}'
   ```

### 问题2：消息格式异常
**可能原因：**
- JSON格式错误
- 特殊字符转义问题

**解决方法：**
1. 检查脚本中的JSON格式
2. 避免在公众号名称中使用特殊字符

### 问题3：GitHub链接错误
**解决方法：**
1. 确认GitHub用户名正确
2. 确认仓库名称正确
3. 确认GitHub Pages已启用

## 🎉 完成！

配置完成后，您将拥有：
- ✅ 自动飞书通知
- ✅ 新公众号添加提醒
- ✅ RSS生成完成通知
- ✅ 错误和警告通知

每次添加新公众号或生成RSS时，飞书群都会自动收到通知！