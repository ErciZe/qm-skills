# 根据关键词查询细分市场

路径：`/jiimore/getNicheInfoByKeyword`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/jiimore.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`9`

## 请求参数

POST Body（JSON）：

#### 必填参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| keyword | string | 是 | 关键词（必填，并根据所选国家，翻译关键词为对应国家的语言），最大长度1000字符 |

#### 站点与分页

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| countryCode | string | 否 | US | 国家编码，可选值：`US`（美国）、`JP`（日本）、`DE`（德国） |
| page | integer | 否 | 1 | 页码（从1开始） |
| pageSize | integer | 否 | 50 | 每页返回数量（10-100） |
| sortField | string | 否 | unitsSoldT7 | 排序字段（见下方排序选项） |
| sortType | string | 否 | desc | 排序方式：`desc`（降序）或 `asc`（升序） |

#### 筛选参数：商品与价格

| 参数 | 类型 | 说明 |
|------|------|------|
| productCountMin | integer | 商品数量（当前）最小值 |
| productCountMax | integer | 商品数量（当前）最大值 |
| avgPriceMin | number | 平均价格（当前）最小值 |
| avgPriceMax | number | 平均价格（当前）最大值 |

#### 筛选参数：搜索与销售（7天统计）

| 参数 | 类型 | 说明 |
|------|------|------|
| searchVolumeT7Min | integer | 搜索量（7天统计）最小值 |
| searchVolumeT7Max | integer | 搜索量（7天统计）最大值 |
| unitsSoldT7Min | integer | 销售量（7天统计）最小值 |
| unitsSoldT7Max | integer | 销售量（7天统计）最大值 |
| clickCountT7Min | integer | 点击量（7天统计）最小值 |
| clickCountT7Max | integer | 点击量（7天统计）最大值 |
| clickConversionRateT7Min | number | 点击转换率（7天统计）最小值，数值范围为0-1，代表0%-100% |
| clickConversionRateT7Max | number | 点击转换率（7天统计）最大值，数值范围为0-1，代表0%-100% |

#### 筛选参数：品牌指标

| 参数 | 类型 | 说明 |
|------|------|------|
| brandCountMin | integer | 品牌数量最小值 |
| brandCountMax | integer | 品牌数量最大值 |
| top5BrandsClickShareMin | number | 前5个品牌所占细分市场的点击量份额最小值，数值范围为0-1，代表0%-100% |
| top5BrandsClickShareMax | number | 前5个品牌所占细分市场的点击量份额最大值，数值范围为0-1，代表0%-100% |
| avgBrandAgeMin | number | 平均品牌年龄（当前）最小值 |
| avgBrandAgeMax | number | 平均品牌年龄（当前）最大值 |
| avgBrandAgeQoqMin | number | 平均品牌年龄（90天统计）最小值 |
| avgBrandAgeQoqMax | number | 平均品牌年龄（90天统计）最大值 |
| avgBrandAgeYoyMin | number | 平均品牌年龄（360天统计）最小值 |
| avgBrandAgeYoyMax | number | 平均品牌年龄（360天统计）最大值 |

#### 筛选参数：卖家指标

| 参数 | 类型 | 说明 |
|------|------|------|
| avgSellingPartnerAgeMin | number | 平均销售伙伴年龄最小值 |
| avgSellingPartnerAgeMax | number | 平均销售伙伴年龄最大值 |
| avgSellingPartnerAgeQoqMin | number | 平均销售伙伴年龄（90天统计）最小值 |
| avgSellingPartnerAgeQoqMax | number | 平均销售伙伴年龄（90天统计）最大值 |
| avgSellingPartnerAgeYoyMin | number | 平均销售伙伴年龄（360天统计）最小值 |
| avgSellingPartnerAgeYoyMax | number | 平均销售伙伴年龄（360天统计）最大值 |

#### 筛选参数：竞争与广告

| 参数 | 类型 | 说明 |
|------|------|------|
| top5ProductsClickShareMin | number | 排名前5位的商品点击份额（当前）最小值，数值范围为0-1，代表0%-100% |
| top5ProductsClickShareMax | number | 排名前5位的商品点击份额（当前）最大值，数值范围为0-1，代表0%-100% |
| sponsoredProductsPercentageMin | number | SP广告占比最小值，数值范围为0-1，代表0%-100% |
| sponsoredProductsPercentageMax | number | SP广告占比最大值，数值范围为0-1，代表0%-100% |
| cpcMediumMin | number | CPC（当前）最小值 |
| cpcMediumMax | number | CPC（当前）最大值 |

#### 筛选参数：新品与退货

| 参数 | 类型 | 说明 |
|------|------|------|
| launchRateT180Min | number | 发布商品的成功率（180天统计）最小值，数值范围为0-1，代表0%-100% |
| launchRateT180Max | number | 发布商品的成功率（180天统计）最大值，数值范围为0-1，代表0%-100% |
| newProductRateT180 | number | 新商品占比（180天统计）最小值，数值范围为0-1，代表0%-100% |
| returnRateT360Min | number | 退货率（360天统计）最小值，数值范围为0-1，代表0%-100% |
| returnRateT360Max | number | 退货率（360天统计）最大值，数值范围为0-1，代表0%-100% |

#### 排序选项

| 值 | 说明 |
|------|------|
| unitsSoldT7 | 7天销量 |
| searchVolumeT7 | 7天搜索量 |
| demand | 需求得分 |
| avgPrice | 商品均价 |
| maximumPrice | 商品最高价 |
| minimumPrice | 商品最低价 |
| productCount | 商品数量 |
| searchConversionRateT7 | 7天搜索转化率 |
| clickConversionRateT7 | 7天点击转化率 |
| searchVolumeGrowthT7 | 搜索增长率 |
| clickCountT7 | 周点击量 |
| clickCountT90 | 90天点击量 |
| brandCount | 品牌数量 |
| top5BrandsClickShare | TOP5品牌份额 |
| top5ProductsClickShare | top5商品点击份额 |
| newProductsLaunchedT180 | 180d新品成功率-发布数 |
| successfulLaunchesT180 | 180d新品成功率-新品数 |
| launchRateT180 | 180d新品成功率-发布率 |
| returnRateT360 | 退货率 |
| clickConversionRateT90 | 90天点击转化率 |
| searchConversionRateT90 | 90天搜索转化率 |
| searchVolumeT90 | 90天搜索量 |
| unitsSoldT90 | 90天销量 |
| unitsSoldGrowthT90 | 90天销量增长率 |
| searchVolumeGrowthT90 | 90天搜索增长率 |
| acos | 广告销售成本比 |
| profitRate50 | 50%自然单的利润率 |
