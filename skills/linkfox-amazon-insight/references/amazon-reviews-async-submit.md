# 亚马逊商品评论（异步提交）

路径：`/amazon/reviews/async/submit`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_front_data.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：提交和查询接口响应中的 `X-Cost-Token` / `costToken` 为 `0` 只表示本次接口不再扣费；评论任务费用由后端在上游处理结束后独立结算，实际消耗以消费记录为准。调用前可按计划抓取页数估算：`P = Σ min(ceil(各星级请求评论数 / 10), 10)`，预估值为 `ceil(10.5 × P)`。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `asin` | string | 是 | — | 亚马逊商品 ASIN；每次请求只支持一个 ASIN。 |
| `domainCode` | string | 否 | `com` | 站点代码：`com`、`ca`、`co.uk`、`in`、`de`、`fr`、`it`、`es`、`co.jp`、`com.au`、`com.br`、`nl`、`se`、`com.mx`、`ae`；美国站使用 `com`。 |
| `star1Num` | integer | 否 | `10` | 1 星评论数量，最多 100 条。若传入任意星级数量，未传的星级默认为 `0`。 |
| `star2Num` | integer | 否 | `10` | 2 星评论数量，最多 100 条。 |
| `star3Num` | integer | 否 | `10` | 3 星评论数量，最多 100 条。 |
| `star4Num` | integer | 否 | `10` | 4 星评论数量，最多 100 条。 |
| `star5Num` | integer | 否 | `10` | 5 星评论数量，最多 100 条。 |
| `filterByKeyword` | string | 否 | — | 按关键词筛选评论，最大长度 1000 字符。 |
| `sortBy` | string | 否 | `recent` | 评论排序方式：`recent`（最新评论）或 `helpful`（最有用评论）。 |
| `reviewerType` | string | 否 | `all_reviews` | 评论者类型：`all_reviews`（所有评论）或 `avp_only_reviews`（仅认证购买）。 |
| `mediaType` | string | 否 | `all_contents` | 媒体类型：`all_contents`（所有内容）或 `media_reviews_only`（仅包含媒体的评论）。 |
| `formatType` | string | 否 | `all_formats` | 格式类型：`all_formats`（所有格式）或 `current_format`（当前格式）。 |

若 `star1Num` 至 `star5Num` 均未传，则各星级默认抓取 10 条；若传入任意一个星级数量，其余未传的星级数量默认为 0。无需传 `provider`，后端根据 `domainCode` 自动选择 Pango 或 Apify。
