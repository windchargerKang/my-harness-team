---
name: harness-team-autopilot
description: 全自动执行 team pipeline，仅在关键决策点请求最少用户交互
---

# Harness Team Autopilot

## 用途
将多阶段工作流自动化执行，用户只需在关键决策点（范围冲突、发布阻断）参与最少交互。

## 使用方式

```text
/harness-team-autopilot <需求描述>
/harness-team-autopilot <需求描述> --quick
/harness-team-autopilot <需求描述> --strict
```

## 自动流水线

```text
team-propose -> team-plan -> team-prd -> team-apply -> team-verify -> team-fix(loop) -> team-review -> team-archive -> team-knowledge
```

## 最少交互点
仅在以下情况询问用户：
1. 需求边界冲突（proposal 与现有约束冲突）
2. fix-loop 连续 3 次未收敛（需要人工决策）
3. review 给出 `NEEDS_DECISION`（仲裁冲突）
4. strict 模式下回滚策略不完整

## 可视化建议
若要观察各子智能体过程，先执行：

```text
/harness-team-workers start <change-id>
```

再执行 autopilot。