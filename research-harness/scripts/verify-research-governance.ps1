param(
    [Parameter(Mandatory = $true)]
    [string]$WorkspaceRoot
)

$ErrorActionPreference = 'Stop'
$required = @(
    @{ Path = 'AGENTS.md'; Terms = @('固定五階段', '最多使用五個工作角色', '既有角色無法完成', '資料及工具安全範圍', '最多一個補證批次') },
    @{ Path = 'research-harness\templates\handoff.md'; Terms = @('500 字內', '最多 12 組', '最多 3 項', '不得填入') },
    @{ Path = 'research-harness\templates\progress-update.md'; Terms = @('實際案例 4W 概要', '不是研究作業日誌', '詳細研究內文', '已驗證資料來源') },
    @{ Path = 'research-harness\templates\rework-register.md'; Terms = @('不是新研究階段', '最多三項缺口', '原審核') },
    @{ Path = 'research-harness\templates\research-plan.md'; Terms = @('派工登錄', '獨立工作包', '資料及工具安全範圍', '閘門結果') },
    @{ Path = 'research-harness\流程規格\研究代理治理規格.md'; Terms = @('代理啟動閘門', '固定五階段', '最大值為兩個', '既有角色無法完成', '資料及工具安全範圍', '單次補證', '技能使用矩陣', 'superpowers:writing-plans', 'superpowers:verification-before-completion') },
    @{ Path = 'research-harness\reports\2026-08-05-研究流程治理修正報告.md'; Terms = @('修正目的', '修正行動', '修正結果', '修正後的預期行為', '已驗證') }
)

$failures = @()
$controlCount = 0
foreach ($item in $required) {
    $path = Join-Path $WorkspaceRoot $item.Path
    if (-not (Test-Path -LiteralPath $path)) {
        $failures += "缺少檔案：$($item.Path)"
        continue
    }
    $content = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
    foreach ($term in $item.Terms) {
        $controlCount++
        if (-not $content.Contains($term)) {
            $failures += "缺少必要規則：$($item.Path) :: $term"
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "研究代理治理檢查通過：$($required.Count) 個流程資產、$controlCount 項必要規則。"
