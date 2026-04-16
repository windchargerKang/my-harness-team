---
name: harness-team-status
description: 查看当前 change 的阶段、门禁结果、循环状态与下一步建议
---

# Team 状态查看（Status）

## 用途
快速定位当前 change 在 staged pipeline 中的位置，以及是否被 fix-loop 阻塞。

## 使用方式

```text
/harness-team-status <change-id>
```

## 输出维度
- 当前阶段（plan/prd/apply/verify/fix/review/archive/knowledge）
- 最新 verify 结果（lint/tests/acceptance）
- 最新 review 分级（P0/P1/P2）
- fix-loop 迭代次数
- 阻塞项与建议动作

## 建议动作示例
- `verify` 失败：`/harness-team-fix <change-id>`
- `review` 阻断：`/harness-team-fix <change-id>` 后回到 verify
- 全部通过：`/harness-team-archive <change-id>`