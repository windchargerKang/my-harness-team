---
name: harness-team-review
description: 并行执行多维评审，按仲裁规则输出统一发布结论
---

# Team 并行评审（Review）

## 用途
读取 team 工件和代码改动，并行执行多维评审，并通过“多 Agent 仲裁规则”输出统一结论。

## 使用方式

```text
/harness-team-review <change-id>
```

## 执行流程

1. 读取上下文：
   - `openspec-team/changes/<change-id>/proposal.md`
   - `openspec-team/changes/<change-id>/plan.md`
   - `openspec-team/changes/<change-id>/prd.md`
   - `openspec-team/changes/<change-id>/tasks.md`
   - `openspec-team/changes/<change-id>/verify-report.md`（如存在）
2. 并行评审：
   - `superpowers:receive-code-review`（主评审）
   - `prepare-review`（变更摘要）
   - `spring-architecture-review`（架构边界）
   - `sql-risk-review`（SQL 风险）


   
3. reviewer Agent 汇总：
   - 问题分级（P0/P1/P2）
   - 发布建议（go / conditional-go / no-go）

## 多 Agent 仲裁规则（冲突决策）

当多个评审结论冲突时，按以下优先级仲裁：

1. **安全与数据正确性优先**
   - 任意评审命中安全/数据破坏类 P0，直接 `no-go`
2. **阻断项优先于通过项**
   - 只要存在未关闭 P0/P1，不得判定 `go`
3. **专项评审可覆盖主评审乐观结论**
   - 例如主评审通过，但 SQL/架构专项给出 P1 阻断，则以阻断为准
4. **证据优先**
   - 需要附“文件/行号/复现步骤/风险说明”，无证据项降级为建议
5. **无法裁决时升级人工**
   - 标记 `NEEDS_DECISION`，输出 A/B 方案、影响与建议

## 输出

```text
openspec-team/changes/<change-id>/review-report.md
```

输出需包含：
- 冲突点列表
- 仲裁过程与依据
- 最终发布结论（go/conditional-go/no-go）

## 下一步
- 通过：`/harness-team-archive <change-id>`
- 未通过：`/harness-team-fix <change-id>`