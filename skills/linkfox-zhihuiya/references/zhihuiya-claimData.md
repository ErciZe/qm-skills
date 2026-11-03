# 智慧芽权利要求查询

路径：`/zhihuiya/claimData`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 81 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | 否* | — | 智慧芽内部专利 ID，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符。 |
| patentNumber | string | 否* | — | 公开公告号，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符。 |
| replaceByRelated | string | 否 | — | 当前专利权利要求无法获取时是否用同族专利替代：`1` 是，`0` 否，最大长度 1,000 字符。 |

`patentId` 和 `patentNumber` 至少需要提供一个；同时提供时优先使用 `patentId`。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 记录数。 |
| data | array | 专利列表。 |
| columns | array | 渲染的列定义。 |
| costToken | integer | 消耗 token。 |
| type | string | 渲染的样式。 |

### data[] 元素结构

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 专利 ID。 |
| pn | string | 公开（公告）号。 |
| pnRelated | string | 替代专利的公开号；仅当使用同族专利替代时提供。 |
| claims | array | 权利要求数组，包含权利要求文本及元数据。 |
| claimCount | integer | 权利要求数量。 |
