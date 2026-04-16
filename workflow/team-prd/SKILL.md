---
name: harness-team-prd
description: 基于 team-plan 生成可执行 PRD 与验收合同（固定 GWT 模板）
---

# Team PRD（Product Requirements Definition）

## 用途
在方案已确定后，生成“可执行 PRD + 验收合同”，确保后续 apply/verify/fix 有统一标准。

## 使用方式

```text
/harness-team-prd <change-id>
```

## 执行流程

1. 前置检查：
   - `openspec-team/changes/<change-id>/proposal.md`
   - `openspec-team/changes/<change-id>/plan.md`
   - `openspec-team/changes/<change-id>/tasks.md`
2. 多 Agent PRD 协作：
   - planner：目标与范围固化
   - architect：技术边界与非功能约束
   - verifier：可测试验收条目（Given/When/Then）
3. 产出：

```text
openspec-team/changes/<change-id>/prd.md
```

## PRD 必须包含
- 目标与非目标
- 用户场景与关键路径
- 功能/非功能需求
- 验收标准（可自动验证）
- 风险、回滚与发布策略

## 固定 GWT 验收模板（必须）

每条验收标准统一使用以下格式：

```markdown
### AC-<序号>: <标题>
Given <前置条件>
When <触发动作>
Then <预期结果>
And <补充结果/边界条件>

验证方式：<自动化测试|手工验证|日志校验>
证据要求：<测试名/截图/日志路径>
```

### 示例

```markdown
### AC-01: 登录成功跳转首页
Given 用户已注册且账号状态正常
When 用户输入正确账号密码并点击登录
Then 系统返回 200 且签发有效会话
And 前端跳转到首页并展示用户昵称

验证方式：自动化测试
证据要求：auth.login.success.spec.ts
```

## 下一步

```text
/harness-team-apply <change-id>
```