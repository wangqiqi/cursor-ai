# AGENTS.md

本仓库是 **Super Cursor** 母版：`.cursor/` 是可安装、可复用、可演进的 Agent 工作流模板（rules · skills · hooks · config · templates）。

- **细节索引** → [`.cursor/AGENTS.md`](.cursor/AGENTS.md)（skills · rules · agents 全表）
- **改本仓库** → 直接改 `.cursor/`（母版可自由演进）；**项目特化**一律进 `.cursorGrowth/`（gitignore）
- **验收** → `bash .cursor/bin/template-verify.sh`（母版全量；含安装/消费方/接线/可移植性/配置校验）
- **入口** → `/master`（迷路）· `/plan`（拆 Sprint）· `/run`（做事）

> 安装到**其它项目**后，根 `AGENTS.md` 由该项目自行维护；本文件属于母版仓库，不随 `.cursor/` 复制。
