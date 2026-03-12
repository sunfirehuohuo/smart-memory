---
name: smart-memory
description: 智能记忆管理系统 - 分层存储、自动归档、智能检索、自动摘要、关联记忆、优先级管理
version: 2.0.0
---

# Smart Memory - 智能记忆管理

分层管理AI记忆，自动归档，智能检索，自动摘要，关联记忆，优先级管理。

## 核心功能

### ✅ 1. 分层存储
- **L1 核心记忆**: MEMORY.md (< 2KB)
- **L2 短期记忆**: 今日记忆 (< 5KB)
- **L3 历史档案**: archive/ (按需读取)

### ✅ 2. 自动归档
- 每天自动归档昨日记忆
- 每周自动清理旧文件
- 保留最近7天在根目录

### ✅ 3. 智能检索
- 关键词搜索历史记忆
- 语义相似度匹配
- 模糊搜索支持

### ✅ 4. 自动摘要
- 长文档自动摘要
- 关键信息提取
- 摘要缓存优化

### ✅ 5. 关联记忆
- 标签系统自动关联
- 主题聚类
- 时间线关联

### ✅ 6. 优先级管理
- P0/P1/P2/P3 四级优先级
- 高优先级记忆优先保留
- 自动清理低优先级旧记忆

---

## 快速开始

### 1. 安装
```bash
npx skills add ~/.agents/skills/smart-memory --skill smart-memory --yes --global
```

### 2. 初始化
```bash
# 运行初始化脚本
. ~/.agents/skills/smart-memory/scripts/init.ps1
Init-SmartMemory
```

### 3. 配置自动归档
在 HEARTBEAT.md 中添加：
```markdown
## 自动归档任务
每24小时执行一次：
- Archive-OldMemories -DaysToKeep 7
- Update-MemoryIndex
- Clean-LowPriorityMemories -DaysOld 30
```

---

## 功能详解

### 1. 分层存储

**MEMORY.md 模板：**
```markdown
# MEMORY.md

## 身份
- **名字**: 淼淼 💧
- **角色**: 创意总监
- **模型**: DeepSeek-V3.2-Thinking

## 当前任务 (P0)
- [ ] 灵犀网测试验证
- [ ] 进度: 等待修复

## 关键决策
- 采用分层记忆管理策略

## 标签
#project/lingxiwang #skill/development
```

**今日记忆模板：**
```markdown
# 2026-03-09

## 完成的工作
1. ✅ 完成UI设计
2. ✅ 配置环境变量

## 遇到的问题
- 淼淼会话上下文超限
- 已清理 memory 文件

## 明日计划
- 验证灵犀网修复结果

## 标签
#urgent #verification
```

---

### 2. 自动归档

**配置选项：**
```json
{
  "smartMemory": {
    "autoArchive": {
      "enabled": true,
      "schedule": "0 0 * * *",
      "daysToKeep": 7,
      "archivePath": "memory/archive"
    }
  }
}
```

**归档规则：**
- 每天凌晨自动归档
- 保留最近7天在根目录
- 超过30天的低优先级记忆自动删除
- 高优先级记忆永久保留

---

### 3. 智能检索

**使用方法：**
```javascript
// 关键词搜索
Search-Memory -Keyword "灵犀网"

// 语义搜索
Search-Memory -Query "协作平台开发进度" -Semantic

// 标签搜索
Search-Memory -Tag "project/lingxiwang"

// 时间范围搜索
Search-Memory -From "2026-03-01" -To "2026-03-09"
```

**搜索结果：**
```json
{
  "results": [
    {
      "file": "archive/2026-03-09.md",
      "relevance": 0.95,
      "excerpt": "灵犀网UI设计已完成...",
      "tags": ["project/lingxiwang", "ui-design"]
    }
  ]
}
```

---

### 4. 自动摘要

**摘要生成：**
```javascript
// 为长文档生成摘要
Summarize-Memory -File "archive/2026-03-09.md" -MaxLength 500

// 批量摘要
Get-ChildItem "archive/*.md" | ForEach-Object {
  Summarize-Memory -File $_.FullName -SaveTo "archive/summaries/"
}
```

**摘要格式：**
```markdown
# 2026-03-09 摘要

## 关键信息
- 完成灵犀网UI设计 (P0)
- 修复淼淼会话上下文问题
- 配置 DeepSeek 备用API

## 关键决策
- 采用分层记忆管理

## 下一步
- 验证灵犀网修复结果

---
*原文: archive/2026-03-09.md (118KB)*
*摘要: 1.2KB*
*压缩率: 99%*
```

---

### 5. 关联记忆

**标签系统：**
```markdown
# 记忆文件示例

## 工作内容
...

## 标签
#project/lingxiwang      ← 项目标签
#type/ui-design          ← 类型标签
#priority/P0             ← 优先级标签
#people/yiyi             ← 相关人物
#tech/react              ← 技术标签
```

**自动关联：**
```javascript
// 获取相关记忆
Get-RelatedMemories -File "2026-03-09.md"

// 返回关联文件
[
  "archive/2026-03-08.md",    // 时间关联
  "projects/lingxiwang.md",   // 项目关联
  "skills/ui-design.md"       // 技能关联
]
```

**关联图谱：**
```
[2026-03-09.md] ←时间→ [2026-03-08.md]
       ↓
   项目关联
       ↓
[projects/lingxiwang.md] ←技术→ [skills/react.md]
       ↓
   人物关联
       ↓
  [people/yiyi.md]
```

---

### 6. 优先级管理

**优先级标记：**
```markdown
## 任务列表

### P0 - 紧急重要
- [ ] 验证灵犀网修复 (今天必须完成)
- [ ] 修复会话上下文问题

### P1 - 重要不紧急
- [ ] 完成企业微信Skill测试
- [ ] 学习新的技能

### P2 - 紧急不重要
- [ ] 整理文档格式

### P3 - 不紧急不重要
- [ ] 优化代码风格
```

**自动清理策略：**
```json
{
  "cleanupRules": {
    "P0": { "keepDays": 365, "neverDelete": true },
    "P1": { "keepDays": 90 },
    "P2": { "keepDays": 30 },
    "P3": { "keepDays": 7 }
  }
}
```

**优先级保留：**
- P0: 永久保留，常驻上下文
- P1: 保留90天，摘要后归档
- P2: 保留30天，自动清理
- P3: 保留7天，自动删除

---

## 完整配置示例

```json
{
  "smartMemory": {
    "version": "2.0.0",
    
    "layers": {
      "L1": { "maxSize": "2KB", "file": "MEMORY.md" },
      "L2": { "maxSize": "5KB", "file": "memory/YYYY-MM-DD.md" },
      "L3": { "path": "memory/archive/" }
    },
    
    "autoArchive": {
      "enabled": true,
      "schedule": "0 0 * * *",
      "daysToKeep": 7,
      "cleanupEnabled": true
    },
    
    "smartSearch": {
      "enabled": true,
      "indexPath": "memory/.index/",
      "semanticSearch": true,
      "fuzzyMatch": true
    },
    
    "summarization": {
      "enabled": true,
      "autoSummarize": true,
      "minLength": 1000,
      "maxSummaryLength": 500
    },
    
    "tagging": {
      "enabled": true,
      "autoTag": true,
      "suggestedTags": [
        "project/*", "type/*", "priority/*",
        "people/*", "tech/*", "status/*"
      ]
    },
    
    "priority": {
      "levels": ["P0", "P1", "P2", "P3"],
      "defaultPriority": "P2",
      "cleanupRules": {
        "P0": { "keepDays": 365 },
        "P1": { "keepDays": 90 },
        "P2": { "keepDays": 30 },
        "P3": { "keepDays": 7 }
      }
    }
  }
}
```

---

## 使用场景

### 场景1：长期项目管理
```
用户: "灵犀网项目现在什么进度？"

AI: (智能检索)
1. 搜索关键词 "灵犀网"
2. 找到相关记忆: 2026-03-09.md, projects/lingxiwang.md
3. 自动加载并总结
4. 回复: "当前进度90%，燚燚正在修复消息显示问题..."
```

### 场景2：上下文溢出恢复
```
问题: 会话上下文 180%

解决:
1. 自动归档旧记忆
2. 生成摘要替代全文
3. 只保留核心在上下文
4. 恢复到 30%
```

### 场景3：跨会话记忆
```
昨天: 讨论企业微信配置
今天: 用户问 "配置好了吗？"

AI: (检索昨日记忆)
1. 搜索 "企业微信配置"
2. 找到昨日讨论
3. 回复: "昨天已完成配置，corpId=xxx，正在测试..."
```

---

## 故障排查

### Q: 智能检索找不到内容？
**A:** 检查是否已生成索引
```bash
Update-MemoryIndex
```

### Q: 自动归档没有运行？
**A:** 检查 HEARTBEAT.md 配置和 cron 设置

### Q: 摘要质量不好？
**A:** 调整 summarization.maxSummaryLength 参数

### Q: 关联记忆不准确？
**A:** 手动添加标签，训练自动标签系统

---

## 高级功能

### 记忆版本控制
```bash
# 查看记忆历史版本
Get-MemoryHistory -File "MEMORY.md"

# 回滚到某个版本
Restore-Memory -File "MEMORY.md" -Version "2026-03-09-10:30"
```

### 记忆导出/导入
```bash
# 导出所有记忆
Export-Memories -Path "backup/memories-2026-03-09.zip"

# 导入记忆
Import-Memories -Path "backup/memories-2026-03-09.zip"
```

### 多Agent记忆共享
```json
{
  "sharedMemory": {
    "enabled": true,
    "sharedPath": "/shared/memory/",
    "syncInterval": 3600
  }
}
```

---

**Smart Memory 2.0 - 让 AI 拥有无限记忆！** 🧠✨
