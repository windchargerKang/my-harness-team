#!/bin/bash
#
# Harness Suite 安装脚本
# 用法: bash -c "$(curl -fsSL <URL>)"
# 或: curl -fsSL <URL> | bash
#
# 支持的参数:
#   --skip-superpowers   跳过 superpowers 安装检查
#   --force              强制覆盖已有文件
#   --target <path>      指定安装目标目录（默认当前目录）
#

set -euo pipefail

# ============================================
# 颜色定义
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================
# 日志函数
# ============================================
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ============================================
# 变量
# ============================================
SKIP_SUPERPOWERS=false
FORCE=false
TARGET_DIR="${PWD}"
# 兼容 `curl ... | bash` 场景：此时 BASH_SOURCE 可能为空
SCRIPT_SRC="${BASH_SOURCE:-$0}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_SRC}")" && pwd)"
INSTALLER_DIR="$(dirname "${SCRIPT_DIR}")"  # 解压后的父目录（压缩包所在位置）

# 仅在脚本文件实际位于子目录时，自动切换到父目录
# 通过 stdin 执行（curl | bash）时，SCRIPT_SRC 常为 bash，不做目录切换
if [ -f "${SCRIPT_SRC}" ] && [ "${SCRIPT_DIR}" != "${INSTALLER_DIR}" ]; then
    TARGET_DIR="${INSTALLER_DIR}"
    cd "${TARGET_DIR}"
fi

# ============================================
# 解析参数
# ============================================
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-superpowers)
            SKIP_SUPERPOWERS=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --target)
            TARGET_DIR="$2"
            shift 2
            ;;
        --help)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  --skip-superpowers   跳过 superpowers 安装检查"
            echo "  --force              强制覆盖已有文件"
            echo "  --target <path>      指定安装目标目录"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# ============================================
# 前置检查
# ============================================
log_info "开始安装 Harness Suite..."

# 资源完整性检查（避免直接 curl raw 脚本导致缺少目录）
if [ ! -f "${SCRIPT_DIR}/setup/SKILL.md" ] || [ ! -d "${SCRIPT_DIR}/workflow" ] || [ ! -d "${SCRIPT_DIR}/review-skills" ]; then
    log_error "安装资源不完整。请使用 README 中的 tar.gz/zip 安装方式，或在完整仓库目录中执行 install.sh"
fi

# 检查/创建 Claude Code 环境
if [ ! -d "${TARGET_DIR}/.claude" ]; then
    log_warn "检测到 .claude 目录不存在，正在创建..."
    mkdir -p "${TARGET_DIR}/.claude"
    log_success ".claude 目录已创建"
fi

SKILLS_DIR="${TARGET_DIR}/.claude/skills"

# 确保 skills 目录存在
mkdir -p "${SKILLS_DIR}"

# ============================================
# Step 1: 检测/安装 Superpowers
# ============================================
if [ "$SKIP_SUPERPOWERS" = false ]; then
    log_info "检查 Superpowers..."

    if [ -d "${SKILLS_DIR}/superpowers-guide" ]; then
        log_success "Superpowers 已安装"
    else
        log_info "Superpowers 未安装，正在安装..."
        # 这里可以调用 skill-creator 或其他方式安装 superpowers
        # 暂时跳过，用户可后续手动安装
        log_warn "建议稍后执行 /superpowers:install 或手动安装 superpowers"
    fi
fi

# ============================================
# Step 2: 创建扁平化 skill 目录结构
# ============================================
log_info "创建 skill 目录结构..."

HARNESS_SKILLS=(
    "harness-team-setup"
    "harness-team-propose"
    "harness-team-plan"
    "harness-team-prd"
    "harness-team-apply"
    "harness-team-verify"
    "harness-team-fix"
    "harness-team-review"
    "harness-team-archive"
    "harness-team-knowledge"
    "harness-team-run"
    "harness-team-status"
    "harness-team-autopilot"
    "harness-team-workers"
    "prepare-review"
    "spring-architecture-review"
    "sql-risk-review"
)

# workflow 下的 skill 映射到扁平化名称
SKILL_MAP=(
    "workflow/team-propose:harness-team-propose"
    "workflow/team-plan:harness-team-plan"
    "workflow/team-prd:harness-team-prd"
    "workflow/team-apply:harness-team-apply"
    "workflow/team-verify:harness-team-verify"
    "workflow/team-fix:harness-team-fix"
    "workflow/team-review:harness-team-review"
    "workflow/team-archive:harness-team-archive"
    "workflow/team-knowledge:harness-team-knowledge"
    "workflow/team-run:harness-team-run"
    "workflow/team-status:harness-team-status"
    "workflow/team-autopilot:harness-team-autopilot"
    "workflow/team-workers:harness-team-workers"
)

for skill in "${HARNESS_SKILLS[@]}"; do
    mkdir -p "${SKILLS_DIR}/${skill}"
done

# ============================================
# Step 3: 复制 skill 文件
# ============================================
log_info "复制 skill 文件..."

# ============================================
# Step 3: 复制 skill 文件
# ============================================
log_info "复制 skill 文件..."

# 主 setup skill
if [ -f "${SCRIPT_DIR}/setup/SKILL.md" ]; then
    cp "${SCRIPT_DIR}/setup/SKILL.md" "${SKILLS_DIR}/harness-team-setup/SKILL.md"
    log_success "复制 harness-team-setup"
fi

# review-skills
for skill_path in prepare-review spring-architecture-review sql-risk-review; do
    src="${SCRIPT_DIR}/review-skills/${skill_path}/SKILL.md"
    if [ -f "$src" ]; then
        cp "$src" "${SKILLS_DIR}/${skill_path}/SKILL.md"
        log_success "复制 $skill_path"
    fi
done

# workflow skills
for mapping in "${SKILL_MAP[@]}"; do
    IFS=':' read -r src dst <<< "$mapping"
    src_file="${SCRIPT_DIR}/${src}/SKILL.md"
    if [ -f "$src_file" ]; then
        cp "$src_file" "${SKILLS_DIR}/${dst}/SKILL.md"
        log_success "复制 $dst"
    fi
done

# ============================================
# Step 4: 复制 agents 和 hooks
# ============================================
log_info "复制 agents 和 hooks..."

mkdir -p "${TARGET_DIR}/.claude/agents"
mkdir -p "${TARGET_DIR}/.claude/hooks"

if [ -f "${SCRIPT_DIR}/agents/reviewer.md" ]; then
    cp "${SCRIPT_DIR}/agents/reviewer.md" "${TARGET_DIR}/.claude/agents/reviewer.md"
    log_success "复制 reviewer agent"
fi

for hook in guard_write.py ensure_change_context.py run_checks.sh; do
    src="${SCRIPT_DIR}/hooks/${hook}"
    if [ -f "$src" ]; then
        cp "$src" "${TARGET_DIR}/.claude/hooks/${hook}"
        chmod +x "${TARGET_DIR}/.claude/hooks/${hook}"
        log_success "复制 $hook"
    fi
done

# team worker scripts
mkdir -p "${TARGET_DIR}/scripts"
for script in harness-team-autopilot.sh harness-team-workers.sh; do
    src="${SCRIPT_DIR}/scripts/${script}"
    if [ -f "$src" ]; then
        cp "$src" "${TARGET_DIR}/scripts/${script}"
        chmod +x "${TARGET_DIR}/scripts/${script}"
        log_success "复制脚本 ${script}"
    fi
done

# ============================================
# Step 5: 复制规约文件
# ============================================
log_info "复制规约文件..."

for file in AGENTS.md CLAUDE.md REVIEW.md; do
    src="${SCRIPT_DIR}/${file}"
    dst="${TARGET_DIR}/${file}"
    if [ -f "$src" ]; then
        if [ -f "$dst" ] && [ "$FORCE" = false ]; then
            log_warn "${file} 已存在，跳过 (使用 --force 覆盖)"
        else
            cp "$src" "$dst"
            log_success "复制 $file"
        fi
    fi
done

# ============================================
# Step 5.5: 创建 openspec-team 工作目录并复制模板
# ============================================
log_info "创建 openspec-team 工作目录..."

OPENSPEC_TEAM_DIR="${TARGET_DIR}/openspec-team"
OPENSPEC_TEAM_TEMPLATES_DIR="${OPENSPEC_TEAM_DIR}/templates"
TEAM_TEMPLATE_SRC="${SCRIPT_DIR}/docs_template"

mkdir -p "${OPENSPEC_TEAM_DIR}/changes/archive"
mkdir -p "${OPENSPEC_TEAM_DIR}/specs"
mkdir -p "${OPENSPEC_TEAM_DIR}/knowledge"
mkdir -p "${OPENSPEC_TEAM_DIR}/skills"
mkdir -p "${OPENSPEC_TEAM_TEMPLATES_DIR}"
mkdir -p "${HOME}/.harness-team/knowledge"
mkdir -p "${HOME}/.harness-team/skills"

if [ ! -f "${OPENSPEC_TEAM_DIR}/specs/index.md" ]; then
    cat > "${OPENSPEC_TEAM_DIR}/specs/index.md" <<'EOF'
# openspec-team specs

用于维护 Team 工作流相关的规范索引。
EOF
    log_success "创建 openspec-team/specs/index.md"
fi

if [ -d "$TEAM_TEMPLATE_SRC" ]; then
    for tpl in "$TEAM_TEMPLATE_SRC"/*.md; do
        [ -f "$tpl" ] || continue
        file_name="$(basename "$tpl")"
        dst_file="${OPENSPEC_TEAM_TEMPLATES_DIR}/${file_name}"
        if [ -f "$dst_file" ] && [ "$FORCE" = false ]; then
            log_warn "模板 ${file_name} 已存在，跳过 (使用 --force 覆盖)"
        else
            cp "$tpl" "$dst_file"
            log_success "复制 team 模板 ${file_name}"
        fi
    done
fi

# ============================================
# Step 6: 配置 commands
# ============================================
log_info "配置 commands..."

SETTINGS_FILE="${TARGET_DIR}/.claude/settings.json"

COMMANDS_JSON='{
  "harness": {
    "team-setup": "harness-team-setup",
    "team-propose": "harness-team-propose",
    "team-plan": "harness-team-plan",
    "team-prd": "harness-team-prd",
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
}'

if [ -f "$SETTINGS_FILE" ]; then
    # 已有 settings.json，合并 commands
    if grep -q '"commands"' "$SETTINGS_FILE" 2>/dev/null; then
        log_info "检测到已有 commands 配置，需要手动合并"
        log_warn "请手动将以下内容添加到 settings.json 的 commands 字段中:"
        echo "$COMMANDS_JSON"
    else
        # 简单追加 commands（实际生产环境应使用 jq）
        log_info "settings.json 存在，建议手动添加 commands 配置"
    fi
else
    # 创建新的 settings.json
    echo "{\"commands\": $COMMANDS_JSON}" > "$SETTINGS_FILE"
    log_success "创建 settings.json"
fi

# ============================================
# 完成
# ============================================
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Harness Suite 安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "已安装的 Skills:"
for skill in "${HARNESS_SKILLS[@]}"; do
    echo "  - /harness-${skill#harness-}"
done
echo ""
echo "规约文件:"
echo "  - AGENTS.md"
echo "  - CLAUDE.md"
echo "  - REVIEW.md"
echo ""
echo -e "${YELLOW}下一步:${NC}"
echo "  1. 重启 Claude Code 会话使 commands 生效"
echo "  2. 执行 /harness-team-setup 初始化项目"
echo ""

# ============================================
# 清理临时文件
# ============================================
log_info "清理临时文件..."

# 找到压缩包文件名（从下载链接获取或使用默认值）
TARBALL_NAME="harness-suite.tar.gz"

# 删除压缩包
if [ -f "${TARBALL_NAME}" ]; then
    rm -f "${TARBALL_NAME}"
    log_success "已删除压缩包"
fi

# 安全修复：不再自动删除“解压目录/脚本目录”。
# 原逻辑在本地路径执行 install.sh 时可能误删真实项目目录。
# 如需清理，请由用户手动执行。

echo ""
log_success "清理完成"
