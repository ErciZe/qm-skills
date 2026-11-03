# 谷歌趋势-关键词趋势信息 API 参考

路径：`/googleTrend/getTrendByKeys`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/google_tools.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`6` 算力

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| keyword | string | 是 | - | 关键词，必须使用目标国家/地区的语言；最大长度 100 个字符。 |
| region | string | 否 | `US` | 国家/地区代码。可选值：`US`、`GB`、`JP`、`CA`、`MX`、`DE`、`FR`、`IT`、`ES`、`NL`、`AU`、`SG`、`AE`、`BR`、`IN`、`TR`、`PL`、`SE`。 |
| dayRangeStart | string | 否 | - | 时间范围开始时间；格式为 `YYYY-MM-DD`，从 2004 年开始。 |
| dayRangeEnd | string | 否 | - | 时间范围结束时间；格式为 `YYYY-MM-DD`，从 2004 年开始。 |

> 当同时提供 `dayRangeStart` 和 `dayRangeEnd` 时，自定义时间范围优先。
