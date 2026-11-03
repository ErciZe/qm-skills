# 关键词商品挖掘

路径：`/jiimore/productDiscovery`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/jiimore.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`9`

## 请求参数

POST Body（JSON）：

#### 必填参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| keyword | string | 是 | 关键词（必填，并根据所选国家，翻译关键词为对应国家的语言） |

#### 筛选参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| countryCode | string | 否 | 国家，使用国家简称。默认 `US`。可选值：`US`、`JP`、`DE` |
| priceMin | number | 否 | 最低商品价格 |
| priceMax | number | 否 | 最高商品价格 |
| totalReviewsMin | integer | 否 | 最低评论数 |
| totalReviewsMax | integer | 否 | 最高评论数 |
| customerRatingMin | number | 否 | 最低评分 |
| customerRatingMax | number | 否 | 最高评分 |
| clickConversionRateMin | number | 否 | 最低点击购买转化率，数值范围为0-1，0.1表示10% |
| clickConversionRateMax | number | 否 | 最高点击购买转化率，数值范围为0-1，0.1表示10% |
| clickConversionRateCompositeMin | number | 否 | 最低综合转化率，数值范围为0-1，0.1表示10% |
| clickConversionRateCompositeMax | number | 否 | 最高综合转化率，数值范围为0-1，0.1表示10% |
| clickCountT7Min | integer | 否 | 最低周点击量 |
| clickCountT7Max | integer | 否 | 最高周点击量 |
| clickCountT30Min | integer | 否 | 最低月点击量 |
| clickCountT30Max | integer | 否 | 最高月点击量 |
| clickCountGrowthT7Min | number | 否 | 最低周点击增长率，数值范围为0-1，0.1表示10% |
| clickCountGrowthT7Max | number | 否 | 最高周点击增长率，数值范围为0-1，0.1表示10% |
| clickCountGrowthT30Min | number | 否 | 最低月点击增长率，数值范围为0-1，0.1表示10% |
| clickCountGrowthT30Max | number | 否 | 最高月点击增长率，数值范围为0-1，0.1表示10% |
| salesVolumeT360Min | integer | 否 | 最低年销售量 |
| salesVolumeT360Max | integer | 否 | 最高年销售量 |
| grossProfitMarginMin | number | 否 | 最低毛利率 |
| grossProfitMarginMax | number | 否 | 最高毛利率 |
| fbaFeeMin | number | 否 | 最低FBA佣金 |
| fbaFeeMax | number | 否 | 最高FBA佣金 |
| launchDateMin | string | 否 | 最小上架时间，格式为：`yyyyMMdd000000` |
| launchDateMax | string | 否 | 最大上架时间，格式为：`yyyyMMdd000000` |
| nicheCountMin | integer | 否 | 最低细分市场数量 |
| nicheCountMax | integer | 否 | 最高细分市场数量 |
| sellerCountry | string | 否 | 卖家国家地区编码，选择多个的情况下用逗号隔开，如：`CN,US` |

#### 排序与分页

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| sortField | string | 否 | 排序字段。默认 `purchasedClicksT360`。可选值：`totalReviews`（总评论数）、`price`（价格）、`launchDate`（上架时间）、`clickCountT7`（7天点击量）、`clickCountT30`（30天点击量）、`clickCountT90`（90天点击量）、`clickConversionRate`（点击购买转化率）、`clickConversionRateComposite`（综合点击购买转化率）、`customerRating`（评分）、`purchasedClicksT360`（360天购买量）、`clickCountGrowthT7`（周点击增长率）、`clickCountGrowthT30`（月点击增长率）、`currentPrice`（当前价格）、`fbaFee`（FBA佣金）、`shippingFee`（FBA运费）、`gpm`（毛利率） |
| sortType | string | 否 | 排序方式。默认 `desc`。可选值：`desc`（降序）、`asc`（升序） |
| page | integer | 否 | 页码。默认 `1` |
| pageSize | integer | 否 | 每页数量（10-100）。默认 `50` |
