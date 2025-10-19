#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
微信公众号文章抓取工具
通过搜狗微信搜索获取公众号历史文章
"""

import requests
from bs4 import BeautifulSoup
import json
import time
import random
from datetime import datetime, timedelta
import re
from urllib.parse import quote

class WeChatArticleScraper:
    def __init__(self):
        self.session = requests.Session()
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
        }
        self.session.headers.update(self.headers)

    def search_articles_by_account(self, account_name, max_pages=5):
        """
        通过搜狗微信搜索获取公众号文章

        Args:
            account_name: 公众号名称
            max_pages: 最大搜索页数

        Returns:
            list: 文章列表
        """
        articles = []
        base_url = "https://weixin.sogou.com/weixin"

        for page in range(1, max_pages + 1):
            try:
                # 构建搜索URL
                params = {
                    'query': account_name,
                    'type': 2,  # 文章搜索
                    'page': page,
                    'ie': 'utf8'
                }

                print(f"正在搜索第 {page} 页...")

                # 发送请求
                response = self.session.get(base_url, params=params, timeout=10)
                response.raise_for_status()

                # 解析HTML
                soup = BeautifulSoup(response.text, 'html.parser')

                # 查找文章列表
                news_items = soup.find_all('div', class_='news-box')

                if not news_items:
                    print(f"第 {page} 页没有找到文章，停止搜索")
                    break

                # 提取文章信息
                for item in news_items:
                    try:
                        article = self.extract_article_info(item)
                        if article:
                            articles.append(article)
                    except Exception as e:
                        print(f"提取文章信息时出错: {e}")
                        continue

                # 随机延迟，避免被封
                time.sleep(random.uniform(2, 5))

                print(f"第 {page} 页完成，找到 {len(news_items)} 篇文章")

            except requests.RequestException as e:
                print(f"请求第 {page} 页时出错: {e}")
                break
            except Exception as e:
                print(f"处理第 {page} 页时出错: {e}")
                break

        return articles

    def extract_article_info(self, item):
        """
        提取单篇文章信息

        Args:
            item: BeautifulSoup元素

        Returns:
            dict: 文章信息
        """
        try:
            # 标题
            title_elem = item.find('h3')
            if not title_elem:
                return None

            title = title_elem.get_text(strip=True)

            # 链接
            link_elem = title_elem.find('a')
            if not link_elem:
                return None

            link = link_elem.get('href', '')

            # 摘要
            content_elem = item.find('p', class_='txt-info')
            if not content_elem:
                content = title
            else:
                content = content_elem.get_text(strip=True)

            # 时间
            time_elem = item.find('span', class_='s2')
            if time_elem:
                time_text = time_elem.get_text(strip=True)
                pub_date = self.parse_time(time_text)
            else:
                pub_date = datetime.now()

            # 来源
            source_elem = item.find('a', class_='account')
            source = source_elem.get_text(strip=True) if source_elem else ""

            return {
                'title': title,
                'link': link,
                'description': content,
                'pub_date': pub_date.strftime('%Y-%m-%d %H:%M:%S'),
                'source': source
            }

        except Exception as e:
            print(f"提取文章信息时出错: {e}")
            return None

    def parse_time(self, time_text):
        """
        解析时间文本

        Args:
            time_text: 时间文本

        Returns:
            datetime: 解析后的时间
        """
        try:
            # 处理各种时间格式
            time_text = time_text.strip()

            # 刚刚
            if '刚刚' in time_text:
                return datetime.now()

            # 分钟前
            if '分钟前' in time_text:
                minutes = re.search(r'(\d+)分钟前', time_text)
                if minutes:
                    return datetime.now() - timedelta(minutes=int(minutes.group(1)))

            # 小时前
            if '小时前' in time_text:
                hours = re.search(r'(\d+)小时前', time_text)
                if hours:
                    return datetime.now() - timedelta(hours=int(hours.group(1)))

            # 天前
            if '天前' in time_text:
                days = re.search(r'(\d+)天前', time_text)
                if days:
                    return datetime.now() - timedelta(days=int(days.group(1)))

            # 标准日期格式
            date_patterns = [
                r'(\d{4})-(\d{1,2})-(\d{1,2})',
                r'(\d{1,2})月(\d{1,2})日',
                r'(\d{1,2})/(\d{1,2})/(\d{4})'
            ]

            for pattern in date_patterns:
                match = re.search(pattern, time_text)
                if match:
                    if len(match.groups()) == 3:
                        year, month, day = match.groups()
                    else:
                        month, day = match.groups()
                        year = datetime.now().year

                    return datetime(int(year), int(month), int(day))

            # 默认返回当前时间
            return datetime.now()

        except Exception:
            return datetime.now()

    def generate_rss(self, articles, account_name, filename):
        """
        生成RSS文件

        Args:
            articles: 文章列表
            account_name: 公众号名称
            filename: 输出文件名
        """
        rss_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>{account_name} - 微信公众号文章</title>
    <description>{account_name}的微信公众号文章精选</description>
    <link>https://mp.weixin.qq.com</link>
    <language>zh-CN</language>
    <lastBuildDate>{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</lastBuildDate>
    <generator>微信公众号文章抓取工具</generator>
"""

        # 添加文章
        for article in articles:
            rss_content += f"""
    <item>
      <title>{self.escape_xml(article['title'])}</title>
      <description>{self.escape_xml(article['description'])}</description>
      <link>{article['link']}</link>
      <guid>{article['link']}</guid>
      <pubDate>{article['pub_date']}</pubDate>
      <author>{self.escape_xml(article['source'])}</author>
    </item>"""

        rss_content += """
  </channel>
</rss>"""

        # 写入文件
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(rss_content)

        print(f"RSS文件已生成: {filename}")

    def escape_xml(self, text):
        """
        转义XML特殊字符

        Args:
            text: 原始文本

        Returns:
            str: 转义后的文本
        """
        if not text:
            return ""

        text = text.replace('&', '&amp;')
        text = text.replace('<', '&lt;')
        text = text.replace('>', '&gt;')
        text = text.replace('"', '&quot;')
        text = text.replace("'", '&apos;')

        return text

def main():
    """
    主函数
    """
    scraper = WeChatArticleScraper()

    # 要搜索的公众号列表
    accounts = [
        "孟岩",
        "辉哥奇谭",
        "金渐成",
        "自我的SZ",
        "生财有术",
        "刘小排r",
        "哥飞",
        "丹喵的无限游戏",
        "成甲",
        "数字生命卡兹克",
        "孤独大脑",
        "也谈钱",
        "饼干哥哥AGI"
    ]

    print("微信公众号文章抓取工具")
    print("=" * 50)

    for account in accounts:
        print(f"\n开始搜索公众号: {account}")

        try:
            # 搜索文章
            articles = scraper.search_articles_by_account(account, max_pages=3)

            if articles:
                print(f"找到 {len(articles)} 篇文章")

                # 生成RSS文件
                safe_name = re.sub(r'[^\w\-_.]', '', account)
                filename = f"rss/{safe_name}.xml"

                scraper.generate_rss(articles, account, filename)

                print(f"RSS文件已保存: {filename}")
            else:
                print(f"没有找到 {account} 的文章")

        except Exception as e:
            print(f"处理 {account} 时出错: {e}")

        # 随机延迟
        time.sleep(random.uniform(3, 6))

    print("\n所有公众号搜索完成！")

if __name__ == "__main__":
    main()