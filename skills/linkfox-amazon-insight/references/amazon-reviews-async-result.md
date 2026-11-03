# 亚马逊商品评论（异步查询）

路径：`/amazon/reviews/async/result`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_front_data.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：提交、处理中、失败、取消和超时不应根据预估值记账；提交和查询响应中的 `X-Cost-Token` / `costToken` 为 `0` 只表示本次接口不再扣费，任务费用由后端独立结算，实际消耗以消费记录为准。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `taskId` | string | 是 | — | 异步提交接口返回的任务 ID。 |
