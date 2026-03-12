# Smart Memory 维护脚本

## 检查记忆大小
function Check-MemorySize {
    $memoryFile = "$env:USERPROFILE\.openclaw\workspace\main\memory\MEMORY.md"
    if (Test-Path $memoryFile) {
        $content = Get-Content $memoryFile -Raw
        $size = $content.Length
        $sizeKB = [math]::Round($size / 1024, 2)
        
        Write-Host "MEMORY.md 大小: $size 字符 ($sizeKB KB)"
        
        if ($size -gt 2000) {
            Write-Host "⚠️ 警告: 超过 2KB 建议精简!" -ForegroundColor Red
            return $false
        } else {
            Write-Host "✅ 大小正常" -ForegroundColor Green
            return $true
        }
    } else {
        Write-Host "❌ MEMORY.md 不存在"
        return $false
    }
}

## 归档旧记忆
function Archive-OldMemories {
    $memoryDir = "$env:USERPROFILE\.openclaw\workspace\main\memory"
    $archiveDir = "$memoryDir\archive"
    
    # 创建归档目录
    if (-not (Test-Path $archiveDir)) {
        New-Item -ItemType Directory -Path $archiveDir -Force
        Write-Host "✅ 创建归档目录"
    }
    
    # 归档昨天的记忆
    $yesterday = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
    $source = "$memoryDir\$yesterday.md"
    $dest = "$archiveDir\$yesterday.md"
    
    if (Test-Path $source) {
        Move-Item $source $dest -Force
        Write-Host "✅ 已归档: $yesterday.md"
    }
    
    # 归档更早的记忆（保留最近3天）
    $cutoffDate = (Get-Date).AddDays(-3)
    Get-ChildItem "$memoryDir\*.md" | Where-Object { 
        $_.Name -match "^\d{4}-\d{2}-\d{2}\.md$" -and 
        $_.LastWriteTime -lt $cutoffDate 
    } | ForEach-Object {
        $dest = "$archiveDir\$($_.Name)"
        Move-Item $_.FullName $dest -Force
        Write-Host "✅ 已归档: $($_.Name)"
    }
}

## 备份记忆
function Backup-Memories {
    $sourceDir = "$env:USERPROFILE\.openclaw\workspace\main\memory"
    $backupDir = "$env:USERPROFILE\.openclaw\backups\memory-$(Get-Date -Format 'yyyyMMdd-HHmm')"
    
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir -Force
    }
    
    Copy-Item "$sourceDir\*" $backupDir -Recurse -Force
    Write-Host "✅ 备份完成: $backupDir"
}

## 创建记忆索引
function Create-MemoryIndex {
    $memoryDir = "$env:USERPROFILE\.openclaw\workspace\main\memory"
    $archiveDir = "$memoryDir\archive"
    $indexFile = "$archiveDir\INDEX.md"
    
    $content = @"
# 记忆档案索引

生成时间: $(Get-Date -Format "yyyy-MM-dd HH:mm")

## 按日期归档

"@
    
    Get-ChildItem "$archiveDir\*.md" | Where-Object { $_.Name -match "^\d{4}-\d{2}-\d{2}\.md$" } | 
    Sort-Object Name -Descending | 
    ForEach-Object {
        $date = $_.Name -replace "\.md$", ""
        $sizeKB = [math]::Round($_.Length / 1024, 2)
        $content += "- [$date]($($_.Name)) - $sizeKB KB`n"
    }
    
    $content += @"

## 项目文档

"@
    
    if (Test-Path "$archiveDir\projects") {
        Get-ChildItem "$archiveDir\projects\*.md" | ForEach-Object {
            $content += "- [$($_.BaseName)](projects/$($_.Name))`n"
        }
    }
    
    Set-Content $indexFile $content -Encoding UTF8
    Write-Host "✅ 索引已创建: $indexFile"
}

## 执行每日维护
function Invoke-DailyMaintenance {
    Write-Host "=== Smart Memory 每日维护 ===" -ForegroundColor Cyan
    Write-Host ""
    
    # 1. 检查大小
    Write-Host "1. 检查 MEMORY.md 大小..."
    Check-MemorySize
    Write-Host ""
    
    # 2. 归档旧记忆
    Write-Host "2. 归档旧记忆..."
    Archive-OldMemories
    Write-Host ""
    
    # 3. 更新索引
    Write-Host "3. 更新索引..."
    Create-MemoryIndex
    Write-Host ""
    
    Write-Host "✅ 每日维护完成!" -ForegroundColor Green
}

# 主菜单
Write-Host ""
Write-Host "=== Smart Memory 管理工具 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 检查记忆大小"
Write-Host "2. 归档旧记忆"
Write-Host "3. 备份记忆"
Write-Host "4. 创建索引"
Write-Host "5. 执行每日维护"
Write-Host ""
