# Smart Memory 2.0 - 智能记忆管理

分层管理AI记忆，自动归档，智能检索，自动摘要，关联记忆，优先级管理。

## 🚀 快速安装

### 1. 安装 Skill
```bash
npx skills add ~/.agents/skills/smart-memory --skill smart-memory --yes --global
```

### 2. 初始化（一键设置）
```powershell
# 运行初始化脚本
. ~/.agents/skills/smart-memory/scripts/init.ps1
Init-SmartMemory
```

**这将自动创建：**
- ✅ `memory/` 目录结构
- ✅ `MEMORY.md` 核心记忆文件
- ✅ `archive/` 归档目录
- ✅ 索引和摘要缓存目录

### 3. 加载工具脚本
```powershell
# 加载所有功能
. ~/.agents/skills/smart-memory/scripts/smart-memory.ps1
```

### 4. 开始使用
```powershell
# 显示功能菜单
Show-SmartMemoryMenu

# 或执行完整维护
Invoke-FullMaintenance
```

---

## 📖 功能列表

### 1. 分层存储
```powershell
# 检查记忆分层状态
Check-MemoryLayers
```

### 2. 自动归档
```powershell
# 手动归档旧记忆
Archive-OldMemories -DaysToKeep 7
```

### 3. 智能检索
```powershell
# 关键词搜索
Search-Memory -Keyword "灵犀网"

# 标签搜索
Search-Memory -Tag "project/lingxiwang"

# 时间范围搜索
Search-Memory -From "2026-03-01" -To "2026-03-09"
```

### 4. 自动摘要
```powershell
# 为文件生成摘要
Summarize-Memory -File "archive/2026-03-09.md" -SaveToFile
```

### 5. 关联记忆
```powershell
# 查找相关记忆
Get-RelatedMemories -File "2026-03-09.md"
```

### 6. 优先级管理
```powershell
# 清理低优先级记忆（预览）
Clean-LowPriorityMemories -WhatIf

# 实际清理
Clean-LowPriorityMemories
```

---

## 📁 目录结构

```
memory/
├── MEMORY.md              # 核心记忆 (< 2KB)
├── 2026-03-09.md          # 今日记忆 (< 5KB)
├── archive/               # 历史档案
│   ├── INDEX.md           # 索引文件
│   ├── projects/          # 项目文档
│   ├── skills/            # 技能记录
│   └── decisions/         # 决策记录
├── .index/                # 索引缓存
└── .summaries/            # 摘要缓存
```

---

## 🎯 使用示例

### 场景1：整理今日记忆
```powershell
# 1. 检查大小
Check-MemoryLayers

# 2. 如果超过 5KB，生成摘要
Summarize-Memory -File "2026-03-09.md" -SaveToFile

# 3. 归档到 archive/
Archive-OldMemories
```

### 场景2：查找历史信息
```powershell
# 搜索关键词
Search-Memory -Keyword "企业微信" -MaxResults 5

# 查看相关记忆
Get-RelatedMemories -File "archive/2026-03-08.md"
```

### 场景3：每日自动维护
```powershell
# 一键完成所有维护
Invoke-FullMaintenance
```

---

## ⚙️ 配置 HEARTBEAT.md

添加自动维护任务：

```markdown
## 🧠 Smart Memory 每日维护

每24小时执行:
- [ ] 检查 MEMORY.md 大小 (< 2KB)
- [ ] 归档昨日记忆
- [ ] 更新索引
- [ ] 清理低优先级旧记忆 (P3: 7天, P2: 30天)
```

---

## 📊 效果对比

| 指标 | 使用前 | 使用后 | 改善 |
|:---|:---|:---|:---|
| **上下文使用率** | 180% | 30% | -150% |
| **响应速度** | 慢 | 快 | 3-5x |
| **长期项目** | 不可持续 | 可持续 | ✅ |
| **历史检索** | 困难 | 快速 | ✅ |

---

## 🔧 故障排查

### Q: 命令找不到？
**A:** 确保已加载脚本
```powershell
. ~/.agents/skills/smart-memory/scripts/smart-memory.ps1
```

### Q: 初始化失败？
**A:** 使用 Force 参数重试
```powershell
Init-SmartMemory -Force
```

### Q: 搜索不到内容？
**A:** 更新索引
```powershell
Update-MemoryIndex
```

---

## 📚 完整文档

查看 `SKILL.md` 了解：
- 详细功能说明
- 配置选项
- 高级用法
- API 参考

---

## 🤝 贡献

欢迎提交改进！

---

## 💝 支持作者

如果 Smart Memory 帮到了你，欢迎赞赏支持！

![微信支付](./assets/赞赏码.jpg)

**赞赏将用于：**
- 持续维护更新
- 开发新功能
- 优化性能

感谢支持！🙏

---

**让 AI 拥有无限记忆！** 🧠✨
