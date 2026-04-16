# Harness Suite

基于 Team-First 思想 + Superpowers 工作流的多智能体研发规约框架。

## 理念

**战略设计（Team Plan）** + **战术执行（Team Apply）** + **闭环验证（Verify/Fix/Review）** = **高效且可追溯的 AI 协作开发**

## 与 harness-suite 的关系

`my-harness-team` 可以理解为 `harness-suite` 的 Team-First 进化版：

- **继承**：沿用原来的规范化工程思路（proposal/plan/apply/review/archive/knowledge）
- **升级**：统一为 `harness-team-*` 命令体系，工作目录升级为 `openspec-team/`
- **增强**：引入多智能体分工、verify/fix 闭环、PRD(GWT) 验收合同、tmux worker 可视化

如果你之前使用的是 `harness-suite`，可以把本项目作为“兼容思维框架 + 强化执行编排”的下一代替换方案。

## 安装

### 一键安装

```bash
# 在你的 Claude Code 项目根目录执行（推荐，避免 curl|bash 丢失资源文件）
curl -fsSL "https://github.com/windchargerKang/my-harness-team/archive/refs/heads/main.tar.gz" \
  | tar -xz && \
bash my-harness-team-main/install.sh --target "$(pwd)" && \
rm -rf my-harness-team-main
```

或 PowerShell（Windows）：

```powershell
# 推荐：下载仓库压缩包后执行本地脚本（避免远程脚本缺少资源文件）
irm "https://github.com/windchargerKang/my-harness-team/archive/refs/heads/main.zip" -OutFile harness-team.zip
Expand-Archive -Path harness-team.zip -DestinationPath . -Force
powershell -ExecutionPolicy Bypass -File .\my-harness-team-main\install.ps1 -Target (Get-Location)
Remove-Item -Recurse -Force .\my-harness-team-main, .\harness-team.zip
```

### 参数

| 参数                   | 说明                  |
| -------------------- | ------------------- |
| `--skip-superpowers` | 跳过 superpowers 安装检查 |
| `--force`            | 强制覆盖已有文件            |
| `--target <path>`    | 指定安装目标目录            |

### 安装后

1. 重启 Claude Code 会话使 commands 生效
2. 执行 `/harness-team-setup` 初始化项目

## 目录结构（源码）

```text
harness-suite/
├── setup/                      # Team 初始化入口
│   └── SKILL.md
├── workflow/                   # Team 工作流 Skills
│   ├── team-propose/
│   ├── team-plan/
│   ├── team-apply/
│   ├── team-verify/
│   ├── team-fix/
│   ├── team-review/
│   ├── team-archive/
│   ├── team-knowledge/
│   ├── team-run/
│   └── team-status/
├── review-skills/              # 专项评审
│   ├── prepare-review/
│   ├── spring-architecture-review/
│   └── sql-risk-review/
├── agents/
│   └── reviewer.md
├── hooks/
│   ├── guard_write.py
│   ├── ensure_change_context.py
│   └── run_checks.sh
├── docs_template/
│   ├── architecture/
│   ├── product/
│   ├── standards/
│   ├── specs/
│   ├── propose.md
│   ├── plan.md
│   ├── tasks.md
│   ├── verify-report.md
│   └── review-report.md
├── AGENTS.md
├── CLAUDE.md
└── REVIEW.md
```

## Team 流程（OMC 风格）

```text
/harness-team-plan -> /harness-team-prd -> /harness-team-apply -> /harness-team-verify -> /harness-team-fix(loop) -> /harness-team-review -> /harness-team-archive -> /harness-team-knowledge
```

说明：`/harness-team-propose` 作为需求进入点，用于先创建 change-id 与 proposal。

工作目录统一使用：`openspec-team/`

## 快速开始

```text
/harness-team-setup
/harness-team-propose 用户登录功能
/harness-team-plan user-login-20260415-01
/harness-team-prd user-login-20260415-01
/harness-team-apply user-login-20260415-01
/harness-team-verify user-login-20260415-01
/harness-team-review user-login-20260415-01
/harness-team-archive user-login-20260415-01
/harness-team-knowledge user-login-20260415-01
```

一键执行：

```text
/harness-team-run 用户登录功能
/harness-team-run 用户登录功能 --quick
/harness-team-run 用户登录功能 --strict
```

状态查看：

```text
/harness-team-status user-login-20260415-01
```

全自动（最少交互）：

```text
/harness-team-autopilot 用户登录功能 --strict
```

tmux 可视化 worker：

```text
/harness-team-workers start user-login-20260415-01
/harness-team-workers status user-login-20260415-01
/harness-team-workers attach user-login-20260415-01
/harness-team-workers stop user-login-20260415-01
```

## 多智能体分工

- **planner**：需求边界与任务拆解
- **architect**：方案权衡与风险控制
- **prd-agent**：GWT 验收合同固化
- **executor**：按里程碑实现
- **verifier**：质量门禁与回归验证
- **reviewer**：并行评审与发布门禁（含冲突仲裁）

## 与 Superpowers 的关系

| 阶段  | 调用                                           | 作用         |
| --- | -------------------------------------------- | ---------- |
| 设计  | `superpowers:brainstorming`                  | 深度探索、权衡分析  |
| 执行  | `superpowers:implementing-plans`             | 计划执行、里程碑管理 |
| 验证  | `superpowers:verification-before-completion` | 里程碑检查      |
| 评审  | `superpowers:receive-code-review`            | 代码质量审查     |
| 汇总  | `superpowers:requesting-code-review`         | 最终评审汇总     |

## 与 harness-suit 的关系

`my-harness-team` 可以理解为 `harness-suit` 的 Team-first 迭代版：保留规范驱动思路，但统一迁移到多智能体编排与闭环执行。

### 迁移对照表

| harness-suit（旧） | my-harness-team（新） | 说明 |
| --- | --- | --- |
| `/harness-setup` | `/harness-team-setup` | 初始化入口统一 team 命名 |
| `/harness-propose` | `/harness-team-propose` | 创建变更提案 |
| `/harness-plan` | `/harness-team-plan` | 方案设计与任务分解 |
| - | `/harness-team-prd` | **新增**：固化可执行 PRD 与 GWT 验收合同 |
| `/harness-apply` | `/harness-team-apply` | 里程碑执行实现 |
| - | `/harness-team-verify` | **新增**：质量门禁验证阶段 |
| - | `/harness-team-fix` | **新增**：验证失败后的修复循环 |
| `/harness-review` | `/harness-team-review` | 并行评审（含冲突仲裁） |
| `/harness-archive` | `/harness-team-archive` | 归档变更工件 |
| `/harness-knowledge` | `/harness-team-knowledge` | 知识沉淀与复用 |
| - | `/harness-team-run` | **新增**：一键流水线（支持 `--quick/--strict`） |
| - | `/harness-team-status` | **新增**：阶段状态与阻塞可视化 |
| - | `/harness-team-autopilot` | **新增**：全自动执行（最少交互） |
| - | `/harness-team-workers` | **新增**：tmux worker 可视化（start/status/attach/stop） |

### 关键升级点

- 工作目录从 `openspec/` 迁移为 `openspec-team/`
- 流水线从“手动逐阶段触发”升级为“staged pipeline + verify/fix 闭环”
- 引入多智能体角色分工（planner/architect/prd-agent/executor/verifier/reviewer）
- 支持 tmux worker 可视化与自动化执行

## 小白使用手册

- [点这里查看《小白使用手册》](./小白使用手册.md)

## License

MIT