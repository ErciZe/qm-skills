# 卖家精灵-选产品

路径：`/sellersprite/productSearch`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/sellersprite.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：15 积分

## 请求参数

POST Body（JSON）。以下字段与工具网关当前登记的「卖家精灵-选产品」入参 schema 一致。

#### 会话 / 网关（可选）

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| chatId | string | 否 | — | 对话 id，maxLength 1000 |
| uid | string | 否 | — | 用户 id，maxLength 1000 |
| requestId | string | 否 | — | 推送 id，maxLength 1000 |
| teamId | string | 否 | — | 团队 id，maxLength 1000 |

#### 搜索与关键词

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| keyword | string | 否 | — | 搜索关键词，建议使用目标站点语言；maxLength 10240 |
| matchType | integer | 否 | `1` | 匹配方式：`1` 词组匹配、`2` 模糊匹配、`3` 精准匹配 |
| excludeKeywords | string | 否 | — | 排除关键词；maxLength 10240 |
| marketplace | string | 否 | `US` | 仅允许 `US`、`UK`、`DE`、`FR`、`JP`、`CA`、`IT`、`ES`、`MX`、`IN` |

#### 类目筛选

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| nodeLabel | string | 否 | — | 亚马逊类目名称；maxLength 1000 |
| nodeIdPath | string | 否 | — | 亚马逊类目节点 ID；maxLength 1000 |
| filterSubNode | boolean | 否 | — | 是否筛选子类目节点；仅在 nodeLabel 或 nodeIdPath 有值时生效 |

#### 数据快照

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| dataSnapshotMonth | string | 否 | `nearly` | `yyyyMM` 格式的商品数据快照年月，或 `nearly` 表示最近30天实时数据；maxLength 1000 |

#### 价格与利润

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minPrice | number | 否 | — | 最低价格（>= 0） |
| maxPrice | number | 否 | — | 最高价格（>= 0） |
| minProfit | number | 否 | — | 最小毛利率，单位 %（1–100） |
| maxProfit | number | 否 | — | 最大毛利率，单位 %（1–100） |
| minRevenue | number | 否 | — | 最低月销售额（>= 0） |
| maxRevenue | number | 否 | — | 最高月销售额（>= 0） |
| minFba | number | 否 | — | 最低 FBA 运费（>= 0） |
| maxFba | number | 否 | — | 最高 FBA 运费（>= 0） |

#### 销量与 BSR

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minUnits | integer | 否 | — | 最低月销量（>= 0） |
| maxUnits | integer | 否 | — | 最高月销量（>= 0） |
| minAmzUnit | integer | 否 | — | 最低子体近30日销量；仅 `dataSnapshotMonth` 为近30日类查询时支持，最小值 0 |
| maxAmzUnit | integer | 否 | — | 最高子体近30日销量；仅近30日查询支持，最小值 0 |
| minUnitsGrowthRate | number | 否 | — | 月销量最低增长率，单位 % |
| maxUnitsGrowthRate | number | 否 | — | 月销量最高增长率，单位 % |
| minBsr | integer | 否 | — | 大类 BSR 最低排名 |
| maxBsr | integer | 否 | — | 大类 BSR 最高排名 |
| minBsrGrowthRate | number | 否 | — | BSR 最低增长率，单位 % |
| maxBsrGrowthRate | number | 否 | — | BSR 最高增长率，单位 % |
| minBsrGrowthCount | integer | 否 | — | BSR 最低增长数 |
| maxBsrGrowthCount | integer | 否 | — | BSR 最高增长数 |
| minSubNodeBsrRank | integer | 否 | — | 子类目 BSR 最低排名；需 `filterSubNode=true` |
| maxSubNodeBsrRank | integer | 否 | — | 子类目 BSR 最大排名；需 `filterSubNode=true` |

#### 评分与评论

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minRating | number | 否 | — | 最低评分值（0–5） |
| maxRating | number | 否 | — | 最高评分值（0–5） |
| minRatings | integer | 否 | — | 最低评分数（0–10000） |
| maxRatings | integer | 否 | — | 最高评分数（0–10000） |
| minRatingsGrowthCount | integer | 否 | — | 最低月新增评分数（>= 0） |
| maxRatingsGrowthCount | integer | 否 | — | 最高月新增评分数（>= 0） |
| minListingQualityScore | number | 否 | — | 最低 Listing 页面质量分（>= 0） |
| maxListingQualityScore | number | 否 | — | 最高 Listing 页面质量分（>= 0） |

#### 商品属性

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minVariations | integer | 否 | — | 最低变体数 |
| maxVariations | integer | 否 | — | 最高变体数 |
| minWeights | number | 否 | — | 最小重量（>= 0） |
| maxWeights | number | 否 | — | 最大重量（>= 0） |
| weightUnit | string | 否 | — | 重量单位：`g`、`kg`、`oz`、`lb`；使用重量筛选时必须指定 |
| dimensionType | string | 否 | — | 包装尺寸类型，各站点代码见下方说明 |
| minSellers | integer | 否 | — | 最小卖家数量 |
| maxSellers | integer | 否 | — | 最大卖家数量 |

#### 标识与配送

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| badgeBestSeller | string | 否 | — | Best Seller 标识：`Y`、`N` 或留空 |
| badgeAmazonsChoice | string | 否 | — | Amazon's Choice 标识：`Y`、`N` 或留空 |
| badgeNewRelease | string | 否 | — | New Release 标识：`Y`、`N` 或留空 |
| fulfillment | string | 否 | — | 配送方式：`AMZ`、`FBA`、`FBM`，多值用英文逗号分隔 |
| showVariation | string | 否 | `N` | 是否查询变体：`Y` 或 `N` |
| hideUnlistedProduct | boolean | 否 | `true` | 是否隐藏已下架商品 |
| listedWithinLastMonths | integer | 否 | — | 上架时间范围（月），仅允许 `1`、`3`、`6`、`12`、`24` |

#### 卖家与品牌

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| sellerNation | string | 否 | — | 卖家所属地代码，多值用逗号分隔 |
| includeSellers | string | 否 | — | 包含卖家；maxLength 10240 |
| excludeSellers | string | 否 | — | 排除卖家；maxLength 10240 |
| includeBrands | string | 否 | — | 包含品牌；maxLength 10240 |
| excludeBrands | string | 否 | — | 排除品牌；maxLength 10240 |

#### 排序与分页

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| order | object | 否 | — | 排序配置；传入时建议同时提供 `field` 与 `desc` |
| order.field | string | 否 | `total_units` | 排序字段：`total_units`、`total_amount`、`bsr_rank`、`price`、`rating`、`reviews`、`profit`、`reviews_rate`、`available_date`、`questions`、`total_units_growth`、`total_amount_growth`、`reviews_increasement`、`bsr_rank_cv`、`bsr_rank_cr`、`amz_unit`；传空字符串表示不按上述业务字段排序 |
| order.desc | string | 否 | `true` | `"true"` 降序，`"false"` 升序 |
| page | integer | 否 | `1` | 页码，从1开始 |
| size | integer | 否 | `20` | 每页条数，10–100 |
