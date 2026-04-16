---
name: harness-team-workers
description: 使用 tmux 启动/查看/关闭多 Agent worker，可视化执行过程
---

# Harness Team Workers（tmux 可视化）

## 用途
使用 tmux 创建可视化 worker 面板，让 planner/executor/verifier/reviewer 过程可观察。

## 使用方式

```text
/harness-team-workers start <change-id>
/harness-team-workers status <change-id>
/harness-team-workers attach <change-id>
/harness-team-workers stop <change-id>
```

## 面板规划（默认）
- pane 1: planner
- pane 2: executor
- pane 3: verifier
- pane 4: reviewer

## 脚本入口
实际执行由 `scripts/harness-team-workers.sh` 完成。