---
name: harness-team-verify
description: 统一质量门禁验证，生成 verify-report 并决定是否进入 fix-loop
---

# Harness Team Verify

## 用途
执行 lint/test/build/验收检查，形成验证结论。

## 使用方式

```text
/harness-team-verify <change-id>
```

## 执行要点
1. 运行质量门禁检查并记录结果。
2. 输出 `verify-report.md`。
3. 若失败，指向 `/harness-team-fix <change-id>`。
4. 若通过，进入 `/harness-team-review <change-id>`。
