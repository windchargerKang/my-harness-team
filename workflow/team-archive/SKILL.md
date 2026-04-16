---
name: harness-team-archive
description: 归档完成的 team change，将工件移动到 openspec-team/archive
---

# Team 归档（Archive）

## 用途
将完成的 change 工件归档到 `openspec-team/changes/archive/`，保持工作区整洁。

## 使用方式

```text
/harness-team-archive <change-id>
```

## 执行流程

1. 前置检查：
   - `openspec-team/changes/<change-id>/` 存在
   - review 结论为通过或有条件通过
2. 生成归档记录：需求摘要、方案摘要、实现摘要、评审结论
3. 归档路径：

```text
源：openspec-team/changes/<change-id>/
目标：openspec-team/changes/archive/<change-id>-<timestamp>/
```

4. 更新 archive 索引

## 下一步

```text
/harness-team-knowledge <change-id>
```