---

name: prepare-review
description: 在 review 或提 PR 前，整理一份 Spring Boot 变更摘要

---

# 生成评审摘要

## 适用范围

用于在 review 或提 PR 前，快速整理本次变更的核心信息，便于后续专项评审和人工复核。

## 输入

`$ARGUMENTS` = OpenSpec 的 change id

## 必须阅读

- `openspec/changes/$ARGUMENTS/proposal.md`
- `openspec/changes/$ARGUMENTS/design.md`
- `openspec/changes/$ARGUMENTS/tasks.md`
- 相关源码改动
- `docs/standards/testing.md`
- `docs/standards/database.md`

## 输出内容

### 变更目标
简述本次变更要解决的问题。

### 影响到的类和模块
列出主要改动的文件/模块。

### 是否涉及
- [ ] 接口（API）变更
- [ ] 数据库/SQL 变更
- [ ] 事务边界变化
- [ ] 配置变更
- [ ] 新增外部依赖

### 已运行测试
- [ ] 单元测试
- [ ] 集成测试
- [ ] 其他验证

### 已知风险
列出已识别的风险点。

### 仍未解决的问题
列出尚未完全解决或有疑问的点。

## 规则

- 不要写空洞表扬。
- 保持简洁、事实化。
- 优先标出风险和未完成项。
- 如果本次变更同时涉及 Spring 分层或 SQL 风险，可继续结合专项 review skill 使用。
