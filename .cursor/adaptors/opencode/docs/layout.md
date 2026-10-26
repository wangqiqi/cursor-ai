# OpenCode `.opencode/` 布局（Super Cursor · `includes: core`）

OpenCode 官方安装根 **待确认**（见 [opencode.ai/docs](https://opencode.ai/docs)）；本布局与 **dsh** 相同假设：Harness Core 平铺到 `.opencode/`。

## 目标路径

| 项 | 值 |
|----|-----|
| 安装根 | **`.opencode/`** |
| Growth | **`.growing/`**（共享） |
| hooks | **无** |

## 目录树

同 [dsh layout](../../dsh/docs/layout.md)（将 `.dsh` 换为 `.opencode`）。

## 安装

```bash
bash .cursor/harness/core/bin/install-adaptor-opencode.sh /path/to/project
install-super-cursor /path/to/project --adaptor opencode
```

## 验收

`bash .cursor/bin/verify-install-opencode.sh`
