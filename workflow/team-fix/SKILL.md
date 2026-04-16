---
name: harness-team-fix
description: 基于 verify/review 失败项执行修复，直到满足退出条件
---

# Harness Team Fix

## 用途
处理验证与评审失败项，执行修复闭环。

## 使用方式

```text
/harness-team-fix <change-id>
```

## 执行要点
1. 读取 verify/review 报告中的阻断项。
2. 执行最小修复并补充必要测试。
3. 修复后回到 `/harness-team-verify <change-id>`。
4. 连续多次失败应输出阻塞原因并请求人工决策。
