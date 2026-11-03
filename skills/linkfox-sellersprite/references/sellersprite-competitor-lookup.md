# 卖家精灵-查竞品

路径：`/sellersprite/competitor-lookup`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/sellersprite.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：15 积分

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| marketplace | string | 否 | `US` | 亚马逊站点代码：`US`、`UK`、`DE`、`FR`、`JP`、`CA`、`IT`、`ES`、`MX`、`AU`、`TR`、`IN` |
| keyword | string | 否 | — | 搜索关键词，建议使用目标站点语言 |
| asinList | string | 否 | — | ASIN，多个 ASIN 使用英文逗号分隔，最多40个；格式：`^[A-Z0-9]+(,[A-Z0-9]+){0,39}$` |
| sellerName | string | 否 | — | 卖家名称筛选 |
| brand | string | 否 | — | 品牌名称筛选 |
| nodeLabel | string | 否 | — | 亚马逊类目名称，支持多层级类目名称，层级之间用英文冒号 `:` 分隔 |
| nodeIdPath | string | 否 | — | 亚马逊类目 ID 路径 |
| matchType | integer | 否 | `1` | 匹配方式：`1` 词组匹配、`2` 模糊匹配、`3` 精准匹配 |
| showVariation | string | 否 | `N` | 是否查询变体：`Y` 是，`N` 否 |
| dataSnapshotMonth | string | 否 | `nearly` | `nearly` 表示最近30天实时数据；也可用 `yyyyMM` 格式查询历史快照，例如 `202412` |
| page | integer | 否 | `1` | 页码，从1开始 |
| size | integer | 否 | `50` | 每页条数，返回10–100条数据 |
| order | object | 否 | — | 排序配置，字段见下表 |

#### 排序对象（order）

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| field | string | 是 | `total_units` | 排序字段：`total_units`、`total_amount`、`bsr_rank`、`price`、`rating`、`reviews`、`profit`、`reviews_rate`、`available_date`、`questions`、`total_units_growth`、`total_amount_growth`、`reviews_increasement`、`bsr_rank_cv`、`bsr_rank_cr`、`amz_unit` |
| desc | string | 是 | `true` | 排序方向：`true` 降序，`false` 升序 |
