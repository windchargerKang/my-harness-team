---
name: harness-team-run
description: 一键执行 team-first 流水线（plan -> prd -> apply -> verify -> fix-loop -> review），支持 quick/strict 模式
---

# Harness Team Run

## 用途
按 OMC 风格执行 staged pipeline，强调“执行 + 验证 + 修复循环”，而不是一次性生成代码。

## 使用方式

```text
/harness-team-run <需求名称|change-id>
/harness-team-run <需求名称|change-id> --quick
/harness-team-run <需求名称|change-id> --strict
```

## 流水线（固定）

```text
team-plan -> team-prd -> team-apply -> team-verify -> team-fix(loop) -> team-review
```

> 通过 review 后再执行 `team-archive` 与 `team-knowledge`。

## 多 Agent 分工
- planner：任务拆解、优先级与里程碑
- prd-agent：验收合同、需求完整性
- executor：实现代码与重构
- verifier：测试与门禁
- reviewer：并行评审汇总与发布建议

## 运行模式

### `--quick`（快速模式）
适用：低风险小改动、非核心路径修复

门禁：
- lint 通过
- 关键路径最小测试集通过
- P0 = 0（允许 P1 留待后续）

### `--strict`（严格模式）
适用：核心业务、数据库变更、高风险发布

门禁：
- lint = 0
- 全量回归通过（按项目策略）
- PRD GWT 验收条目通过率 = 100%
- review 阻断项 P0/P1 = 0
- 必须输出回滚预案与验证证据

### 默认模式（未指定）
介于 quick 与 strict 之间：
- lint 通过
- 关键测试通过
- P0/P1 = 0
- 主要验收条目通过

## Fix Loop 规则
1. `team-verify` 失败 -> 进入 `team-fix`
2. `team-fix` 后强制回到 `team-verify`
3. 连续 3 次循环不收敛 -> 标记 `BLOCKED`，输出人工决策项

## 收尾
- `team-archive`：归档 change 工件
- `team-knowledge`：沉淀可复用经验（问题-原因-修复-预防）