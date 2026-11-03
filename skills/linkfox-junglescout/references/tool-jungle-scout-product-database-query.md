# 产品数据库查询

路径：`/tool-jungle-scout/product-database/query`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/jungle_scout.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：以响应中的 `costToken` 为准；源 skill 说明按动态规则计费：实际查询页数 × 63.75。

## 请求参数

POST Body（JSON）：

#### 必填参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| marketplace | string | 是 | `us` | 目标市场代码。可选值：`us`、`uk`、`de`、`in`、`ca`、`fr`、`it`、`es`、`mx`、`jp` |

#### 关键词筛选

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| includeKeywords | string | 否 | — | 标题/ASIN包含关键词，逗号分隔，最多 100 项，每项最长 50 字符 |
| excludeKeywords | string | 否 | — | 标题/ASIN排除关键词，逗号分隔，最多 100 项，每项最长 50 字符 |

#### 品类筛选

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| categories | string | 否 | — | 主分类名称，逗号分隔，需匹配对应站点的标准分类名。美国站示例：Appliances, Arts Crafts & Sewing, Automotive, Baby, Beauty & Personal Care, Books, CDs & Vinyl, Cell Phones & Accessories, Clothing Shoes & Jewelry, Collectibles & Fine Art, Computers, Digital Music, Electronics, Garden & Outdoor, Grocery & Gourmet Food, Handmade, Health Household & Baby Care, Home & Kitchen, Industrial & Scientific, Kindle Store, Kitchen & Dining, Movies & TV, Musical Instruments, Office Products, Pet Supplies, Sports & Outdoors, Tools & Home Improvement, Toys & Games, Video Games 等；其他站点有对应的本地分类名 |

#### 价格 / 销量 / 收入

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minPrice | number | 否 | — | 最低价格 |
| maxPrice | number | 否 | — | 最高价格 |
| minSales | integer | 否 | — | 最低月销量 |
| maxSales | integer | 否 | — | 最高月销量 |
| minRevenue | number | 否 | — | 最低月收入 |
| maxRevenue | number | 否 | — | 最高月收入 |

#### 评论 / 评分

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minReviews | integer | 否 | — | 最低评论数 |
| maxReviews | integer | 否 | — | 最高评论数 |
| minRating | number | 否 | — | 最低评分（1.0-5.0） |
| maxRating | number | 否 | — | 最高评分（1.0-5.0） |

#### 重量 / 尺寸 / BSR

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minWeight | number | 否 | — | 最低重量（磅） |
| maxWeight | number | 否 | — | 最高重量（磅） |
| minRank | integer | 否 | — | 最低 BSR 排名 |
| maxRank | integer | 否 | — | 最高 BSR 排名 |
| minLqs | integer | 否 | — | 最低 LQS 评分（1-10） |
| maxLqs | integer | 否 | — | 最高 LQS 评分（1-10） |

#### 卖家 / 产品类型

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minSellers | integer | 否 | — | 最少卖家数 |
| maxSellers | integer | 否 | — | 最多卖家数 |
| minNet | number | 否 | — | 最低净利润 |
| maxNet | number | 否 | — | 最高净利润 |
| sellerTypes | string | 否 | — | 卖家类型，逗号分隔。可选值：`amz`（亚马逊自营）、`fba`、`fbm` |
| productTiers | string | 否 | — | 产品尺寸层级，逗号分隔。可选值：`oversize`、`standard` |
| excludeTopBrands | boolean | 否 | — | 是否排除头部品牌 |
| excludeUnavailableProducts | boolean | 否 | — | 是否排除不可购买的商品 |

#### 日期 / 分页 / 排序

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| minUpdatedAt | string | 否 | — | 数据更新起始日期（YYYY-MM-DD） |
| maxUpdatedAt | string | 否 | — | 数据更新截止日期（YYYY-MM-DD） |
| needCount | integer | 否 | — | 需要返回的结果总数，API 内部自动分页 |
| sort | string | 否 | `name` | 排序字段。可选值：`name`、`-name`、`category`、`-category`、`revenue`、`-revenue`、`sales`、`-sales`、`price`、`-price`、`rank`、`-rank`、`reviews`、`-reviews`、`lqs`、`-lqs`、`sellers`、`-sellers`；前缀 `-` 表示降序 |

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
