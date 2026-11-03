# 智慧芽专利说明书

路径：`/zhihuiya/descriptionData`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 81 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | 条件必填 | — | 专利 ID，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符；与 `patentNumber` 同时存在时优先使用。 |
| patentNumber | string | 条件必填 | — | 公开公告号，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符。 |
| replaceByRelated | string | 否 | — | 当前专利说明书无法获取时是否用同族专利替代：`1` 是，`0` 否，最大长度 1,000 字符。 |

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 返回的专利记录数。 |
| data | array | 专利列表，每个元素包含说明书数据。 |
| columns | array | 渲染的列定义。 |
| costToken | integer | 消耗 token。 |
| type | string | 渲染的样式。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 专利 ID。 |
| pn | string | 公开（公告）号。 |
| pnRelated | string | 替代专利的公开号；仅当使用同族专利替代时提供。 |
| description | array | 说明书内容章节。 |
