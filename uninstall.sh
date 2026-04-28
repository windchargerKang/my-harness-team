#!/bin/bash
#
# Harness Suite 一键卸载脚本
# 用法: bash uninstall.sh [--target <path>] [--dry-run] [--force]
#
# 作用：清理安装器创建的项目内文件与用户目录副本，尽量只删除本工具安装的内容。

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

TARGET_DIR="${PWD}"
DRY_RUN=false
FORCE=false
SCRIPT_SRC="${BASH_SOURCE:-$0}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_SRC}")" && pwd)"
INSTALLER_DIR="$(dirname "${SCRIPT_DIR}")"

if [ -f "${SCRIPT_SRC}" ] && [ "${SCRIPT_DIR}" != "${INSTALLER_DIR}" ]; then
    TARGET_DIR="${INSTALLER_DIR}"
    cd "${TARGET_DIR}"
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --target)
            TARGET_DIR="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  --target <path>   指定项目目录"
            echo "  --dry-run         仅显示将删除的内容"
            echo "  --force           跳过确认提示"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

MANIFEST_FILE="${TARGET_DIR}/.harness-team-install-manifest"
CLAUDE_SETTINGS="${TARGET_DIR}/.claude/settings.json"

CANDIDATE_PATHS=(
    "${TARGET_DIR}/openspec-team"
    "${TARGET_DIR}/AGENTS.md"
    "${TARGET_DIR}/CLAUDE.md"
    "${TARGET_DIR}/REVIEW.md"
    "${TARGET_DIR}/scripts/harness-team-autopilot.sh"
    "${TARGET_DIR}/scripts/harness-team-workers.sh"
    "${TARGET_DIR}/.claude/agents/reviewer.md"
    "${TARGET_DIR}/.claude/hooks/guard_write.py"
    "${TARGET_DIR}/.claude/hooks/ensure_change_context.py"
    "${TARGET_DIR}/.claude/hooks/run_checks.sh"
    "${TARGET_DIR}/.claude/skills/harness-team-setup"
    "${TARGET_DIR}/.claude/skills/harness-team-propose"
    "${TARGET_DIR}/.claude/skills/harness-team-plan"
    "${TARGET_DIR}/.claude/skills/harness-team-prd"
    "${TARGET_DIR}/.claude/skills/harness-team-apply"
    "${TARGET_DIR}/.claude/skills/harness-team-verify"
    "${TARGET_DIR}/.claude/skills/harness-team-fix"
    "${TARGET_DIR}/.claude/skills/harness-team-review"
    "${TARGET_DIR}/.claude/skills/harness-team-archive"
    "${TARGET_DIR}/.claude/skills/harness-team-knowledge"
    "${TARGET_DIR}/.claude/skills/harness-team-run"
    "${TARGET_DIR}/.claude/skills/harness-team-status"
    "${TARGET_DIR}/.claude/skills/harness-team-autopilot"
    "${TARGET_DIR}/.claude/skills/harness-team-workers"
    "${TARGET_DIR}/.claude/skills/prepare-review"
    "${TARGET_DIR}/.claude/skills/spring-architecture-review"
    "${TARGET_DIR}/.claude/skills/sql-risk-review"
    "${HOME}/.harness-team"
)

if [ -f "${MANIFEST_FILE}" ]; then
    while IFS= read -r line; do
        [ -n "$line" ] && CANDIDATE_PATHS+=("$line")
    done < "${MANIFEST_FILE}"
fi

# 去重
UNIQUE_PATHS=()
for p in "${CANDIDATE_PATHS[@]}"; do
    skip=false
    for seen in "${UNIQUE_PATHS[@]}"; do
        if [ "$p" = "$seen" ]; then
            skip=true
            break
        fi
    done
    [ "$skip" = false ] && UNIQUE_PATHS+=("$p")
done

# settings.json 备份并移除 commands
remove_harness_commands() {
    [ -f "${CLAUDE_SETTINGS}" ] || return 0
    if command -v python3 >/dev/null 2>&1; then
        python3 - "${CLAUDE_SETTINGS}" <<'PY'
import json, sys, pathlib
path = pathlib.Path(sys.argv[1])
try:
    data = json.loads(path.read_text(encoding='utf-8'))
except Exception:
    sys.exit(0)
commands = data.get('commands')
if isinstance(commands, dict) and 'harness' in commands:
    del commands['harness']
    if not commands:
        data.pop('commands', None)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
PY
        log_success "已移除 .claude/settings.json 中的 harness commands"
    else
        log_warn "未找到 python3，跳过 settings.json 自动清理"
    fi
}

paths_to_delete=()
for p in "${UNIQUE_PATHS[@]}"; do
    if [ -e "$p" ]; then
        paths_to_delete+=("$p")
    fi
done

remove_harness_commands

if [ ${#paths_to_delete[@]} -eq 0 ]; then
    log_warn "未发现可删除的安装产物"
    exit 0
fi

echo "将删除以下路径:"
for p in "${paths_to_delete[@]}"; do
    echo "  - $p"
done

if [ "$DRY_RUN" = true ]; then
    log_info "dry-run 完成，未实际删除任何文件"
    exit 0
fi

if [ "$FORCE" != true ]; then
    read -r -p "确认删除以上内容？[y/N] " answer
    case "$answer" in
        y|Y|yes|YES) ;;
        *)
            log_warn "已取消卸载"
            exit 0
            ;;
    esac
fi

for p in "${paths_to_delete[@]}"; do
    rm -rf "$p"
done

rm -f "${MANIFEST_FILE}" 2>/dev/null || true
log_success "卸载完成"
