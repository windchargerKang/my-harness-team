---
name: harness-team-apply
description: 执行实现，读取 tasks.md，按多 Agent 分工推进里程碑
---

# Team 执行实现（Apply）

## 用途
读取 `tasks.md` 并按里程碑执行开发，保持范围受控并记录执行偏差。

## 使用方式

```text
/harness-team-apply <change-id>
```

## 执行流程

1. 前置检查：
   - `openspec-team/changes/<change-id>/tasks.md` 必须存在
2. 读取工件：
   - proposal.md
   - plan.md
   - tasks.md
3. 多 Agent 执行协作：
   - executor：实现任务
   - architect：关键改动点审查
   - verifier：每个 milestone 后做轻量验证
4. 调用 `superpowers:executing-plans` 按 milestone 推进

## 执行约束
- 不得超出 tasks 范围扩需求
- 每个 milestone 必须记录：完成项 / 风险 / 待确认事项

## 下一步

```text
/harness-team-verify <change-id>
```