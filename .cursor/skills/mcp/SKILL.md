---
name: mcp
description: MCP 服务器集成与工具设计要点。
---

# mcp

## 设计

- 一工具一职责；schema 描述清楚参数与错误
- 只读工具默认安全；写操作须明确确认边界
- 无密钥进 repo；env 或 Cursor MCP 配置注入

## 实现

- 参考 Cursor MCP 文档与项目已有 server 结构
- stdio vs HTTP：跟部署环境一致
- 日志不泄露 token 或 PII

## 验证

- 本地 `CallMcpTool` 或 inspector 试跑
- 失败信息可 actionable
