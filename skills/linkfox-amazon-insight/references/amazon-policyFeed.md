# 亚马逊政策资讯-查询资讯列表

路径：`/amazon/policyFeed`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_business_insight.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`15`

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| site | string | 否 | `US` | 亚马逊站点代码（大写）。可选值：`US`、`JP`、`UK`、`AU`、`BE`、`BR`、`CA`、`EG`、`FR`、`DE`、`IN`、`IT`、`MX`、`NL`、`PL`、`SA`、`SG`、`ES`、`SE`、`TR`、`AE`、`ZA`、`IE`。站点筛选仅对部分资讯类型生效，部分资讯不区分站点始终返回。 |
| publishedAtGte | string | 否 | 近7天 | 发布/变更时间下界（含），格式 `yyyy-MM-dd HH:mm:ss`。 |
| publishedAtLte | string | 否 | 当前时间 | 发布/变更时间上界（含），格式 `yyyy-MM-dd HH:mm:ss`。 |
| page | integer | 否 | `1` | 页码，从1开始。 |
| pageSize | integer | 否 | `20`；1-100 | 每页条数。 |
