# Keepa-亚马逊-商品搜索 API 参考

路径：`/keepa/productSearch`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/keepa.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：按动态规则计费：消耗积分 = 0.045 ×（找商品阶段消耗的 Keepa token + 拉取商品详情阶段消耗的 Keepa token）。若找商品阶段未找到商品，则只计找商品阶段消耗。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| domain | string | 是 | — | Amazon 域名 ID：`1`=美国、`2`=英国、`3`=德国、`4`=法国、`5`=日本、`6`=加拿大、`8`=意大利、`9`=西班牙、`10`=印度、`11`=墨西哥。 |
| keyword | string | 否 | — | 标题关键词；大小写不敏感，空格表示分词 AND，关键词本身包含空格时用双引号包裹，支持前缀 `-` 排除；`&` 会被替换为空格，最多 50 个关键词、最大 1000 字符。 |
| rootCategory | array[int] | 否 | — | 根类目 ID，最多 50 个。 |
| rootCategoryNames | array[string] | 否 | — | 根类目名称，最多 50 个；当 `rootCategory` 为空时使用，系统自动查找对应类目 ID。 |
| categoriesInclude | array[int] | 否 | — | 要包含的子类目 ID，最多 50 个；仅包含直接列在这些子类别中的产品。 |
| categoriesIncludeNames | array[string] | 否 | — | 要包含的子类目名称，最多 50 个；当 `categoriesInclude` 为空时使用，支持用 `:` 或 `›` 分隔的完整类目路径。 |
| categoriesExclude | array[int] | 否 | — | 要排除的子类目 ID，最多 50 个。 |
| categoriesExcludeNames | array[string] | 否 | — | 要排除的子类目名称，最多 50 个；当 `categoriesExclude` 为空时使用，支持完整类目路径。 |
| currentSalesGte / currentSalesLte | integer | 否 | — | 当前销售排名范围，数值越小排名越好。 |
| avg90SalesGte / avg90SalesLte | integer | 否 | — | 90 天平均销售排名范围。 |
| deltaPercent90SalesGte / deltaPercent90SalesLte | integer | 否 | — | 90 天销售排名变化百分比范围。 |
| monthlySoldGte / monthlySoldLte | integer | 否 | — | 销量/月销量范围。 |
| srAvgGte / srAvgLte | integer | 否 | — | 历史销售排名范围，用于 `srAvgMonth` 指定的月份；数值越小排名越好。 |
| srAvgMonth | string | 否 | — | 历史销售排名月份，格式 `YYYYMM`，最近 36 个月内。 |
| currentNewGte / currentNewLte | integer | 否 | — | 当前新品价格范围，单位为最小货币单位。 |
| currentBuyBoxShippingGte / currentBuyBoxShippingLte | integer | 否 | — | 当前 Buy Box 含运费价格范围，单位为最小货币单位。 |
| currentCountReviewsGte / currentCountReviewsLte | integer | 否 | — | 当前评论数量范围。 |
| currentRatingGte / currentRatingLte | number | 否 | — | 当前评分范围（0.0-5.0）。 |
| packageLengthGte / packageLengthLte | integer | 否 | — | 包装长度范围（毫米）。 |
| packageWidthGte / packageWidthLte | integer | 否 | — | 包装宽度范围（毫米）。 |
| packageHeightGte / packageHeightLte | integer | 否 | — | 包装高度范围（毫米）。 |
| packageWeightGte / packageWeightLte | integer | 否 | — | 包装重量范围（克）。 |
| brand | array[string] | 否 | — | 品牌，OR 匹配。 |
| color | array[string] | 否 | — | 颜色，OR 匹配。 |
| size | array[string] | 否 | — | 尺码，OR 匹配。 |
| availableDateGte / availableDateLte | string | 否 | — | 产品上架时间范围，日期格式 `yyyy-MM-dd`。 |
| buyBoxIsAmazon | boolean | 否 | — | Buy Box 卖家是否为亚马逊。 |
| buyBoxIsFBA | boolean | 否 | — | Buy Box 是否为 FBA。 |
| isHazMat | boolean | 否 | — | 是否为危险品。 |
| variationCountGte / variationCountLte | integer | 否 | — | 变体数量范围。 |
| currentCountNewGte / currentCountNewLte | integer | 否 | — | 当前新品报价数量范围。 |
| outOfStockPercentage90Gte / outOfStockPercentage90Lte | integer | 否 | — | 90 天缺货百分比范围。 |
| singleVariation | boolean | 否 | — | 仅返回一个变体；设为 `true` 时，多变体产品只返回一个变体。 |
| productType | array[int] | 否 | `[0,1,2]` | 产品类型：`0`=标准产品，`1`=可下载产品，`2`=电子书，`5`=变体父 ASIN。 |
| history | integer | 否 | `0` | 返回值是否包含历史数据/历史销量：`1`=获取，`0`=不获取。 |
| rating | integer | 否 | `1` | 是否获取评分信息：`1`=获取，`0`=不获取。 |
| page | integer | 否 | `1` | 页码，从 1 开始。 |
| perPage | integer | 否 | `50` | 每页返回的最大结果数，最小 50、最大 100。 |
| sort | array[object] | 否 | — | 最多 3 条排序规则；每项包含 `{"fieldName":"...","sortDirection":"asc\|desc"}`。可排序字段：`availableDate`、`currentSales`、`monthlySold`、`currentRating`、`currentCountReviews`、`currentBuyBoxShipping`、`currentNew`。 |
