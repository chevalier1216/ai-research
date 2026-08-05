$ErrorActionPreference = 'Stop'

$workspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$checker = Join-Path $workspaceRoot 'research-harness\scripts\verify-research-governance.ps1'

& powershell -NoProfile -ExecutionPolicy Bypass -File $checker -WorkspaceRoot $workspaceRoot
if ($LASTEXITCODE -ne 0) {
    throw "正向研究治理檢查失敗，結束碼：$LASTEXITCODE"
}

$fixtureFiles = @(
    'AGENTS.md',
    'research-harness\templates\handoff.md',
    'research-harness\templates\progress-update.md',
    'research-harness\templates\rework-register.md',
    'research-harness\templates\research-plan.md',
    'research-harness\流程規格\研究代理治理規格.md',
    'research-harness\reports\2026-08-05-研究流程治理修正報告.md'
)

$negativeCases = @(
    @{ Path = 'AGENTS.md'; Required = '固定五階段'; Replacement = '固定流程' },
    @{ Path = 'research-harness\templates\progress-update.md'; Required = '實際案例'; Replacement = '作業事項' },
    @{ Path = 'research-harness\流程規格\研究代理治理規格.md'; Required = 'superpowers:writing-plans'; Replacement = 'superpowers:規劃' }
)

foreach ($case in $negativeCases) {
    $fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ("ai-research-governance-" + [Guid]::NewGuid())
    try {
        foreach ($relativePath in $fixtureFiles) {
            $source = Join-Path $workspaceRoot $relativePath
            $destination = Join-Path $fixtureRoot $relativePath
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
            Copy-Item -LiteralPath $source -Destination $destination
        }

        $fixturePath = Join-Path $fixtureRoot $case.Path
        $content = [IO.File]::ReadAllText($fixturePath, [Text.UTF8Encoding]::new($false, $true))
        [IO.File]::WriteAllText($fixturePath, $content.Replace($case.Required, $case.Replacement), [Text.UTF8Encoding]::new($true))

        $savedErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        & powershell -NoProfile -ExecutionPolicy Bypass -File $checker -WorkspaceRoot $fixtureRoot 2>$null
        $negativeExitCode = $LASTEXITCODE
        $ErrorActionPreference = $savedErrorActionPreference
        if ($negativeExitCode -eq 0) {
            throw "負向測試失敗：移除 $($case.Required) 後仍通過檢查。"
        }
    }
    finally {
        if (Test-Path -LiteralPath $fixtureRoot) {
            Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
        }
    }
}
