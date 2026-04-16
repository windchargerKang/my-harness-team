---
name: harness-team-plan
description: 战略设计 + 任务分解，调用 brainstorming 生成 plan.md 和 tasks.md
---

# Team 战略设计与任务分解（Plan）

## 用途
读取 proposal，调用 `superpowers:brainstorming` 输出可执行计划与任务。

## 使用方式

```text
/harness-team-plan <change-id>
```

## 执行流程

1. 前置检查：
   - `openspec-team/changes/<change-id>/proposal.md` 必须存在
2. 读取上下文：proposal + docs（architecture/product/standards）
3. 多 Agent 计划协作：
   - planner：任务拆解与里程碑
   - architect：方案权衡与风险
   - verifier：门禁与测试策略
4. 生成：

```text
openspec-team/changes/<change-id>/plan.md
openspec-team/changes/<change-id>/tasks.md
```

## 输出要求
- plan：方案、影响范围、风险、回滚策略
- tasks：里程碑任务 + 质量门禁

## 下一步

```text
/harness-team-apply <change-id>
```