# 亚马逊商业洞察-生成关键词报告

路径：`/amazon/opportunity/reportByKeyword`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_business_insight.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：输入消耗的算力 + 7.5 × 输出消耗的算力。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| site | string | 是 | - | 亚马逊站点代码，当前仅支持 `US`。 |
| keyword | string | 是 | - | 要查询洞察报告的搜索关键词。 |
