---
name: harness-team-propose
description: 创建 team 需求提案，产出 openspec-team proposal 并明确多 Agent 分工
---

# Team 需求提案（Propose）

## 用途
在 `openspec-team/changes/<change-id>/` 下创建标准化提案，定义目标、边界与验收。

## 使用方式

```text
/harness-team-propose <需求名称>
```

## 执行流程

1. 生成 `change-id`（如 `user-login-20260415-01`）
2. 创建目录：

```text
openspec-team/changes/<change-id>/
├─ proposal.md
└─ notes/
```

3. 写入 proposal 模板（来源：`openspec-team/templates/propose.md`）
4. 标注多 Agent 协作分工：
   - planner：需求澄清
   - architect：技术风险初评
   - verifier：验收项可测试性检查

## 下一步

```text
/harness-team-plan <change-id>
```