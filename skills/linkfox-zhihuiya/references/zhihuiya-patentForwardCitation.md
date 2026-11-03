# 智慧芽专利引用

路径：`/zhihuiya/patentForwardCitation`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 81 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | 条件必填 | — | 专利 ID，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符。 |
| patentNumber | string | 条件必填 | — | 公开公告号，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符。 |

每次请求至少需要提供 `patentId` 或 `patentNumber` 其中之一；同时提供时优先使用 `patentId`。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 记录数。 |
| data | array | 专利列表，每个元素包含引用详情。 |
| columns | array | 渲染的列定义。 |
| costToken | integer | 消耗 token。 |
| type | string | 渲染的样式。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 查询专利的专利 ID。 |
| pn | string | 查询专利的公开（公告）号。 |
| citedPatents | array | 引用专利列表。 |
| citedOthers | array | 引用非专利文献列表。 |
