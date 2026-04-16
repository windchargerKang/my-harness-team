param(
    [switch]$SkipSuperpowers,
    [switch]$Force,
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success($msg) { Write-Host "[SUCCESS] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

Write-Info "Starting Harness Suite installation..."

$ScriptRoot = $PSScriptRoot
if (-not (Test-Path $ScriptRoot)) {
    Write-Fail "Cannot locate script directory. Please run install.ps1 with -File parameter."
}

# Check resource integrity
$requiredPaths = @(
    (Join-Path $ScriptRoot 'setup/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-propose/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-plan/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-prd/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-apply/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-verify/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-fix/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-review/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-archive/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-knowledge/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-run/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-status/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-autopilot/SKILL.md'),
    (Join-Path $ScriptRoot 'workflow/team-workers/SKILL.md'),
    (Join-Path $ScriptRoot 'review-skills/prepare-review/SKILL.md'),
    (Join-Path $ScriptRoot 'review-skills/spring-architecture-review/SKILL.md'),
    (Join-Path $ScriptRoot 'review-skills/sql-risk-review/SKILL.md')
)

foreach ($path in $requiredPaths) {
    if (-not (Test-Path $path)) {
        Write-Fail "Installation resources incomplete: missing $path`nPlease download the full repository first."
    }
}

if (-not (Test-Path $Target)) {
    Write-Fail "Target directory does not exist: $Target"
}

$ClaudeDir = Join-Path $Target '.claude'
$SkillsDir = Join-Path $ClaudeDir 'skills'
$AgentsDir = Join-Path $ClaudeDir 'agents'
$HooksDir = Join-Path $ClaudeDir 'hooks'

New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $AgentsDir | Out-Null
New-Item -ItemType Directory -Force -Path $HooksDir | Out-Null

if (-not $SkipSuperpowers) {
    Write-Info "Checking Superpowers..."
    $superpowersGuide = Join-Path $SkillsDir 'superpowers-guide'
    if (Test-Path $superpowersGuide) {
        Write-Success "Superpowers already installed"
    }
    else {
        Write-Warn "Superpowers not detected, recommend installing manually"
    }
}

Write-Info "Copying Skills..."

$skillMap = @(
    @{ src = 'workflow/team-propose/SKILL.md'; dst = 'harness-team-propose' },
    @{ src = 'workflow/team-plan/SKILL.md'; dst = 'harness-team-plan' },
    @{ src = 'workflow/team-prd/SKILL.md'; dst = 'harness-team-prd' },
    @{ src = 'workflow/team-apply/SKILL.md'; dst = 'harness-team-apply' },
    @{ src = 'workflow/team-verify/SKILL.md'; dst = 'harness-team-verify' },
    @{ src = 'workflow/team-fix/SKILL.md'; dst = 'harness-team-fix' },
    @{ src = 'workflow/team-review/SKILL.md'; dst = 'harness-team-review' },
    @{ src = 'workflow/team-archive/SKILL.md'; dst = 'harness-team-archive' },
    @{ src = 'workflow/team-knowledge/SKILL.md'; dst = 'harness-team-knowledge' },
    @{ src = 'workflow/team-run/SKILL.md'; dst = 'harness-team-run' },
    @{ src = 'workflow/team-status/SKILL.md'; dst = 'harness-team-status' },
    @{ src = 'workflow/team-autopilot/SKILL.md'; dst = 'harness-team-autopilot' },
    @{ src = 'workflow/team-workers/SKILL.md'; dst = 'harness-team-workers' },
    @{ src = 'review-skills/prepare-review/SKILL.md'; dst = 'prepare-review' },
    @{ src = 'review-skills/spring-architecture-review/SKILL.md'; dst = 'spring-architecture-review' },
    @{ src = 'review-skills/sql-risk-review/SKILL.md'; dst = 'sql-risk-review' }
)

# setup 目录承载 team-setup
$setupSrc = Join-Path $ScriptRoot 'setup/SKILL.md'
$setupTargets = @('harness-team-setup')
foreach ($targetSkill in $setupTargets) {
    $dstDir = Join-Path $SkillsDir $targetSkill
    $dst = Join-Path $dstDir 'SKILL.md'
    New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    Copy-Item -Path $setupSrc -Destination $dst -Force
    Write-Success "Copied $targetSkill"
}

foreach ($entry in $skillMap) {
    $src = Join-Path $ScriptRoot $entry.src
    $dstDir = Join-Path $SkillsDir $entry.dst
    $dst = Join-Path $dstDir 'SKILL.md'

    New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    Copy-Item -Path $src -Destination $dst -Force
    Write-Success "Copied $($entry.dst)"
}

Write-Info "Copying Agent and Hooks..."
Copy-Item -Path (Join-Path $ScriptRoot 'agents/reviewer.md') -Destination (Join-Path $AgentsDir 'reviewer.md') -Force
Write-Success "Copied reviewer agent"

$hookFiles = @('guard_write.py', 'ensure_change_context.py', 'run_checks.sh')
foreach ($hook in $hookFiles) {
    $src = Join-Path $ScriptRoot ("hooks/{0}" -f $hook)
    $dst = Join-Path $HooksDir $hook
    Copy-Item -Path $src -Destination $dst -Force
    Write-Success "Copied $hook"
}

Write-Info "Copying team scripts..."
$scriptDir = Join-Path $Target 'scripts'
New-Item -ItemType Directory -Force -Path $scriptDir | Out-Null
$teamScripts = @('harness-team-autopilot.sh', 'harness-team-workers.sh')
foreach ($script in $teamScripts) {
    $src = Join-Path $ScriptRoot ("scripts/{0}" -f $script)
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination (Join-Path $scriptDir $script) -Force
        Write-Success "Copied $script"
    }
}

Write-Info "Copying specification files..."
$rootFiles = @('AGENTS.md', 'CLAUDE.md', 'REVIEW.md')
foreach ($file in $rootFiles) {
    $src = Join-Path $ScriptRoot $file
    $dst = Join-Path $Target $file
    if ((Test-Path $dst) -and (-not $Force)) {
        Write-Warn "$file already exists, skipping (use -Force to overwrite)"
    }
    else {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Success "Copied $file"
    }
}

Write-Info "Creating openspec-team workspace and templates..."
$openSpecTeamDir = Join-Path $Target 'openspec-team'
$openSpecTeamChanges = Join-Path $openSpecTeamDir 'changes/archive'
$openSpecTeamSpecs = Join-Path $openSpecTeamDir 'specs'
$openSpecTeamKnowledge = Join-Path $openSpecTeamDir 'knowledge'
$openSpecTeamSkills = Join-Path $openSpecTeamDir 'skills'
$templateSrc = Join-Path $ScriptRoot 'docs_template'
$templateDst = Join-Path $openSpecTeamDir 'templates'
$userKnowledge = Join-Path $HOME '.harness-team/knowledge'
$userSkills = Join-Path $HOME '.harness-team/skills'

New-Item -ItemType Directory -Force -Path $openSpecTeamChanges | Out-Null
New-Item -ItemType Directory -Force -Path $openSpecTeamSpecs | Out-Null
New-Item -ItemType Directory -Force -Path $openSpecTeamKnowledge | Out-Null
New-Item -ItemType Directory -Force -Path $openSpecTeamSkills | Out-Null
New-Item -ItemType Directory -Force -Path $templateDst | Out-Null
New-Item -ItemType Directory -Force -Path $userKnowledge | Out-Null
New-Item -ItemType Directory -Force -Path $userSkills | Out-Null

$specIndex = Join-Path $openSpecTeamSpecs 'index.md'
if (-not (Test-Path $specIndex)) {
    Set-Content -Path $specIndex -Value "# openspec-team specs`n`n用于维护 Team 工作流相关的规范索引。" -Encoding UTF8
    Write-Success "Created openspec-team/specs/index.md"
}

if (Test-Path $templateSrc) {
    Get-ChildItem -Path $templateSrc -Filter '*.md' | ForEach-Object {
        $dstFile = Join-Path $templateDst $_.Name
        if ((Test-Path $dstFile) -and (-not $Force)) {
            Write-Warn "Template $($_.Name) already exists, skipping (use -Force to overwrite)"
        }
        else {
            Copy-Item -Path $_.FullName -Destination $dstFile -Force
            Write-Success "Copied team template $($_.Name)"
        }
    }
}

Write-Info "Configuring commands..."
$settingsPath = Join-Path $ClaudeDir 'settings.json'
$settingsJson = @'
{
  "commands": {
    "harness": {
      "team-setup": "harness-team-setup",
      "team-propose": "harness-team-propose",
      "team-plan": "harness-team-plan",
      "team-apply": "harness-team-apply",
      "team-verify": "harness-team-verify",
      "team-fix": "harness-team-fix",
      "team-review": "harness-team-review",
      "team-archive": "harness-team-archive",
      "team-knowledge": "harness-team-knowledge",
      "team-run": "harness-team-run",
      "team-status": "harness-team-status",
      "team-autopilot": "harness-team-autopilot",
      "team-workers": "harness-team-workers"
    }
  }
}
'@

if (-not (Test-Path $settingsPath)) {
    Set-Content -Path $settingsPath -Value $settingsJson -Encoding UTF8
    Write-Success "Created settings.json"
}
else {
    Write-Warn ".claude/settings.json already exists, please merge commands manually"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " Harness Suite installation completed! " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Restart Cursor/Claude session to activate commands"
Write-Host "  2. Type /harness-team-setup in chat to initialize project"
