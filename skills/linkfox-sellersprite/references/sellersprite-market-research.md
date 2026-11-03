# 卖家精灵-选市场列表

路径：`/sellersprite/market/research`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/sellersprite.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：15 积分

## 请求参数

POST Body（JSON）。**必填**：仅 `marketplace`。

带「毛利率」等且 schema 写明「输入 N 表示 N%」的数值参数，取值范围一般为 0–100。`GoodsCrn`、`BrandCrn`、`SellerCrn`、`EbcProportion`、`FbaProportion`、`FbmProportion`、`AmazonSelfProportion` 的 `min*`/`max*` 入参须传 0–1 之间的小数。

#### 类目、地域与头部样本

| 参数 | 类型 | 必填 | 约束 | 说明 |
|------|------|------|------|------|
| marketplace | string | 是 | maxLength 1000，默认 `US` | 站点编码，见 marketplace 可选值 |
| nodeIdPath | string | 否 | maxLength 1000 | 类目节点 ID 路径，例如 `172282:281407` |
| departmentKeyword | string | 否 | maxLength 1000 | 类目关键字路径，例如 `Electronics:Accessories & Supplies` |
| sellerLocation | string | 否 | maxLength 1000 | 卖家所属地，多个值用英文逗号分隔 |
| newProduct | integer | 否 | 默认 `3` | 新品定义（月） |
| topNum | integer | 否 | 默认 `10` | 头部 Listing 数量 |

#### 时间与分页、排序

| 参数 | 类型 | 必填 | 约束 | 说明 |
|------|------|------|------|------|
| month | string | 否 | `nearly` 或 `yyyyMM` | 筛选日期 |
| page | integer | 否 | 默认 `1` | 页码，从1开始 |
| size | integer | 否 | 默认 `50`，最小 `1`，最大 `200` | 每页条数 |
| orderField | string | 否 | maxLength 1000 | 排序字段，见 orderField 可选值 |
| orderDesc | boolean | 否 | 默认 `true` | `true` 降序，`false` 升序 |

#### 市场规模与主体数量

| 参数 | 类型 | 说明 |
|------|------|------|
| minAvgRevenue / maxAvgRevenue | number | 最低 / 最高月均销售额 |
| minAvgUnits / maxAvgUnits | integer | 最低 / 最高月均销量 |
| minGoodsCount / maxGoodsCount | integer | 最低 / 最高商品数量 |
| minSellers / maxSellers | integer | 最小 / 最大卖家数量 |
| minBrands / maxBrands | integer | 最小 / 最大品牌数量 |
| minAvgSellers / maxAvgSellers | number | 最小 / 最大平均卖家数量 |

#### 集中度与结构占比

以下 7 组筛选入参须传 0–1 之间的小数，例如 `0.35` 表示 35%，不要按整数百分数传 `35`。

| 参数 | 类型 | 说明 |
|------|------|------|
| minGoodsCrn / maxGoodsCrn | number | 最小 / 最大商品集中度（小数 0–1） |
| minSellerCrn / maxSellerCrn | number | 最小 / 最大卖家集中度（小数 0–1） |
| minBrandCrn / maxBrandCrn | number | 最小 / 最大品牌集中度（小数 0–1） |
| minAmazonSelfProportion / maxAmazonSelfProportion | number | 最小 / 最大 Amazon 自营占比（小数 0–1） |
| minFbaProportion / maxFbaProportion | number | 最小 / 最大 FBA 占比（小数 0–1） |
| minFbmProportion / maxFbmProportion | number | 最小 / 最大 FBM 占比（小数 0–1） |
| minEbcProportion / maxEbcProportion | number | 最小 / 最大 A+ 数量占比（小数 0–1） |

#### 新品数量占比

| 参数 | 类型 | 说明 |
|------|------|------|
| minNewProportion / maxNewProportion | number | 最小 / 最大新品数量占比；刻度以工具 schema 或实网行为为准 |

#### 价格、评分、毛利、BSR（市场平均）

| 参数 | 类型 | 说明 |
|------|------|------|
| minAvgPrice / maxAvgPrice | number | 最低 / 最高平均价格 |
| minAvgRating / maxAvgRating | number | 最低 / 最高平均评分值 |
| minAvgRatings / maxAvgRatings | integer | 最低 / 最高平均评分数 |
| minAvgProfit / maxAvgProfit | number | 最低 / 最高平均毛利率（输入 N 表示 N%，0–100） |
| minAvgBsr / maxAvgBsr | integer | 最低 / 最高平均 BSR 排名 |

#### 新品维度

| 参数 | 类型 | 说明 |
|------|------|------|
| minNewCount / maxNewCount | integer | 最小 / 最大新品数量 |
| minNewAvgPrice / maxNewAvgPrice | number | 最小 / 最大新品平均价格 |
| minNewAvgRating / maxNewAvgRating | number | 最小 / 最大新品平均星级 |
| minNewAvgRatings / maxNewAvgRatings | integer | 最小 / 最大新品平均评分数 |
| minNewAvgUnits / maxNewAvgUnits | number | 最低 / 最高新品月均销量 |
| minNewAvgRevenue / maxNewAvgRevenue | number | 最低 / 最高新品月均销售额 |

#### 头部 Listing 指标

| 参数 | 类型 | 说明 |
|------|------|------|
| minTopAvgUnits / maxTopAvgUnits | integer | 最低 / 最高头部月均销量 |
| minTopAvgRevenue / maxTopAvgRevenue | number | 最低 / 最高头部月均销售额 |
| minTopAvgBsr / maxTopAvgBsr | integer | 最低 / 最高头部平均 BSR |

#### 重量与体积

| 参数 | 类型 | 说明 |
|------|------|------|
| minWeight / maxWeight | number | 最低 / 最高重量 |
| minVolume / maxVolume | number | 最低 / 最高体积 |

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

#### month

- **格式**：`^(nearly|(19|20)\d{2}(0[1-9]|1[0-2]))$`
- **`nearly`**：最近30天。
- **`yyyyMM`**：具体月份，例如 `202507`；最多支持当前月往前共24个月内的月份。

#### orderField 可选值

| 取值 | 含义 |
|------|------|
| total_units | 月销量 |
| total_amount | 月销售额 |
| bsr_rank | BSR 排名 |
| price | 价格 |
| rating | 评分 |
| reviews | 评分数 |
| profit | 毛利率 |
| reviews_rate | 留评率 |
| available_date | 上架时间 |
| questions | Q&A |
| total_units_growth | 月销量增长率 |
| total_amount_growth | 月销售额增长率 |
| reviews_increasement | 月新增评分数 |
| bsr_rank_cv | 近7天 BSR 增长数 |
| bsr_rank_cr | 近7天 BSR 增长率 |
| amz_unit | 子体销量 |
