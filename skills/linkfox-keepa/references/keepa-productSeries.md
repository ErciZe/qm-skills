# Keepa-亚马逊价格历史 API 参考

路径：`/keepa/productSeries`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/keepa.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：按动态规则计费：消耗积分 = 0.045 × 本次历史趋势查询消耗的 Keepa token。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| asin | string | 是 | — | 亚马逊标准识别号（ASIN），只支持单个 ASIN，最大长度 1000。 |
| domain | string | 是 | — | 亚马逊域名 ID：`1`（美国）、`2`（英国）、`3`（德国）、`4`（法国）、`5`（日本）、`6`（加拿大）、`8`（意大利）、`9`（西班牙）、`10`（印度）、`11`（墨西哥）、`12`（巴西）。 |
| days | integer | 否 | `90` | 限制历史数据天数，最大 `365`。 |
| showPrice | integer | 否 | — | 设为 `1` 返回市场最低新品价曲线。 |
| showPriceList | integer | 否 | — | 设为 `1` 返回划线价/标价曲线。 |
| showPriceDeal | integer | 否 | — | 设为 `1` 返回闪促价格曲线。 |
| showPricePrime | integer | 否 | — | 设为 `1` 返回 Prime 专属新品价曲线。 |
| showPriceFba | integer | 否 | — | 设为 `1` 返回第三方 FBA 新品价曲线。 |
| showPriceFbm | integer | 否 | — | 设为 `1` 返回第三方 FBM 新品价曲线。 |
| showPriceCoupon | integer | 否 | — | 设为 `1` 返回优惠券后 Buy Box 价曲线。 |
| showBsrMain | integer | 否 | — | 设为 `1` 返回大类 BSR 曲线。 |
| showSellerCount | integer | 否 | — | 设为 `1` 返回卖家数曲线。 |
