#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// 生成主页面
function generateIndexHTML(accounts) {
  const activeAccounts = accounts.filter(acc => acc.active !== false);
  const categories = {};

  // 按分类分组
  activeAccounts.forEach(account => {
    if (!categories[account.category]) {
      categories[account.category] = [];
    }
    categories[account.category].push(account);
  });

  let indexHTML = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>微信公众号RSS订阅源</title>
    <meta name="description" content="自动生成的微信公众号RSS订阅源，专为NotebookLM优化">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f8f9fa;
            line-height: 1.6;
        }
        .container { max-width: 1000px; margin: 0 auto; }
        .header {
            text-align: center;
            margin-bottom: 40px;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header h1 { margin: 0; color: #333; font-size: 2.5em; }
        .header p { margin: 10px 0 0 0; color: #666; font-size: 1.1em; }
        .stats {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-around;
            text-align: center;
        }
        .stat-item { flex: 1; }
        .stat-number { font-size: 2em; font-weight: bold; display: block; }
        .categories {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 30px;
            justify-content: center;
        }
        .category-tag {
            background: #e3f2fd;
            color: #1976d2;
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
        }
        .category-tag:hover {
            background: #1976d2;
            color: white;
            transform: translateY(-2px);
        }
        .account-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
        }
        .account-card {
            background: white;
            border: 1px solid #e1e5e9;
            border-radius: 12px;
            padding: 25px;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .account-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }
        .account-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }
        .account-desc {
            color: #666;
            margin-bottom: 12px;
            line-height: 1.5;
        }
        .account-category {
            display: inline-block;
            background: #f3f4f6;
            color: #374151;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            margin-bottom: 15px;
        }
        .rss-link {
            display: inline-flex;
            align-items: center;
            background: linear-gradient(135deg, #4caf50, #45a049);
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .rss-link:hover {
            background: linear-gradient(135deg, #45a049, #3d8b40);
            transform: translateY(-1px);
        }
        .actions {
            text-align: center;
            margin: 40px 0;
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn {
            background: linear-gradient(135deg, #2196f3, #1976d2);
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        .btn:hover {
            background: linear-gradient(135deg, #1976d2, #1565c0);
            transform: translateY(-2px);
        }
        .btn-secondary {
            background: linear-gradient(135deg, #ff9800, #f57c00);
        }
        .btn-secondary:hover {
            background: linear-gradient(135deg, #f57c00, #ef6c00);
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            color: #666;
            font-size: 14px;
            background: white;
            padding: 20px;
            border-radius: 8px;
        }
        .update-info {
            background: #e8f5e8;
            color: #2e7d32;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #4caf50;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📡 微信公众号RSS订阅源</h1>
            <p>自动生成，专为NotebookLM和RSS阅读器优化</p>
        </div>

        <div class="update-info">
            <strong>🔄 最后更新:</strong> ${new Date().toLocaleString('zh-CN')}
        </div>

        <div class="stats">
            <div class="stat-item">
                <span class="stat-number">${activeAccounts.length}</span>
                <span>活跃公众号</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${Object.keys(categories).length}</span>
                <span>内容分类</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">每日</span>
                <span>自动更新</span>
            </div>
        </div>

        <div class="categories">`;

    Object.keys(categories).forEach(category => {
      const categoryNames = {
        'finance': '投资理财',
        'tech': '科技前沿',
        'ai_tech': 'AI技术',
        'personal_growth': '个人成长',
        'career': '职场发展',
        'business': '商业创业',
        'product': '产品运营',
        'learning': '学习方法',
        'mindset': '思维认知',
        'future_tech': '未来趋势',
        'lifestyle': '生活方式',
        'other': '其他'
      };

      const displayName = categoryNames[category] || category;
      const count = categories[category].length;

      indexHTML += `
            <a href="./categories/${category}.html" class="category-tag">
                ${displayName} (${count})
            </a>`;
    });

    indexHTML += `
        </div>

        <div class="account-grid">`;

    activeAccounts.forEach(account => {
      indexHTML += `
            <div class="account-card">
                <div class="account-name">${account.name}</div>
                <div class="account-category">${account.category}</div>
                <div class="account-desc">${account.description || '优质的微信公众号内容'}</div>
                <a href="./rss/${account.rss_filename}" class="rss-link">
                    📄 RSS订阅
                </a>
            </div>`;
    });

    indexHTML += `
        </div>

        <div class="actions">
            <a href="./add-account.html" class="btn">
                ➕ 添加新公众号
            </a>
            <a href="./export.html" class="btn btn-secondary">
                📥 导出订阅列表
            </a>
        </div>

        <div class="footer">
            <p>
                <strong>使用说明：</strong><br>
                • 复制RSS链接到NotebookLM或RSS阅读器<br>
                • 所有RSS源每日自动更新<br>
                • 支持所有标准RSS客户端<br>
                • <a href="./stats.html" style="color: #2196f3;">查看详细统计</a>
            </p>
            <p style="margin-top: 10px;">
                🤖 自动生成于 ${new Date().toLocaleDateString('zh-CN')} | 由 n8n + GitHub Actions 驱动
            </p>
        </div>
    </div>
</body>
</html>`;

  return indexHTML;
}

// 生成分类页面
function generateCategoryPages(accounts) {
  const activeAccounts = accounts.filter(acc => acc.active !== false);
  const categories = {};

  // 按分类分组
  activeAccounts.forEach(account => {
    if (!categories[account.category]) {
      categories[account.category] = [];
    }
    categories[account.category].push(account);
  });

  const categoryPages = {};

  Object.keys(categories).forEach(category => {
    const categoryNames = {
      'finance': '投资理财',
      'tech': '科技前沿',
      'ai_tech': 'AI技术',
      'personal_growth': '个人成长',
      'career': '职场发展',
      'business': '商业创业',
      'product': '产品运营',
      'learning': '学习方法',
      'mindset': '思维认知',
      'future_tech': '未来趋势',
      'lifestyle': '生活方式',
      'other': '其他'
    };

    const displayName = categoryNames[category] || category;
    const accountsInCategory = categories[category];

    let html = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${displayName} - 微信公众号RSS</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
            background: #f8f9fa;
        }
        .container { max-width: 800px; margin: 0 auto; }
        .header {
            text-align: center;
            margin-bottom: 30px;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header h1 { margin: 0; color: #333; }
        .header p { margin: 10px 0 0 0; color: #666; }
        .back-link {
            margin-bottom: 20px;
            display: inline-block;
            background: #f3f4f6;
            color: #374151;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s;
        }
        .back-link:hover { background: #e5e7eb; }
        .account-list {
            display: grid;
            gap: 15px;
        }
        .account-item {
            background: white;
            border: 1px solid #e1e5e9;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .account-item:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: translateY(-3px);
        }
        .account-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }
        .account-desc {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        .rss-link {
            display: inline-flex;
            align-items: center;
            background: linear-gradient(135deg, #4caf50, #45a049);
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .rss-link:hover {
            background: linear-gradient(135deg, #45a049, #3d8b40);
            transform: translateY(-1px);
        }
        .stats {
            background: #e3f2fd;
            color: #1976d2;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="../index.html" class="back-link">← 返回首页</a>

        <div class="header">
            <h1>${displayName}</h1>
            <p>共 ${accountsInCategory.length} 个公众号</p>
        </div>

        <div class="stats">
            📊 本分类包含 ${accountsInCategory.length} 个高质量公众号
        </div>

        <div class="account-list">`;

    accountsInCategory.forEach(account => {
      html += `
            <div class="account-item">
                <div class="account-name">${account.name}</div>
                <div class="account-desc">${account.description || '优质的微信公众号内容'}</div>
                <a href="../rss/${account.rss_filename}" class="rss-link">
                    📄 RSS订阅
                </a>
            </div>`;
    });

    html += `
        </div>
    </div>
</body>
</html>`;

    categoryPages[category] = html;
  });

  return categoryPages;
}

// 主函数
async function main() {
  try {
    console.log('开始生成索引页面...');

    // 读取配置文件
    const configPath = path.join(__dirname, '../../wechat-rss-config.json');
    if (!fs.existsSync(configPath)) {
      console.error('配置文件不存在:', configPath);
      process.exit(1);
    }

    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    const accounts = config.accounts;

    console.log(`找到 ${accounts.length} 个公众号`);

    // 生成主页面
    const indexHTML = generateIndexHTML(accounts);
    fs.writeFileSync(path.join(__dirname, '../../index.html'), indexHTML, 'utf8');
    console.log('✅ 已生成主页面');

    // 创建分类目录并生成分类页面
    const categoriesDir = path.join(__dirname, '../../categories');
    if (!fs.existsSync(categoriesDir)) {
      fs.mkdirSync(categoriesDir, { recursive: true });
    }

    const categoryPages = generateCategoryPages(accounts);
    Object.keys(categoryPages).forEach(category => {
      const categoryPath = path.join(categoriesDir, `${category}.html`);
      fs.writeFileSync(categoryPath, categoryPages[category], 'utf8');
      console.log(`✅ 已生成分类页面: ${category}`);
    });

    console.log('✅ 索引页面生成完成!');

  } catch (error) {
    console.error('❌ 生成索引页面失败:', error);
    process.exit(1);
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  main();
}

module.exports = { generateIndexHTML, generateCategoryPages };