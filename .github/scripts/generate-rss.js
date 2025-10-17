#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// RSS生成函数
function generateRSS(articles, accountInfo) {
  const currentDate = new Date().toISOString();

  const rssHeader = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title><![CDATA[${accountInfo.name} - 微信公众号文章]]></title>
    <description><![CDATA[${accountInfo.description} - 来自微信公众号的RSS订阅]]></description>
    <link>https://mp.weixin.qq.com</link>
    <language>zh-CN</language>
    <lastBuildDate>${currentDate}</lastBuildDate>
    <generator>WeChat RSS Generator</generator>
    <category>${accountInfo.category}</category>`;

  const rssItems = articles.map(article => `
    <item>
      <title><![CDATA[${article.title}]]></title>
      <description><![CDATA[${article.description || article.summary}]]></description>
      <link>${article.url}</link>
      <guid>${article.url}</guid>
      <pubDate>${new Date(article.publishTime).toISOString()}</pubDate>
      <dc:creator><![CDATA[${accountInfo.name}]]></dc:creator>
      <content:encoded><![CDATA[${article.content || article.description}]]></content:encoded>
    </item>`).join('\n');

  const rssFooter = `
  </channel>
</rss>`;

  return rssHeader + rssItems + rssFooter;
}

// 模拟文章数据获取（实际使用时替换为真实的API调用）
async function fetchArticles(accountInfo) {
  // 这里应该调用真实的API来获取文章
  // 暂时返回模拟数据
  return [
    {
      title: `${accountInfo.name} - 最新文章标题`,
      description: '这是文章描述内容...',
      url: 'https://mp.weixin.qq.com/s/xxxxxx',
      publishTime: new Date().toISOString(),
      content: '这是文章的完整内容...'
    }
  ];
}

// 主函数
async function main() {
  try {
    console.log('开始生成RSS feeds...');

    // 读取配置文件
    const configPath = path.join(__dirname, '../../wechat-rss-config.json');
    if (!fs.existsSync(configPath)) {
      console.error('配置文件不存在:', configPath);
      process.exit(1);
    }

    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    const accounts = config.accounts.filter(acc => acc.active !== false);

    console.log(`找到 ${accounts.length} 个活跃公众号`);

    // 确保rss目录存在
    const rssDir = path.join(__dirname, '../../rss');
    if (!fs.existsSync(rssDir)) {
      fs.mkdirSync(rssDir, { recursive: true });
    }

    // 为每个公众号生成RSS
    for (const account of accounts) {
      try {
        console.log(`正在处理: ${account.name}`);

        // 获取文章数据
        const articles = await fetchArticles(account);

        if (articles.length > 0) {
          // 生成RSS内容
          const rssContent = generateRSS(articles, account);

          // 保存RSS文件
          const rssPath = path.join(rssDir, account.rss_filename);
          fs.writeFileSync(rssPath, rssContent, 'utf8');

          console.log(`✅ 已生成: ${account.rss_filename} (${articles.length} 篇文章)`);
        } else {
          console.log(`⚠️  ${account.name}: 没有找到文章`);
        }
      } catch (error) {
        console.error(`❌ ${account.name} 处理失败:`, error.message);
      }
    }

    // 生成账号列表JSON文件
    const accountsJson = JSON.stringify(accounts, null, 2);
    fs.writeFileSync(path.join(__dirname, '../../accounts.json'), accountsJson, 'utf8');

    console.log('✅ RSS feeds 生成完成!');

  } catch (error) {
    console.error('❌ 生成RSS失败:', error);
    process.exit(1);
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  main();
}

module.exports = { generateRSS, fetchArticles };