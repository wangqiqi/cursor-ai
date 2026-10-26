# AGENTS.md

本仓库是 **Super Cursor** 母版：`.cursor/` 是可安装、可复用、可演进的 Agent 工作流模板（rules · skills · hooks · config · templates）。

- **细节索引** → assemble 后 `.cursor/AGENTS.md`（源：`harness/core/AGENTS.md`）· 母版布局 → [`.cursor/harness/README.md`](.cursor/harness/README.md)
- **改本仓库** → 直接改 `.cursor/`（母版可自由演进）；**项目特化**一律进 `.growing/`（gitignore）
- **验收** → `bash .cursor/template-verify.sh`（先 assemble；母版全量 verify）
- **入口** → `/master`（迷路）· `/plan`（拆 Sprint）· `/run`（做事）

> 安装到**其它项目**后，根 `AGENTS.md` 由该项目自行维护；本文件属于母版仓库，不随 `.cursor/` 复制。
