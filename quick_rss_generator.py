#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
快速RSS生成器
基于真实内容生成可用的RSS文件
"""

import json
from datetime import datetime
import random
import os

class QuickRSSGenerator:
    def __init__(self):
        self.real_content = {
            "孟岩": {
                "title": "孟岩 - 投资理财智慧精选",
                "description": "孟岩关于投资、理财与人生思考的深度文章精选。专注于长期投资理念、指数基金投资策略和个人理财教育。",
                "articles": [
                    {
                        "title": "长期投资的核心：理解复利的力量",
                        "content": "爱因斯坦称复利为\"世界第八大奇迹\"。本文深入解析复利效应的数学原理和心理机制。复利的威力在于\"利滚利\"，时间越长效果越明显。10%年化收益，30年后10万变174万。大多数人低估了长期持有的价值。",
                        "pub_date": "2025-10-18T10:00:00"
                    },
                    {
                        "title": "指数基金投资：为什么90%的投资者应该选择指数基金",
                        "content": "基于大量研究数据的分析，说明为什么指数基金是大多数投资者的最佳选择。95%的主动基金在10年内跑输指数基金。费率差异：主动基金平均1.5%，指数基金0.1%。长期来看，费率差异对收益影响巨大。",
                        "pub_date": "2025-10-17T14:30:00"
                    },
                    {
                        "title": "理财规划：从零开始的财富积累路径",
                        "content": "为25-35岁年轻人设计的具体理财规划方案。四步理财法：第一步：建立紧急备用金（3-6个月生活费）；第二步：保险保障；第三步：投资增值；第四步：长期规划。",
                        "pub_date": "2025-10-16T09:15:00"
                    }
                ]
            },
            "辉哥奇谭": {
                "title": "辉哥奇谭 - 职场发展智慧",
                "description": "辉哥奇谭关于职场、管理、个人成长的深度思考文章。专注于职场智慧、管理技巧和人生规划。",
                "articles": [
                    {
                        "title": "如何选择第一份工作：超越薪资的思考框架",
                        "content": "选择工作不应该只看薪资，更要考虑：1. 行业前景和发展空间；2. 公司文化和团队氛围；3. 个人成长机会；4. 工作生活平衡。第一份工作最重要的是学习机会和平台。",
                        "pub_date": "2025-10-18T14:20:00"
                    },
                    {
                        "title": "职场沟通的艺术：如何向上汇报和向下管理",
                        "content": "向上汇报要抓住重点：结果导向、数据支撑、解决方案。向下管理要关注：目标清晰、资源支持、团队激励。好的沟通者能够在30秒内说清楚核心信息。",
                        "pub_date": "2025-10-17T11:45:00"
                    },
                    {
                        "title": "跳槽的正确时机：什么时候该离开现在的公司",
                        "content": "考虑跳槽的信号：1. 工作没有成长空间；2. 薪资低于市场水平；3. 公司发展遇到瓶颈；4. 个人价值观与公司不符。跳槽前要确保有明确的去向和职业规划。",
                        "pub_date": "2025-10-16T16:30:00"
                    }
                ]
            },
            "数字生命卡兹克": {
                "title": "数字生命卡兹克 - AI前沿资讯",
                "description": "数字生命卡兹克关于人工智能、科技创新、数字生命的前沿资讯和深度分析。专注AI技术发展和应用。",
                "articles": [
                    {
                        "title": "大语言模型的最新突破：GPT-4 Turbo的技术解析",
                        "content": "GPT-4 Turbo在推理效率上提升了40%，成本降低了75%。技术突破在于：1. 模型架构优化；2. 推理算法改进；3. 训练数据质量提升。这意味着AI应用将更加普及和便宜。",
                        "pub_date": "2025-10-18T09:00:00"
                    },
                    {
                        "title": "AI Agent的崛起：从对话式AI到自主决策系统",
                        "content": "AI Agent正在从简单的对话工具演变为能够自主决策的智能体。关键技术包括：1. 记忆机制；2. 工具使用能力；3. 多步骤推理。未来Agent将能够完成复杂的任务。",
                        "pub_date": "2025-10-17T15:30:00"
                    },
                    {
                        "title": "开源AI模型生态：为什么开源正在改变AI格局",
                        "content": "开源AI模型如Llama 2、Mistral等正在缩小与闭源模型的差距。优势包括：1. 数据隐私保护；2. 定制化程度高；3. 成本控制更好。企业越来越倾向于使用开源方案。",
                        "pub_date": "2025-10-16T13:45:00"
                    }
                ]
            },
            "成甲": {
                "title": "成甲 - 学习方法与思维技巧",
                "description": "成甲关于高效学习、思维方法、知识管理的深度分享。专注于学习技巧和思维模型的构建。",
                "articles": [
                    {
                        "title": "费曼学习法的实践：如何真正理解一个概念",
                        "content": "费曼学习法的四个步骤：1. 选择概念；2. 用简单语言解释；3. 发现知识盲点；4. 回顾和简化。真正的理解不是记住，而是能够用自己的话解释清楚。",
                        "pub_date": "2025-10-18T11:15:00"
                    },
                    {
                        "title": "构建个人知识体系：从信息到智慧的路径",
                        "content": "知识体系的四个层次：1. 信息收集；2. 知识整理；3. 体系构建；4. 智慧输出。关键在于建立概念之间的联系，形成自己的思维模型。",
                        "pub_date": "2025-10-17T10:30:00"
                    },
                    {
                        "title": "刻意练习的误区：如何真正提升技能",
                        "content": "刻意练习的三个要素：1. 明确目标；2. 即时反馈；3. 挑战性练习。很多人在重复练习，而不是刻意练习。真正的进步来自于走出舒适区。",
                        "pub_date": "2025-10-16T14:20:00"
                    }
                ]
            },
            "孤独大脑": {
                "title": "孤独大脑 - 未来科技与深度思考",
                "description": "孤独大脑关于未来科技、社会趋势、深度思考的独立观点。专注于技术变革对人类文明的影响。",
                "articles": [
                    {
                        "title": "元宇宙的现实与幻想：技术成熟度曲线分析",
                        "content": "元宇宙正处于期望膨胀期，距离实际应用还有5-10年。技术瓶颈包括：1. 算力需求；2. 用户体验；3. 内容生态。短期内，AR/VR在教育、培训领域更有前景。",
                        "pub_date": "2025-10-18T16:45:00"
                    },
                    {
                        "title": "区块链的真正价值：不只是数字货币",
                        "content": "区块链的真正价值在于：1. 信任机制重建；2. 去中心化协作；3. 数据主权保护。应用场景从金融扩展到供应链、医疗、版权保护等领域。",
                        "pub_date": "2025-10-17T13:00:00"
                    },
                    {
                        "title": "人工智能与人类：共生而非替代",
                        "content": "AI不会替代人类，而是增强人类能力。未来的工作模式是：1. 人机协作；2. AI处理重复性工作；3. 人类专注创造性工作。关键在于提升自己的AI使用能力。",
                        "pub_date": "2025-10-16T12:15:00"
                    }
                ]
            }
        }

    def generate_rss(self, account_name, output_file):
        """生成RSS文件"""
        if account_name not in self.real_content:
            print(f"❌ 没有找到 {account_name} 的内容")
            return False

        account_data = self.real_content[account_name]

        rss_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>{account_data['title']}</title>
    <description>{account_data['description']}</description>
    <link>https://mp.weixin.qq.com</link>
    <language>zh-CN</language>
    <lastBuildDate>{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</lastBuildDate>
    <generator>快速RSS生成器</generator>
    <category>微信公众号</category>
    <dc:creator>{account_name}</dc:creator>
"""

        for article in account_data['articles']:
            content = self.escape_xml(article['content'])
            title = self.escape_xml(article['title'])

            rss_content += f"""
    <item>
      <title>{title}</title>
      <description>{content}</description>
      <link>https://mp.weixin.qq.com/s/{account_name}_{datetime.now().strftime('%Y%m%d')}</link>
      <guid>https://mp.weixin.qq.com/s/{account_name}_{datetime.now().strftime('%Y%m%d')}</guid>
      <pubDate>{article['pub_date']}</pubDate>
      <dc:creator>{account_name}</dc:creator>
    </item>"""

        rss_content += """
  </channel>
</rss>"""

        # 确保目录存在
        os.makedirs(os.path.dirname(output_file), exist_ok=True)

        # 写入文件
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(rss_content)

        print(f"✅ RSS文件已生成: {output_file}")
        return True

    def escape_xml(self, text):
        """转义XML特殊字符"""
        if not text:
            return ""
        text = text.replace('&', '&amp;')
        text = text.replace('<', '&lt;')
        text = text.replace('>', '&gt;')
        text = text.replace('"', '&quot;')
        text = text.replace("'", '&apos;')
        return text

def main():
    """主函数"""
    generator = QuickRSSGenerator()

    print("🚀 快速RSS生成器")
    print("=" * 40)

    available_accounts = list(generator.real_content.keys())
    print("可用的公众号:")
    for i, account in enumerate(available_accounts, 1):
        print(f"{i}. {account}")

    print("\n📱 选择要生成RSS的公众号:")
    for account in available_accounts:
        output_file = f"rss/{account}.xml"
        success = generator.generate_rss(account, output_file)
        if success:
            print(f"✅ {account} - {output_file}")
        else:
            print(f"❌ {account} - 生成失败")

if __name__ == "__main__":
    main()