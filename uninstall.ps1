param(
    [switch]$Force,
    [switch]$DryRun,
    [string]$Target
)

if (-not $Target) {
    $Target = (Get-Location).Path
}

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success($msg) { Write-Host "[SUCCESS] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

if (-not (Test-Path $Target)) {
    Write-Fail "Target directory does not exist: $Target"
}

$ClaudeDir = Join-Path $Target '.claude'
$SettingsPath = Join-Path $ClaudeDir 'settings.json'
$ManifestPath = Join-Path $Target '.harness-team-install-manifest'

$PathsToDelete = New-Object System.Collections.Generic.List[string]

$DefaultPaths = @(
    (Join-Path $Target 'openspec-team'),
    (Join-Path $Target 'AGENTS.md'),
    (Join-Path $Target 'CLAUDE.md'),
    (Join-Path $Target 'REVIEW.md'),
    (Join-Path $Target 'scripts/harness-team-autopilot.sh'),
    (Join-Path $Target 'scripts/harness-team-workers.sh'),
    (Join-Path $Target '.claude/agents/reviewer.md'),
    (Join-Path $Target '.claude/hooks/guard_write.py'),
    (Join-Path $Target '.claude/hooks/ensure_change_context.py'),
    (Join-Path $Target '.claude/hooks/run_checks.sh'),
    (Join-Path $Target '.claude/skills/harness-team-setup'),
    (Join-Path $Target '.claude/skills/harness-team-propose'),
    (Join-Path $Target '.claude/skills/harness-team-plan'),
    (Join-Path $Target '.claude/skills/harness-team-prd'),
    (Join-Path $Target '.claude/skills/harness-team-apply'),
    (Join-Path $Target '.claude/skills/harness-team-verify'),
    (Join-Path $Target '.claude/skills/harness-team-fix'),
    (Join-Path $Target '.claude/skills/harness-team-review'),
    (Join-Path $Target '.claude/skills/harness-team-archive'),
    (Join-Path $Target '.claude/skills/harness-team-knowledge'),
    (Join-Path $Target '.claude/skills/harness-team-run'),
    (Join-Path $Target '.claude/skills/harness-team-status'),
    (Join-Path $Target '.claude/skills/harness-team-autopilot'),
    (Join-Path $Target '.claude/skills/harness-team-workers'),
    (Join-Path $Target '.claude/skills/prepare-review'),
    (Join-Path $Target '.claude/skills/spring-architecture-review'),
    (Join-Path $Target '.claude/skills/sql-risk-review'),
    (Join-Path $Target '.harness-team')
)

foreach ($path in $DefaultPaths) {
    if (Test-Path $path) {
        $PathsToDelete.Add($path)
    }
}

if (Test-Path $ManifestPath) {
    foreach ($line in Get-Content $ManifestPath) {
        if ($line -and (Test-Path $line)) {
            if (-not $PathsToDelete.Contains($line)) {
                $PathsToDelete.Add($line)
            }
        }
    }
}

function Remove-HarnessCommands {
    if (-not (Test-Path $SettingsPath)) {
        return
    }

    try {
        $raw = Get-Content $SettingsPath -Raw -Encoding UTF8
        $data = $raw | ConvertFrom-Json
    }
    catch {
        Write-Warn "Unable to parse .claude/settings.json, skipping command cleanup"
        return
    }

    if ($null -eq $data.commands -or $null -eq $data.commands.harness) {
        return
    }

    $data.commands.PSObject.Properties.Remove('harness') | Out-Null
    if (($data.commands.PSObject.Properties.Name).Count -eq 0) {
        $data.PSObject.Properties.Remove('commands') | Out-Null
    }

    $data | ConvertTo-Json -Depth 20 | Set-Content -Path $SettingsPath -Encoding UTF8
    Write-Success "Removed harness commands from .claude/settings.json"
}

Remove-HarnessCommands

if ($PathsToDelete.Count -eq 0) {
    Write-Warn "No installed artifacts found"
    exit 0
}

Write-Host "Will remove the following paths:"
foreach ($path in $PathsToDelete) {
    Write-Host "  - $path"
}

if ($DryRun) {
    Write-Info "Dry-run complete, nothing was deleted"
    exit 0
}

if (-not $Force) {
    $answer = Read-Host "Confirm deletion of the above paths? [y/N]"
    if ($answer -notin @('y', 'Y', 'yes', 'YES')) {
        Write-Warn "Uninstall cancelled"
        exit 0
    }
}

foreach ($path in $PathsToDelete) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}

if (Test-Path $ManifestPath) {
    Remove-Item -Path $ManifestPath -Force -ErrorAction SilentlyContinue
}

Write-Success "Uninstall complete"
