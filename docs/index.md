---
layout: home

hero:
  name: Super Cursor
  text: Agent 工作流母版
  tagline: 先规划 · 再执行 · 可验收 · 能收尾 · 能发版
  actions:
    - theme: brand
      text: 快速开始
      link: /guide/quickstart
    - theme: alt
      text: plan · run
      link: /guide/plan-run
    - theme: alt
      text: GitHub
      link: https://github.com/wangqiqi/cursor-ai

features:
  - title: 可安装
    details: install-super-cursor.sh 一次拷贝 rules · skills · hooks · config 到目标项目。
  - title: 可验收
    details: gate-check · task-verify · verify 分层；plan/run 闸门减少 Agent 乱改。
  - title: 可演进
    details: 项目特化进 .cursorGrowth/（gitignore），母版 .cursor/ 保持通用 SOP。
  - title: 三指令日常
    details: /plan 拆 Sprint · /run 执行 · /master 迷路路由；生命周期 scaffold · learn · release。
---

## 一句话

把「怎么和 Agent 协作」从聊天口头约定，变成 **rules + skills + hooks + config** —— 装一次，每个仓库都能用。

```bash
git clone https://github.com/wangqiqi/cursor-ai.git
cd cursor-ai
./install-super-cursor.sh /path/to/your-project --profile full
```

文档正文镜像自 [`.cursor/docs/`](https://github.com/wangqiqi/cursor-ai/tree/master/.cursor/docs)；本地开发：`npm run docs:dev`。
