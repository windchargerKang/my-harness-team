# 文档模板说明

## 目录结构

本目录为模板文件集合：
- `docs/` 相关模板（architecture/product/standards/specs）
- `openspec-team/templates/` 初始化模板（propose/plan/tasks/verify/review）

在执行 `/harness-team-setup` 或安装脚本时，这些模板会复制到目标项目。

另外，`docs_template/design/` 用于预置前端设计规范与模板资源，安装时会复制到 `openspec-team/design/`。

## 各目录用途

| 目录/文件 | 用途 |
|------|------|
| `architecture/` | 架构知识、隐性约定 |
| `product/` | 产品规则、接口规范 |
| `standards/` | 测试规范、SQL 规范 |
| `specs/` | 系统技术规格参考 |
| `propose.md` | team 提案模板 |
| `plan.md` | team 方案模板 |
| `tasks.md` | team 任务模板 |
| `verify-report.md` | team 验证报告模板 |
| `review-report.md` | team 评审报告模板 |

## openspec-team 目录说明

`openspec-team/` 目录**不在**仓库中预置，它由 setup/install 动态创建；其中 `openspec-team/design/` 会由 `docs_template/design/` 初始化：

```text
openspec-team/
├─ changes/
│  ├─ <change-id>/        ← 每次 /harness-team-propose 时创建
│  └─ archive/            ← 每次 /harness-team-archive 时归档
├─ specs/
│  └─ index.md
├─ knowledge/             ← 项目级知识沉淀
├─ skills/                ← 项目级可复用技能
└─ templates/             ← 由 docs_template/*.md 初始化

~/.harness-team/
├─ knowledge/             ← 用户级知识沉淀
└─ skills/                ← 用户级可复用技能
```

**原因**：`openspec-team` 是工作目录，内容随项目演进，不适合作为静态模板直接放仓库根目录。