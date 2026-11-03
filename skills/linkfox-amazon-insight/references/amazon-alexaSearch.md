# 亚马逊 Alexa 购物助手

路径：`/amazon/alexaSearch`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_front_data.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：按动态规则计费，消耗积分 = 对话轮次 × 12.6；每次请求仅支持 1 条 prompt。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `prompts` | string[] | 是 | — | 长度在 255 个字符以内的对话提示词数组，仅支持 1 条；每次调用只能传入 1 个问题。跨次追问时需由 agent 总结上一轮上下文并作为新的 `prompts[0]` 传入。 |
| `format` | string | 否 | `markdown` | 响应格式：`markdown` 返回可读报告；`json` 返回结构化数据数组。 |
| `url` | string | 否 | — | 用于补充 Alexa 页面上下文的具体分类页、搜索结果页或商品详情页 URL；不要传亚马逊首页 URL。 |
