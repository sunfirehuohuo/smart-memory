# Smart Memory 2.0
# Memory management tool

$Config = @{
    MemoryDir = "$env:USERPROFILE\.openclaw\workspace\main\memory"
    ArchiveDir = "$env:USERPROFILE\.openclaw\workspace\main\memory\archive"
    IndexDir = "$env:USERPROFILE\.openclaw\workspace\main\memory\.index"
    SummaryDir = "$env:USERPROFILE\.openclaw\workspace\main\memory\.summaries"
    MaxL1Size = 2048
    MaxL2Size = 5120
    DaysToKeep = 7
}

function Check-MemoryLayers {
    Write-Host "=== Check Memory Layers ===" -ForegroundColor Cyan
    
    # L1
    $l1File = "$($Config.MemoryDir)\MEMORY.md"
    if (Test-Path $l1File) {
        $content = Get-Content $l1File -Raw
        $size = $content.Length
        Write-Host "L1 (Core): $size chars"
        if ($size -gt $Config.MaxL1Size) {
            Write-Host "  Warning: Over limit!" -ForegroundColor Yellow
        } else {
            Write-Host "  OK" -ForegroundColor Green
        }
    }
    
    # L2
    $today = Get-Date -Format "yyyy-MM-dd"
    $l2File = "$($Config.MemoryDir)\$today.md"
    if (Test-Path $l2File) {
        $content = Get-Content $l2File -Raw
        $size = $content.Length
        Write-Host "L2 (Today): $size chars"
        if ($size -gt $Config.MaxL2Size) {
            Write-Host "  Warning: Over limit!" -ForegroundColor Yellow
        } else {
            Write-Host "  OK" -ForegroundColor Green
        }
    }
    
    # L3
    $archiveCount = (Get-ChildItem "$($Config.ArchiveDir)\*.md" -ErrorAction SilentlyContinue).Count
    Write-Host "L3 (Archive): $archiveCount files"
    Write-Host ""
}

function Archive-OldMemories {
    param([int]$DaysToKeep = $Config.DaysToKeep)
    
    Write-Host "=== Archive Old Memories ===" -ForegroundColor Cyan
    
    @($Config.ArchiveDir, $Config.IndexDir, $Config.SummaryDir) | ForEach-Object {
        if (-not (Test-Path $_)) { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
    }
    
    $cutoffDate = (Get-Date).AddDays(-$DaysToKeep)
    $archived = 0
    
    Get-ChildItem "$($Config.MemoryDir)\*.md" | Where-Object { 
        $_.Name -match "^\d{4}-\d{2}-\d{2}\.md$" -and $_.LastWriteTime -lt $cutoffDate 
    } | ForEach-Object {
        $dest = "$($Config.ArchiveDir)\$($_.Name)"
        Move-Item $_.FullName $dest -Force
        Write-Host "  Archived: $($_.Name)"
        $archived++
    }
    
    if ($archived -eq 0) { Write-Host "  Nothing to archive" }
    Write-Host ""
}

function Search-Memory {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Keyword,
        [int]$MaxResults = 10
    )
    
    Write-Host "=== Search: '$Keyword' ===" -ForegroundColor Cyan
    
    $results = @()
    $files = @()
    $files += Get-ChildItem "$($Config.MemoryDir)\*.md" -ErrorAction SilentlyContinue
    $files += Get-ChildItem "$($Config.ArchiveDir)\*.md" -ErrorAction SilentlyContinue
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        if ($content -match $Keyword) {
            $matches = ([regex]::Matches($content, $Keyword)).Count
            $excerpt = if ($content.Length -gt 200) { $content.Substring(0, 200) + "..." } else { $content }
            $results += [PSCustomObject]@{
                File = $file.FullName
                Relevance = $matches
                Excerpt = $excerpt
            }
        }
    }
    
    $results = $results | Sort-Object Relevance -Descending | Select-Object -First $MaxResults
    
    if ($results.Count -eq 0) { Write-Host "  No results" }
    else {
        foreach ($r in $results) {
            Write-Host ""
            Write-Host "  File: $(Split-Path $r.File -Leaf)" -ForegroundColor Yellow
            Write-Host "  $($r.Excerpt)"
        }
    }
    Write-Host ""
    return $results
}

function Summarize-Memory {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        [switch]$SaveToFile
    )
    
    Write-Host "=== Summarize ===" -ForegroundColor Cyan
    if (-not (Test-Path $FilePath)) { Write-Host "  File not found"; return }
    
    $content = Get-Content $FilePath -Raw
    $originalLength = $content.Length
    
    # Extract key sections
    $summary = @()
    $summary += "# Summary: $(Split-Path $FilePath -Leaf)"
    
    if ($content -match "## .*work.*\n([\s\S]*?)(?=##|$)") {
        $summary += "## Key Work"
        $summary += $matches[1].Trim()
    }
    
    $summaryText = $summary -join "`n"
    
    if ($SaveToFile) {
        $summaryFile = "$($Config.SummaryDir)\$(Split-Path $FilePath -Leaf)"
        Set-Content $summaryFile $summaryText -Encoding UTF8
        Write-Host "  Saved: $summaryFile"
    }
    
    Write-Host "  Original: $originalLength chars"
    Write-Host "  Summary: $($summaryText.Length) chars"
    Write-Host ""
    return $summaryText
}

function Update-MemoryIndex {
    Write-Host "=== Update Index ===" -ForegroundColor Cyan
    if (-not (Test-Path $Config.IndexDir)) { New-Item -ItemType Directory -Path $Config.IndexDir -Force | Out-Null }
    
    $index = @{ LastUpdate = Get-Date -Format "yyyy-MM-dd HH:mm"; Files = @() }
    $allFiles = @()
    $allFiles += Get-ChildItem "$($Config.MemoryDir)\*.md" -ErrorAction SilentlyContinue
    $allFiles += Get-ChildItem "$($Config.ArchiveDir)\*.md" -ErrorAction SilentlyContinue
    
    foreach ($file in $allFiles) {
        $index.Files += @{
            Name = $file.Name
            Path = $file.FullName
            Size = $file.Length
            LastModified = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        }
    }
    
    $indexFile = "$($Config.IndexDir)\memory-index.json"
    $index | ConvertTo-Json -Depth 3 | Set-Content $indexFile -Encoding UTF8
    Write-Host "  Updated: $($index.Files.Count) files"
    Write-Host ""
}

function Show-MemoryStats {
    Write-Host ""
    Write-Host "=== Memory Stats ===" -ForegroundColor Cyan
    
    $l1Size = if (Test-Path "$($Config.MemoryDir)\MEMORY.md") { (Get-Item "$($Config.MemoryDir)\MEMORY.md").Length } else { 0 }
    $l2Files = Get-ChildItem "$($Config.MemoryDir)\*.md" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^\d{4}-\d{2}-\d{2}\.md$" }
    $l2Count = $l2Files.Count
    $l2Size = ($l2Files | Measure-Object -Property Length -Sum).Sum
    $l3Files = Get-ChildItem "$($Config.ArchiveDir)\*.md" -ErrorAction SilentlyContinue
    $l3Count = $l3Files.Count
    $l3Size = ($l3Files | Measure-Object -Property Length -Sum).Sum
    
    Write-Host "L1 Core: $([math]::Round($l1Size/1024, 2)) KB"
    Write-Host "L2 Short: $l2Count files, $([math]::Round($l2Size/1024, 2)) KB"
    Write-Host "L3 Archive: $l3Count files, $([math]::Round($l3Size/1024, 2)) KB"
    Write-Host "Total: $([math]::Round(($l1Size + $l2Size + $l3Size)/1024, 2)) KB"
    Write-Host ""
}

function Invoke-FullMaintenance {
    Write-Host ""
    Write-Host "=== Full Maintenance ===" -ForegroundColor Green
    Write-Host ""
    Check-MemoryLayers
    Archive-OldMemories
    Update-MemoryIndex
    Write-Host "Done!" -ForegroundColor Green
    Write-Host ""
}
