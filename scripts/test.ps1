# Smart Memory 2.0 - Test
# Verify core functions work

Write-Host ""
Write-Host "=== Smart Memory 2.0 Test ===" -ForegroundColor Cyan
Write-Host ""

$TestResults = @{
    Total = 0
    Passed = 0
    Failed = 0
}

function Test-Step {
    param(
        [string]$Name,
        [scriptblock]$Test
    )
    
    $TestResults.Total++
    Write-Host "Test: $Name ..." -NoNewline
    
    try {
        $result = & $Test
        if ($result -eq $true) {
            Write-Host " OK" -ForegroundColor Green
            $TestResults.Passed++
        } else {
            Write-Host " FAIL" -ForegroundColor Red
            $TestResults.Failed++
        }
    } catch {
        Write-Host " FAIL: $_" -ForegroundColor Red
        $TestResults.Failed++
    }
}

# Load the script first
$scriptPath = "$env:USERPROFILE\.agents\skills\smart-memory\scripts\smart-memory.ps1"
. $scriptPath | Out-Null

# Test 1: Script exists
Test-Step "smart-memory.ps1 exists" {
    Test-Path $scriptPath
}

# Test 2: Config loaded
Test-Step "Config loaded" {
    $null -ne $Config.MemoryDir
}

# Test 3: Functions exist
Test-Step "Check-MemoryLayers function" {
    $null -ne (Get-Command Check-MemoryLayers -ErrorAction SilentlyContinue)
}

Test-Step "Search-Memory function" {
    $null -ne (Get-Command Search-Memory -ErrorAction SilentlyContinue)
}

Test-Step "Archive-OldMemories function" {
    $null -ne (Get-Command Archive-OldMemories -ErrorAction SilentlyContinue)
}

Test-Step "Summarize-Memory function" {
    $null -ne (Get-Command Summarize-Memory -ErrorAction SilentlyContinue)
}

Test-Step "Update-MemoryIndex function" {
    $null -ne (Get-Command Update-MemoryIndex -ErrorAction SilentlyContinue)
}

Test-Step "Invoke-FullMaintenance function" {
    $null -ne (Get-Command Invoke-FullMaintenance -ErrorAction SilentlyContinue)
}

Test-Step "Show-MemoryStats function" {
    $null -ne (Get-Command Show-MemoryStats -ErrorAction SilentlyContinue)
}

# Test 4: Init script
Test-Step "init.ps1 exists" {
    $initPath = "$env:USERPROFILE\.agents\skills\smart-memory\scripts\init.ps1"
    Test-Path $initPath
}

# Test 5: Docs
Test-Step "SKILL.md exists" {
    $skillDoc = "$env:USERPROFILE\.agents\skills\smart-memory\SKILL.md"
    Test-Path $skillDoc
}

# Results
Write-Host ""
Write-Host "=== Results ===" -ForegroundColor Cyan
Write-Host "Total: $($TestResults.Total)"
Write-Host "Passed: $($TestResults.Passed)" -ForegroundColor Green
Write-Host "Failed: $($TestResults.Failed)" -ForegroundColor Red
Write-Host ""

if ($TestResults.Failed -eq 0) {
    Write-Host "All tests passed! Smart Memory 2.0 Ready!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Some tests failed" -ForegroundColor Yellow
    exit 1
}
