# 根据关键词拓展关键词

路径：`/tool-jungle-scout/keywords/by-keyword`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/jungle_scout.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：以响应中的 `costToken` 为准；源 skill 说明按动态规则计费：实际查询页数 × 63.75。

## 请求参数

POST Body（JSON）：

#### 必填参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| marketplace | string | 是 | `us` | 目标市场代码。可选值：`us`、`uk`、`de`、`in`、`ca`、`fr`、`it`、`es`、`mx`、`jp` |
| searchTerms | string | 是 | — | 种子关键词（单个关键词字符串） |

#### 可选参数 — 结果控制

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| needCount | integer | 否 | — | 返回结果总数 |
| sort | string | 否 | `-monthly_search_volume_exact` | 排序字段，默认按精确搜索量降序 |

#### 可选参数 — 搜索量筛选

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minMonthlySearchVolumeExact | integer | 否 | — | 精确搜索量下限 |
| maxMonthlySearchVolumeExact | integer | 否 | — | 精确搜索量上限 |
| minMonthlySearchVolumeBroad | integer | 否 | — | 广泛搜索量下限 |
| maxMonthlySearchVolumeBroad | integer | 否 | — | 广泛搜索量上限 |

#### 可选参数 — 其他筛选

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minWordCount | integer | 否 | — | 关键词最少词数（用于筛选长尾词） |
| maxWordCount | integer | 否 | — | 关键词最多词数 |
| minOrganicProductCount | integer | 否 | — | 自然排名商品数下限 |
| maxOrganicProductCount | integer | 否 | — | 自然排名商品数上限 |

#### sort 可选值

| 值 | 说明 |
|----|------|
| name / -name | 关键词名称升序/降序 |
| dominant_category / -dominant_category | 主类目升序/降序 |
| monthly_trend / -monthly_trend | 月度趋势升序/降序 |
| quarterly_trend / -quarterly_trend | 季度趋势升序/降序 |
| monthly_search_volume_exact / -monthly_search_volume_exact | 精确搜索量升序/降序（默认降序） |
| monthly_search_volume_broad / -monthly_search_volume_broad | 广泛搜索量升序/降序 |
| recommended_promotions / -recommended_promotions | 推荐促销升序/降序 |
| sp_brand_ad_bid / -sp_brand_ad_bid | 品牌广告出价升序/降序 |
| ppc_bid_broad / -ppc_bid_broad | PPC 广泛出价升序/降序 |
| ppc_bid_exact / -ppc_bid_exact | PPC 精确出价升序/降序 |
| ease_of_ranking_score / -ease_of_ranking_score | 排名难度升序/降序 |
| relevancy_score / -relevancy_score | 相关性评分升序/降序 |
| organic_product_count / -organic_product_count | 自然商品数升序/降序 |

#### 站点映射

| 站点 | marketplace 值 |
|------|---------------|
| 美国 | us |
| 英国 | uk |
| 德国 | de |
| 印度 | in |
| 加拿大 | ca |
| 法国 | fr |
| 意大利 | it |
| 西班牙 | es |
| 墨西哥 | mx |
| 日本 | jp |
