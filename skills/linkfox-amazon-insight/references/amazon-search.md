# 亚马逊前端搜索模拟

路径：`/amazon/search`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_front_data.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：基础消耗为 `20000` Token；启用卖家精灵补全时，再加上每个成功补全批次返回的 `costToken`，最终以响应顶层 `costToken` 为准。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `keyword` | string | 否 | — | 搜索关键词，建议使用目标站点语言，最大长度 1024。 |
| `amazonDomain` | string | 否 | `amazon.com` | 亚马逊站点：`amazon.com`、`amazon.co.uk`、`amazon.de`、`amazon.fr`、`amazon.it`、`amazon.es`、`amazon.co.jp`、`amazon.ca`、`amazon.com.au`、`amazon.com.br`、`amazon.in`、`amazon.nl`、`amazon.se`、`amazon.pl`、`amazon.sg`、`amazon.sa`、`amazon.ae`、`amazon.com.mx`、`amazon.com.tr`、`amazon.com.be`、`amazon.cn`、`amazon.eg`。 |
| `node` | string | 否 | — | 亚马逊类目节点，最大长度 1000。 |
| `language` | string | 否 | — | 语言区域代码，最大长度 1000，例如 `en_US`、`de_DE`、`ja_JP`、`fr_FR`。 |
| `sort` | string | 否 | `relevanceblender` | `relevanceblender`、`price-asc-rank`、`price-desc-rank`、`review-rank`、`date-desc-rank` 或 `exact-aware-popularity-rank`。 |
| `page` | integer | 否 | `1` | 页码，从 1 开始，每页大约 20 条。 |
| `deliveryZip` | string | 否 | — | 配送地邮编，用于模拟亚马逊前台地址，最大长度 1000。 |
| `device` | string | 否 | `desktop` | 设备类型：`desktop`、`mobile`、`tablet`，最大长度 1000。 |
| `includeSellerSpriteData` | boolean | 是（Skill 调用） | `false` | 是否启用卖家精灵竞品数据补全。传 `true` 会补全销量、销售额、品牌、履约等字段并产生额外动态算力消耗；不需要补全时传 `false`。 |
