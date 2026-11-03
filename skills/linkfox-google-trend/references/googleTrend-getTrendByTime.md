# 谷歌趋势-时下流行 API 参考

路径：`/googleTrend/getTrendByTime`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/google_tools.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`6` 算力

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| days | integer | 否 | `7` | 时间范围，查询最近多少天的趋势数据。常用值：1、2、7。 |
| region | string | 否 | `US` | 国家/地区代码。可选值：`US`、`GB`、`JP`、`CA`、`MX`、`DE`、`FR`、`IT`、`ES`、`NL`、`AU`、`SG`、`AE`、`BR`、`IN`、`TR`、`PL`、`SE`。 |
