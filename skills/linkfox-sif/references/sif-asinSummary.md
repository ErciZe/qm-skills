# SIF-ASIN流量来源 API

路径：`/sif/asinSummary`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/sif_search_intelligence.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`9`

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| searchValue | string | 是 | — | ASIN 码，多个用逗号分隔，最多 10 个，最大长度 1000 字符 |
| country | string | 否 | `US` | 站点：`US`、`UK`、`DE`、`CA`、`JP`、`FR`、`ES`、`IT`、`MX`、`AU`、`AE`、`BR`、`SA` |
| last7d | boolean | 否 | `true` | 是否取最近 7 天；为 `false` 时使用日期区间 |
| startDate | string | 否 | — | `yyyy-MM-dd`；`last7d=false` 时生效 |
| endDate | string | 否 | — | `yyyy-MM-dd`；与 `startDate` 配套 |
| conditions | string | 否 | — | 逗号分隔：`nf`、`sp`、`sb`、`sbv`、`ad`、`acAd`、`totalPeriod.in` |
| sortBy | string | 否 | — | `totalKeywordNum`、`naturalKeywordNum`、`brandKeywordNum`、`vedioKeywordNum`、`acKeywordNum`、`erKeywordNum`、`trKeywordNum`、`sumScore`、`totalNfScore`、`totalSpSocre`、`totalBrandScore`、`totalVedioScore`、`totalAcScore`、`totalTrScore`、`totalErScore` |
| pageNum | integer | 否 | `1` | 页码 |
| pageSize | integer | 否 | `10000` | 每页数量，范围 10–10000 |
| desc | boolean | 否 | `true` | 是否降序 |
