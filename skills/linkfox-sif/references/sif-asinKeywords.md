# SIF-ASIN的关键词 API

路径：`/sif/asinKeywords`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/sif_search_intelligence.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`9`

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| asin | string | 是 | — | ASIN 码，最大长度 1000 字符；一次只能查询一个 ASIN |
| country | string | 否 | `US` | 站点：`US`、`UK`、`DE`、`CA`、`JP`、`FR`、`ES`、`IT`、`MX`、`AU`、`AE`、`BR`、`SA` |
| keyword | string | 否 | — | 关键词筛选，最大长度 1000；尽量使用目标站点语言 |
| timePieceType | string | 否 | `latelyDay` | 时间类型：`latelyDay`、`month`、`week` |
| timePieceValue | string | 否 | `7` | 时间片段值，最大长度 1000；`latelyDay` 仅支持 `7` 或 `30`；`month` 为 `YYYY-MM`；`week` 为周开始日期 `YYYY-MM-DD` |
| conditions | string | 否 | — | 逗号分隔条件：`nfPosition`、`isSpAd`、`isBrandAd`、`isVedioAd`、`isAC`、`isAccurateKw`、`isAccurateTailKw`、`isPurchaseKw`、`isQualityKw`、`isStableKw`、`isLossKw`、`isInvalidKw`、`isMultiVariantKw`、`isSearchVolUpKw`、`isSearchVolDownKw`；周期条件：`totalPeriod.in`、`nfKeywordCnt.total`/`.in`、`adKeywordCnt.total`/`.in`、`allSpKeywordCnt.total`/`.in`、`spKeywordCnt.total`/`.in`、`recSpKeywordCnt.total`/`.in`、`allSbKeywordCnt.total`/`.in`、`sbKeywordCnt.total`/`.in`、`sbvKeywordCnt.total`/`.in` |
| sortBy | string | 否 | 空字符串（系统排序） | `lastRank`、`adLastRank`、`updateTime`、`searchesRank`、`estSearchesNum` |
| desc | boolean | 否 | `true` | 是否降序 |
| pageNum | integer | 否 | `1` | 页码 |
| pageSize | integer | 否 | `100` | 每页数量，范围 10–100 |
