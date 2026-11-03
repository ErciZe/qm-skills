# 智慧芽全文附图

路径：`/zhihuiya/fulltextImage`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：81 算力。

## 请求参数

POST Body（JSON）。所有参数值均为字符串，最大长度 1,000 字符：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | 否* | — | 专利 ID。 |
| patentNumber | string | 否* | — | 公开（公告）号。 |
| limit | string | 否 | `"100"` | 返回图片总量，最大 100。 |
| offset | string | 否 | — | 偏移量。 |

`patentId` 和 `patentNumber` 至少需要提供一个。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 记录数。 |
| data | array | 专利列表。 |
| columns | array | 渲染的列。 |
| costToken | integer | 消耗 token。 |
| type | string | 渲染的样式。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 专利 ID。 |
| pn | string | 公开（公告）号。 |
| fulltextImagePath | string | 图片路径。 |
| imageType | string | 图片类型。 |
