import { defineConfig } from "vitepress";

export default defineConfig({
  lang: "zh-CN",
  title: "Super Cursor",
  description: "可安装、可复用、可演进的 Cursor Agent 工作流母版",
  base: "/cursor-ai/",
  head: [["link", { rel: "icon", href: "/cursor-ai/favicon.ico" }]],
  themeConfig: {
    nav: [
      { text: "首页", link: "/" },
      { text: "指南", link: "/guide/quickstart" },
      { text: "参考", link: "/reference/rules-catalog" },
      { text: "培训", link: "/training/skills" },
      {
        text: "GitHub",
        link: "https://github.com/wangqiqi/cursor-ai",
      },
    ],
    sidebar: {
      "/guide/": [
        {
          text: "入门",
          items: [
            { text: "快速开始", link: "/guide/quickstart" },
            { text: "Walkthrough", link: "/guide/walkthrough" },
            { text: "plan · run", link: "/guide/plan-run" },
            { text: "跨平台", link: "/guide/platforms" },
          ],
        },
        {
          text: "协作与构建",
          items: [
            { text: "高效协作", link: "/guide/effective-collaboration" },
            { text: "构建 Super Cursor", link: "/guide/building-super-cursor" },
            { text: "脚手架", link: "/guide/scaffold" },
            { text: "命名约定", link: "/guide/naming" },
          ],
        },
      ],
      "/reference/": [
        {
          text: "参考",
          items: [
            { text: "Rules 目录", link: "/reference/rules-catalog" },
            { text: "迁移目录", link: "/reference/migration-catalog" },
            { text: "外网索引", link: "/reference/library-index" },
          ],
        },
      ],
      "/training/": [
        {
          text: "培训",
          items: [
            { text: "Skills 培训", link: "/training/skills" },
          ],
        },
      ],
    },
    socialLinks: [
      { icon: "github", link: "https://github.com/wangqiqi/cursor-ai" },
    ],
    footer: {
      message: "内容 SSOT：仓库内 .cursor/docs/ · 本站由 sync 镜像生成",
      copyright: "Super Cursor · wangqiqi/cursor-ai",
    },
    docFooter: {
      prev: "上一页",
      next: "下一页",
    },
    outline: {
      label: "目录",
    },
  },
});
