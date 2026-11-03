# 根据 ASIN 查询相关细分市场

路径：`/jiimore/getNicheInfoByAsin`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/jiimore.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`9`

## 请求参数

POST Body（JSON）：

#### 必填参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| asin | string | 是 | 商品 ASIN（必填）。工具会查找与该 ASIN 共享相同细分市场（Niche）的市场段落 |

#### 站点与数量

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| countryCode | string | 否 | US | 国家编码，可选值：`US`（美国）、`JP`（日本）、`DE`（德国） |
| count | integer | 否 | 10 | 返回的细分市场数量 |

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
| clickConversionRateT7Min | number | 点击转换率（7天统计）最小值，数值范围为0-1，0.1表示10%的转换率 |
| clickConversionRateT7Max | number | 点击转换率（7天统计）最大值，数值范围为0-1，0.1表示10%的转换率 |

#### 筛选参数：品牌指标

| 参数 | 类型 | 说明 |
|------|------|------|
| brandCountMin | integer | 品牌数量最小值 |
| brandCountMax | integer | 品牌数量最大值 |
| top5BrandsClickShareMin | number | 前5个品牌所占细分市场的点击量份额最小值，数值范围为0-1，0.1表示10%的点击份额 |
| top5BrandsClickShareMax | number | 前5个品牌所占细分市场的点击量份额最大值，数值范围为0-1，0.1表示10%的点击份额 |
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
| top5ProductsClickShareMin | number | 排名前5位的商品点击份额（当前）最小值，数值范围为0-1，0.1表示10%的点击份额 |
| top5ProductsClickShareMax | number | 排名前5位的商品点击份额（当前）最大值，数值范围为0-1，0.1表示10%的点击份额 |
| sponsoredProductsPercentageMin | number | SP广告占比最小值，数值范围为0-1，0.1表示10%的占比 |
| sponsoredProductsPercentageMax | number | SP广告占比最大值，数值范围为0-1，0.1表示10%的占比 |
| cpcMediumMin | number | CPC（当前）最小值 |
| cpcMediumMax | number | CPC（当前）最大值 |

#### 筛选参数：新品与退货

| 参数 | 类型 | 说明 |
|------|------|------|
| launchRateT180Min | number | 发布商品的成功率（180天统计）最小值，数值范围为0-1，0.1表示10%的成功率 |
| launchRateT180Max | number | 发布商品的成功率（180天统计）最大值，数值范围为0-1，0.1表示10%的成功率 |
| returnRateT360Min | number | 退货率（360天统计）最小值，数值范围为0-1，0.1表示10%的退货率 |
| returnRateT360Max | number | 退货率（360天统计）最大值，数值范围为0-1，0.1表示10%的退货率 |
