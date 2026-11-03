# 亚马逊商业洞察-按指标反向选品

路径：`/amazon/opportunity/searchByMetrics`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_business_insight.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`1.5 × (N ≤ 25 ? 5 : 5 + ceil((N - 25) / 5))`，其中 N 为接口实际返回的数据条数；即使成功返回0条也按15000计费。

**计费口径待确认**：上游同时给出上述公式和“0条按15000计费”的说明，但公式在 N=0 时结果为 7.5，两者的单位及换算关系未说明。不能自行换算或给出确定的费用估算；需要预先确认费用时，先向提供方核实口径，实际费用以消费记录为准。

## 请求参数

POST Body（JSON）。所有参数均可选，但必须至少提供 `keyword`、`nicheName` 或任意一个指标过滤字段，禁止全部为空。

#### 站点与翻页

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| amazonDomain | string | 否 | `US` | 亚马逊站点代码（闭枚举），当前仅支持 `US`；未指定时默认仅查美国站。 |
| limit | integer | 否 | `25`；1-200 | 返回条数上限；无 `page` 参数，按采集时间倒序返回最近N条。 |

#### 文本搜索

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| keyword | string | 否 | - | 搜索关键词文本片段（LIKE模糊匹配）。 |
| nicheName | string | 否 | - | 赛道归一化名称片段（LIKE，snake_case小写），适合赛道时序对比。 |

#### 市场规模与增长

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| nicheRevenue360dMinUsdAtLeastGte | number | 否 | - | 360天市场营收下界（USD）的最小值。 |
| nicheRevenue360dMinUsdAtLeastLte | number | 否 | - | 360天市场营收下界（USD）的最大值。 |
| nicheRevenue360dMaxUsdAtLeastGte | number | 否 | - | 360天市场营收上界（USD）的最小值。 |
| nicheRevenue360dMaxUsdAtLeastLte | number | 否 | - | 360天市场营收上界（USD）的最大值。 |
| nichePeakSearchVolumeAtLeastGte | integer | 否 | 非负整数 | 峰值月搜索量下界。 |
| nichePeakSearchVolumeAtLeastLte | integer | 否 | 非负整数 | 峰值月搜索量上界。 |
| nicheSearchVolumeYoyChangePctAtLeastGte | number | 否 | - | 搜索量同比变化率下限（%，带符号）。 |
| nicheSearchVolumeYoyChangePctAtLeastLte | number | 否 | - | 搜索量同比变化率上限（%，带符号）。 |
| nichePeakMonthGte | integer | 否 | 1-12 | 搜索峰值月份下限。 |
| nichePeakMonthLte | integer | 否 | 1-12 | 搜索峰值月份上限。 |

#### 竞争格局（品牌/产品集中度）

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| nicheBrandCountGte | integer | 否 | - | 活跃品牌数下限。 |
| nicheBrandCountLte | integer | 否 | - | 活跃品牌数上限。 |
| nicheBrandCountYoyChangePctAtLeastGte | number | 否 | - | 品牌数同比变化率下限（%，带符号）。 |
| nicheBrandCountYoyChangePctAtLeastLte | number | 否 | - | 品牌数同比变化率上限（%，带符号）。 |
| nicheTop5ProductClickSharePctAtLeastGte | number | 否 | 0-100 | Top5产品点击份额下限。 |
| nicheTop5ProductClickSharePctAtLeastLte | number | 否 | 0-100 | Top5产品点击份额上限。 |
| featureTop5BrandSharePctAtLeastGte | number | 否 | 0-100 | Top5品牌合计份额下限。 |
| featureTop5BrandSharePctAtLeastLte | number | 否 | 0-100 | Top5品牌合计份额上限。 |
| featureTopBrandsContains | string | 否 | - | Top3品牌名片段（原文LIKE，区分大小写）。 |

#### 价格与档位

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| priceMinUsdGte | number | 否 | - | 赛道最低商品价格下限（USD）。 |
| priceMinUsdLte | number | 否 | - | 赛道最低商品价格上限（USD）。 |
| priceMaxUsdGte | number | 否 | - | 赛道最高商品价格下限（USD）。 |
| priceMaxUsdLte | number | 否 | - | 赛道最高商品价格上限（USD）。 |
| priceSweetSpotMinUsdGte | number | 否 | - | Sweet Spot下限的下界（USD）。 |
| priceSweetSpotMinUsdLte | number | 否 | - | Sweet Spot下限的上界（USD）。 |
| priceSweetSpotMaxUsdGte | number | 否 | - | Sweet Spot上限的下界（USD）。 |
| priceSweetSpotMaxUsdLte | number | 否 | - | Sweet Spot上限的上界（USD）。 |
| priceEntryClickSharePctAtLeastGte | number | 否 | 0-100 | 入门档点击份额下限。 |
| priceEntryClickSharePctAtLeastLte | number | 否 | 0-100 | 入门档点击份额上限。 |
| priceMidClickSharePctAtLeastGte | number | 否 | 0-100 | 中档点击份额下限。 |
| priceMidClickSharePctAtLeastLte | number | 否 | 0-100 | 中档点击份额上限。 |
| priceHighClickSharePctAtLeastGte | number | 否 | 0-100 | 高端档点击份额下限。 |
| priceHighClickSharePctAtLeastLte | number | 否 | 0-100 | 高端档点击份额上限。 |

#### 客户画像（年龄/性别/收入/生命阶段）

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| demoPrimaryAgeMinGte | integer | 否 | 0-120 | 主人群年龄下界的最小值。 |
| demoPrimaryAgeMinLte | integer | 否 | 0-120 | 主人群年龄下界的最大值。 |
| demoPrimaryAgeMaxGte | integer | 否 | 0-120 | 主人群年龄上界的最小值。 |
| demoPrimaryAgeMaxLte | integer | 否 | 0-120 | 主人群年龄上界的最大值。 |
| demoGenderDominant | string | 否 | - | 性别主导（闭枚举）：`female` / `male` / `mixed` / `unspecified`。 |
| demoPrimaryIncomeTier | string | 否 | - | 收入档（闭枚举）：`low` / `middle_low` / `middle` / `middle_upper` / `upper_middle` / `high`。 |
| demoLifeStageTagsContains | string | 否 | - | 生命阶段标签片段（snake_case，LIKE），如 `parent`、`student`、`retiree`、`athlete`。 |

#### 产品特征（成熟度/趋势/差异化/搜索形态）

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| featureNewAvgReviewCountAtLeastGte | integer | 否 | 非负整数 | 新品平均评论量下限。 |
| featureNewAvgReviewCountAtLeastLte | integer | 否 | 非负整数 | 新品平均评论量上限。 |
| featureEstablishedAvgReviewCountAtLeastGte | integer | 否 | 非负整数 | 成熟老品平均评论量下限。 |
| featureEstablishedAvgReviewCountAtLeastLte | integer | 否 | 非负整数 | 成熟老品平均评论量上限。 |
| featureEmergingTrendTagsContains | string | 否 | - | 新兴趋势特征标签片段（snake_case，LIKE），如 `cordless`、`portable`、`smart`。 |
| featureUncommonFeatureTagsContains | string | 否 | - | 稀有差异化特征标签片段（snake_case，LIKE），如 `hema_free`、`medical_grade_silicone`。 |
| searchTopCategory1Label | string | 否 | - | 搜索流量第一类目标签片段（snake_case，LIKE），如 `core_product_terms`、`set_kit_configurations`。 |

#### 评论卖点/痛点

| 参数 | 类型 | 必填 | 默认值/范围 | 说明 |
|------|------|------|-------------|------|
| reviewPositiveTop1Topic | string | 否 | - | 好评#1主题片段（snake_case，LIKE），如 `comfort`、`quality_overall_generic`。 |
| reviewPositiveTop1PctAtLeastGte | number | 否 | 0-100 | 好评#1主题占比下限（正面评论中占比）。 |
| reviewPositiveTop1PctAtLeastLte | number | 否 | 0-100 | 好评#1主题占比上限。 |
| reviewNegativeTop1Topic | string | 否 | - | 差评#1主题片段（snake_case，LIKE），如 `size`、`quality`、`durability`。 |
| reviewNegativeTop1PctAtLeastGte | number | 否 | 0-100 | 差评#1主题占比下限（负面评论中占比）。 |
| reviewNegativeTop1PctAtLeastLte | number | 否 | 0-100 | 差评#1主题占比上限。 |
| reviewNegativeTop2Topic | string | 否 | - | 差评#2主题片段（snake_case，LIKE）。 |
| reviewStrategicInsightTagsContains | string | 否 | - | 评论策略建议标签片段（snake_case，LIKE），如 `sizing_clarity`、`material_transparency`。 |
