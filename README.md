# Haskell Markdown Parser

一个使用 Haskell 编写的轻量级 Markdown 转 HTML 解析器。

## 支持的语法
* 一级标题 (`#`)
* 普通段落
* 加粗文本 (`**bold**`)
* 样式嵌套 (如 `# **标题**`)

## 项目结构
* `Types.hs`：定义 Token 和 AST (抽象语法树) 数据结构。
* `Scan.hs`：词法分析，将字符串转化为 Token。
* `Parser.hs`：语法分析，将 Token 组装为 AST。
* `Render.hs`：代码生成，将 AST 渲染为 HTML 字符串。
* `Main.hs`：入口文件，处理输入输出流 (IO)。

## 运行方法
1. 确保已安装 GHC。
2. 在项目根目录创建 `input` 和 `output` 文件夹。
3. 将待转换的 `.md` 文件放入 `input` 文件夹。
4. 在终端运行：
   ```bash
   cabal run