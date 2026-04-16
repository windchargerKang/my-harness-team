---
name: harness-team-setup
description: 初始化 Harness Team 工作流，自动探索项目背景并创建 openspec-team 规范目录
---

# Harness Team Setup

## 目的

自动探索项目背景，生成个性化配置，并初始化 Team 规范目录：`openspec-team/`。

该流程融合多 Agent 协作思想：
- planner：需求澄清与范围边界
- architect：方案设计与风险识别
- executor：按任务实现
- verifier：验证与回归
- reviewer：并行评审与发布门禁

---

## Step 1: 自动探索项目

### 静默检测

```text
========================================
  正在探索你的项目...
========================================

  ├─ 检测项目类型...
  ├─ 分析目录结构...
  ├─ 识别技术栈...
  ├─ 扫描现有文档...
  └─ 生成个性化配置...
```

### 检测内容

| 检测项 | 方式 | 输出 |
|--------|------|------|
| 项目类型 | 检测 pom.xml/package.json/build.gradle | Spring/FE/Android/iOS/其他 |
| 目录结构 | 扫描 src/ | 模块列表 |
| 技术栈 | 扫描依赖文件 | 框架、ORM、测试框架 |
| 现有文档 | 检测 docs/ + openspec-team | 已有规范资产 |
| 构建命令 | 检测构建文件 | mvn/npm/gradle |

---

## Step 2: 用户确认

```text
┌─────────────────────────────────────────┐
│  检测结果是否符合你的预期？               │
│                                         │
│    [确认]  → 使用以上配置，生成文档      │
│    [讨论]  → 告诉我需要修改的地方       │
└─────────────────────────────────────────┘
```

---

## Step 3: 初始化规范目录

```text
openspec-team/
├─ changes/
│  └─ archive/
├─ specs/
│  └─ index.md
└─ templates/              # 来自 docs_template/team/
```

### 模板来源

- `docs_template/`：基础 docs 结构模板
- `docs_template/team/`：team 流程模板（propose/plan/tasks/verify/review）

---

## Step 4: 完成提示与下一步

```text
下一步（Team 流程）：
  /harness-team-propose <需求名称>
  /harness-team-plan <change-id>
  /harness-team-apply <change-id>
  /harness-team-verify <change-id>
  /harness-team-review <change-id>
  /harness-team-archive <change-id>
```

---

## 命令入口

```text
/harness-team-setup
/harness-team-setup --auto
/harness-team-setup --force
/harness-team-setup --help
```

---

## 关键说明

1. 仅使用 `openspec-team/`，不再使用 `openspec/`。  
2. Team 流程默认采用多 Agent 分工：plan -> apply -> verify -> review -> fix-loop。  
3. 所有命令统一为 `harness-team-*`。