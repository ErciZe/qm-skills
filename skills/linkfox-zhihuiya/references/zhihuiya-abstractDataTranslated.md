# 智慧芽摘要翻译

路径：`/zhihuiya/abstractDataTranslated`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 81 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | patentId 和 patentNumber 至少填一个 | — | 智慧芽内部专利 ID，多个用英文逗号隔开，最大长度 60,000 字符。 |
| patentNumber | string | patentId 和 patentNumber 至少填一个 | — | 公开（公告）号，多个用英文逗号隔开，最大长度 60,000 字符。 |
| replaceByRelated | integer | 否 | `0` | 摘要无法获取时是否用同族专利摘要替代：`1` 是，`0` 否。 |
| lang | string | 否 | `en` | 翻译目标语言：`en`（英文）、`cn`（中文）、`jp`（日语），最大长度 1,000 字符。 |

`patentId` 和 `patentNumber` 至少需要提供一个；同时提供时优先使用 `patentId`。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 返回的专利记录数。 |
| data | array | 专利列表。 |
| columns | array | 渲染的列定义。 |
| costToken | integer | 消耗 token。 |
| type | string | 渲染的样式。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 智慧芽内部专利 ID。 |
| pn | string | 公开（公告）号。 |
| title | string | 标题翻译。 |
| abstractText | string | 摘要翻译。 |
| pnRelated | string | 替代专利的公开号；仅当使用同族专利替代时提供。 |
