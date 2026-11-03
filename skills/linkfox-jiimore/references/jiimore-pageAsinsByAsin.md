# 根据 ASIN 挖掘细分市场竞品

路径：`/jiimore/pageAsinsByAsin`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/jiimore.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`9`

## 请求参数

POST Body（JSON）：

#### 必填参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| asin | string | 是 | 参考 ASIN，用于查询与该 ASIN 同属细分市场（Niche）的竞品列表，最大长度1000字符 |

#### 站点与分页

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| countryCode | string | 否 | US | 国家编码，可选值：`US`（美国）、`JP`（日本）、`DE`（德国） |
| page | integer | 否 | 1 | 页码（从1开始） |
| pageSize | integer | 否 | 50 | 每页返回数量（10-100） |
| sortField | string | 否 | purchasedClicksT360 | 排序字段（见下方排序选项） |
| sortType | string | 否 | desc | 排序方式：`desc`（降序）或 `asc`（升序） |

#### 筛选参数：价格与FBA

| 参数 | 类型 | 说明 |
|------|------|------|
| priceMin | number | 最低产品价格 |
| priceMax | number | 最高产品价格 |
| fbaFeeMin | number | 最低FBA佣金 |
| fbaFeeMax | number | 最高FBA佣金 |
| grossProfitMarginMin | number | 最低毛利率 |
| grossProfitMarginMax | number | 最高毛利率 |

#### 筛选参数：评论与评分

| 参数 | 类型 | 说明 |
|------|------|------|
| totalReviewsMin | integer | 最少评论数量 |
| totalReviewsMax | integer | 最多评论数量 |
| customerRatingMin | number | 最低评分，取值范围 0.0-5.0 |
| customerRatingMax | number | 最高评分，取值范围 0.0-5.0 |

#### 筛选参数：点击数据（7天）

| 参数 | 类型 | 说明 |
|------|------|------|
| clickCountT7Min | integer | 最低周点击量 |
| clickCountT7Max | integer | 最高周点击量 |
| clickCountGrowthT7Min | number | 最低周点击增长率，取值范围 0-1，例如 0.1 表示 10% |
| clickCountGrowthT7Max | number | 最高周点击增长率，取值范围 0-1，例如 0.1 表示 10% |
| clickConversionRateMin | number | 最低点击转化率，取值范围 0-1，例如 0.1 表示 10% |
| clickConversionRateMax | number | 最高点击转化率，取值范围 0-1，例如 0.1 表示 10% |

#### 筛选参数：点击数据（30天）

| 参数 | 类型 | 说明 |
|------|------|------|
| clickCountT30Min | integer | 最低月点击量 |
| clickCountT30Max | integer | 最高月点击量 |
| clickCountGrowthT30Min | number | 最低月点击增长率，取值范围 0-1，例如 0.1 表示 10% |
| clickCountGrowthT30Max | number | 最高月点击增长率，取值范围 0-1，例如 0.1 表示 10% |

#### 筛选参数：综合转化率

| 参数 | 类型 | 说明 |
|------|------|------|
| clickConversionRateCompositeMin | number | 最低综合点击转化率，取值范围 0-1，例如 0.1 表示 10% |
| clickConversionRateCompositeMax | number | 最高综合点击转化率，取值范围 0-1，例如 0.1 表示 10% |

#### 筛选参数：销量与上架时间

| 参数 | 类型 | 说明 |
|------|------|------|
| salesVolumeT360Min | integer | 最低年销量 |
| salesVolumeT360Max | integer | 最高年销量 |
| launchDateMin | string | 最早上架时间，格式为 yyyyMMdd000000 |
| launchDateMax | string | 最晚上架时间，格式为 yyyyMMdd000000 |

#### 筛选参数：细分市场与卖家

| 参数 | 类型 | 说明 |
|------|------|------|
| nicheCountMin | integer | 最少细分市场数量 |
| nicheCountMax | integer | 最多细分市场数量 |
| sellerCountry | string | 卖家国家的国家码，选择多个国家的用英文逗号隔开，如：CN,US |

#### 排序选项

| 值 | 说明 |
|------|------|
| purchasedClicksT360 | 360天购买点击（默认） |
| totalReviews | 评论数量 |
| price | 价格 |
| launchDate | 上架时间 |
| clickCountT30 | 30天点击量 |
| clickCountT90 | 90天点击量 |
| clickCountT7 | 7天点击量 |
| clickConversionRate | 点击转化率(原7天点击转化率) |
| clickConversionRateComposite | 综合点击转化率 |
| customerRating | 评分 |
| clickCountGrowthT7 | 周点击增长率 |
| clickCountGrowthT30 | 月点击增长率 |
| currentPrice | 当前价格 |
| fbaFee | FBA佣金 |
| shippingFee | FBA运费 |
| gpm | 毛利率 |
