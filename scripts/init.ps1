# Smart Memory 初始化脚本
# 一键设置完整的记忆管理系统

param(
    [switch]$Force
)

Write-Host ""
Write-Host "=== Smart Memory 2.0 初始化 ===" -ForegroundColor Cyan
Write-Host ""

# 配置
$WorkspaceDir = "$env:USERPROFILE\.openclaw\workspace\main"
$MemoryDir = "$WorkspaceDir\memory"
$ArchiveDir = "$MemoryDir\archive"
$IndexDir = "$MemoryDir\.index"
$SummaryDir = "$MemoryDir\.summaries"
$ProjectsDir = "$ArchiveDir\projects"
$SkillsDir = "$ArchiveDir\skills"
$DecisionsDir = "$ArchiveDir\decisions"

# 检查是否已初始化
if ((Test-Path "$MemoryDir\MEMORY.md") -and -not $Force) {
    Write-Host "⚠️  Smart Memory 已经初始化!" -ForegroundColor Yellow
    Write-Host "使用 -Force 参数强制重新初始化" -ForegroundColor Gray
    exit 0
}

# 创建目录结构
Write-Host "1. 创建目录结构..." -NoNewline
$directories = @($MemoryDir, $ArchiveDir, $IndexDir, $SummaryDir, $ProjectsDir, $SkillsDir, $DecisionsDir)
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
Write-Host " ✅" -ForegroundColor Green

# 创建核心记忆文件
Write-Host "2. 创建核心记忆文件..." -NoNewline

# MEMORY.md
$memoryContent = @"
# MEMORY.md - 核心记忆

## 身份
- **名字**: 
- **角色**: 
- **模型**: 

## 当前任务 (P0)
- [ ] 

## 关键决策
- 

## 标签
#

---
*详细历史记录在 archive/ 目录*
"@
Set-Content -Path "$MemoryDir\MEMORY.md" -Value $memoryContent -Encoding UTF8

# 今日记忆文件
$today = Get-Date -Format "yyyy-MM-dd"
$todayContent = @"
# $today

## 今日工作
- 

## 遇到的问题
- 

## 明日计划
- 

## 标签
#
"@
Set-Content -Path "$MemoryDir\$today.md" -Value $todayContent -Encoding UTF8

Write-Host " ✅" -ForegroundColor Green

# 创建索引文件
Write-Host "3. 创建索引..." -NoNewline
$indexContent = @"
# 记忆档案索引

生成时间: $(Get-Date -Format "yyyy-MM-dd HH:mm")

## 目录结构

- **archive/** - 历史档案
  - **projects/** - 项目文档
  - **skills/** - 技能学习记录
  - **decisions/** - 重要决策记录
- **.index/** - 索引文件
- **.summaries/** - 摘要缓存

## 使用指南

1. **每日维护**: 运行 `Invoke-FullMaintenance`
2. **搜索记忆**: `Search-Memory -Keyword "关键词"`
3. **查看统计**: `Show-MemoryStats`

"@
Set-Content -Path "$ArchiveDir\INDEX.md" -Value $indexContent -Encoding UTF8
Write-Host " ✅" -ForegroundColor Green

# 创建配置示例
Write-Host "4. 创建配置示例..." -NoNewline
$configExample = @"
{
  "smartMemory": {
    "version": "2.0.0",
    "autoArchive": {
      "enabled": true,
      "schedule": "0 0 * * *",
      "daysToKeep": 7
    },
    "cleanupRules": {
      "P0": { "keepDays": 365 },
      "P1": { "keepDays": 90 },
      "P2": { "keepDays": 30 },
      "P3": { "keepDays": 7 }
    }
  }
}
"@
Set-Content -Path "$MemoryDir\config.example.json" -Value $configExample -Encoding UTF8
Write-Host " ✅" -ForegroundColor Green

# 添加到 HEARTBEAT.md
Write-Host "5. 检查 HEARTBEAT.md..." -NoNewline
$heartbeatFile = "$WorkspaceDir\HEARTBEAT.md"
if (Test-Path $heartbeatFile) {
    $content = Get-Content $heartbeatFile -Raw
    if ($content -notmatch "Smart Memory") {
        $heartbeatAddition = @"

## Smart Memory 自动维护

### 每日任务 (建议添加到 HEARTBEAT.md)
```markdown
## 🧠 记忆管理维护

每24小时执行:
- [ ] 检查 MEMORY.md 大小 (< 2KB)
- [ ] 归档昨日记忆到 archive/
- [ ] 更新索引
- [ ] 清理低优先级旧记忆
```

"@
        Add-Content -Path $heartbeatFile -Value $heartbeatAddition -Encoding UTF8
        Write-Host " ✅ 已添加配置" -ForegroundColor Green
    } else {
        Write-Host " ⚠️  已存在配置" -ForegroundColor Yellow
    }
} else {
    Write-Host " ⚠️  HEARTBEAT.md 不存在" -ForegroundColor Yellow
}

# 显示统计
Write-Host ""
Write-Host "=== 初始化完成! ===" -ForegroundColor Green
Write-Host ""
Write-Host "目录结构:"
Write-Host "  📁 memory/" -ForegroundColor Cyan
Write-Host "    📄 MEMORY.md          (核心记忆 < 2KB)"
Write-Host "    📄 $today.md        (今日记忆 < 5KB)"
Write-Host "    📁 archive/          (历史档案)"
Write-Host "      📁 projects/       (项目文档)"
Write-Host "      📁 skills/         (技能记录)"
Write-Host "      📁 decisions/      (决策记录)"
Write-Host "    📁 .index/           (索引)"
Write-Host "    📁 .summaries/       (摘要缓存)"
Write-Host ""
Write-Host "下一步:"
Write-Host "  1. 编辑 MEMORY.md 填写身份信息"
Write-Host "  2. 运行 '. ~/.agents/skills/smart-memory/scripts/smart-memory.ps1'"
Write-Host "  3. 运行 'Show-SmartMemoryMenu' 开始使用"
Write-Host ""
Write-Host "Smart Memory 2.0 已就绪! 🧠✨" -ForegroundColor Green
Write-Host ""
