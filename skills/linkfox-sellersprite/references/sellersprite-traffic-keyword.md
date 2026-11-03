# 卖家精灵-流量词反查

路径：`/sellersprite/traffic/keyword`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/sellersprite.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：15 积分

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| marketplace | string | 是 | `US` | 市场站点，见 marketplace 可选值 |
| asin | string | 是 | — | 要反查的商品 ASIN，maxLength 1000 |
| month | string | 否 | 最近30天 | 历史月份，格式 `yyyyMM` |
| page | integer | 否 | `1` | 当前页 |
| size | integer | 否 | `50` | 每页条数，最小1，最大100，最多查询2000条 |
| keyword | string | 否 | — | 关键词筛选，maxLength 1000 |
| badges | string | 否 | — | 曝光位置，多值用英文逗号分隔，见 badges 枚举 |
| trafficKeywordTypes | string | 否 | — | 流量占比类型，多值用英文逗号分隔，见 trafficKeywordTypes 枚举 |
| conversionKeywordTypes | string | 否 | — | 流量转化类型，多值用英文逗号分隔，见 conversionKeywordTypes 枚举 |
| orderField | string | 否 | `rankPosition` | 排序字段，见 orderField 可选值 |
| orderDesc | boolean | 否 | `false` | 排序是否倒序 |

#### marketplace 可选值

| 取值 | 含义 |
|------|------|
| US | 美国站 USD($) |
| JP | 日本站 JPY(￥) |
| UK | 英国站 GBP(£) |
| DE | 德国站 EUR(€) |
| FR | 法国站 EUR(€) |
| IT | 意大利站 EUR(€) |
| ES | 西班牙站 EUR(€) |
| CA | 加拿大站 C$($) |
| IN | 印度站 INR(₹) |

#### badges 枚举

多个值用英文逗号分隔。

| 取值 | 含义 |
|------|------|
| naturalSearching | 自然搜索词 |
| amazonChoice | AC 推荐词 |
| editorialRecommendations | ER 推荐词 |
| fourStar | 四星推荐词 |
| highlyRated | HR 推荐词 |
| sponsorBrand | 品牌推荐词 |
| sponsorVideo | 视频推荐词 |
| ads | SP 广告词 |

#### trafficKeywordTypes 枚举

多个值用英文逗号分隔。

| 取值 | 含义 |
|------|------|
| primary | 主要流量词 |
| precise | 精准流量词 |
| preciseLongTail | 转化流失词 |

#### conversionKeywordTypes 枚举

多个值用英文逗号分隔。

| 取值 | 含义 |
|------|------|
| excellent | 转化优质词 |
| stable | 转化平稳词 |
| lost | 转化流失词 |
| invalid | 无效曝光词 |

#### orderField 可选值

| 取值 | 含义 |
|------|------|
| rankPosition | 自然排名（默认） |
| adPosition | 广告排名 |
| createdTime | 创建时间 |
| searchesRank | 搜索量周排名 |
| searches | 月搜索量 |
| purchases | 月购买量 |
| purchaseRate | 购买率 |
| products | 商品数 |
| supplyDemandRatio | 供需比 |
| latest1daysAds | 广告竞品数 |
| bid | PPC 竞价 |
| trafficPercentage | 流量占比 |
