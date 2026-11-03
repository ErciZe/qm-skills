# 亚马逊前端-商品详情

路径：`/amazon/product/detail`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_front_data.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：按动态规则计费，消耗积分 = 成功返回商品数 × 15。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `asins` | string | 是 | — | ASIN 列表，最多 40 个，格式为逗号分隔的大写字母/数字，匹配 `^[A-Z0-9]+(,[A-Z0-9]+){0,39}$`。 |
| `amazonDomain` | string | 否 | `amazon.com` | 亚马逊站点：`amazon.com`、`amazon.co.uk`、`amazon.de`、`amazon.fr`、`amazon.it`、`amazon.es`、`amazon.co.jp`、`amazon.ca`、`amazon.com.au`、`amazon.com.br`、`amazon.in`、`amazon.nl`、`amazon.se`、`amazon.pl`、`amazon.sg`、`amazon.sa`、`amazon.ae`、`amazon.com.tr`、`amazon.com.mx`、`amazon.eg`、`amazon.cn`、`amazon.com.be`。 |
| `language` | string | 否 | — | 响应语言区域代码，例如 `en_US`、`de_DE`、`fr_FR`、`ja_JP`、`it_IT`、`es_ES`、`pt_BR`、`en_GB`、`zh_CN`。 |
| `deliveryZip` | string | 否 | — | 配送邮编，用于获取配送相关定价，例如 `10001`、`10115`、`EC1A 1BB`。 |
| `device` | string | 否 | `desktop` | 设备类型：`desktop`、`mobile`、`tablet`。 |
| `returnBoughtTogether` | boolean | 否 | `false` | 是否返回经常一起购买的商品 `boughtTogether`。 |
| `returnRelatedProducts` | boolean | 否 | `false` | 是否返回相关商品列表 `relatedProducts`。 |
| `returnAuthorsReviews` | boolean | 否 | `false` | 是否返回作者评论列表 `authorsReviews`。 |
