---
name: harness-team-knowledge
description: 管理项目级与用户级知识/技能沉淀，支持多 Agent 经验复用
---

# Team 知识沉淀（Knowledge）

## 用途
沉淀并复用多 Agent 协作中的经验模式，形成“项目级 + 用户级”双层知识体系。

## 使用方式

```text
/harness-team-knowledge
/harness-team-knowledge add
/harness-team-knowledge edit <id>
/harness-team-knowledge clean
/harness-team-knowledge export
```

## 双层知识目录约定
- 项目级：`openspec-team/knowledge/`、`openspec-team/skills/`
- 用户级：`~/.harness-team/knowledge/`、`~/.harness-team/skills/`

## 知识来源
- `team-apply`：实现阶段发现的约定与坑点
- `team-verify`：验证阶段发现的回归模式
- `team-review`：评审阶段发现的架构/SQL/规范风险
- `team-fix`：修复阶段形成的根因与防复发策略

## 条目模板（推荐）
1. 问题现象
2. 根因分析
3. 修复动作
4. 预防策略
5. 触发关键词（用于后续自动注入）

## 目标
让后续 `harness-team-*` 流程可自动复用历史经验，减少重复踩坑。