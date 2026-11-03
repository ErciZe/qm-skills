# 智慧芽法律状态

路径：`/zhihuiya/legalStatus`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 81 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | 条件必填 | — | 专利 ID，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符；与 `patentNumber` 同时存在时优先使用。 |
| patentNumber | string | 条件必填 | — | 公开（公告）号，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符。 |

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 记录数。 |
| data | array | 专利法律状态列表。 |
| columns | array | 渲染的列定义。 |
| costToken | integer | 消耗 token。 |
| type | string | 渲染的样式。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 专利 ID。 |
| pn | string | 公开（公告）号。 |
| simpleLegalStatus | array | 简单法律状态：`Inactive`（失效）、`Active`（有效）、`Pending`（审中）、`Undetermined`（未确认）、`PCT designated period`（PCT 指定期内）、`PCT designated expiration`（PCT 指定期满）。 |
| legalStatus | array | 法律状态：`Published`（公开）、`Examining`（实质审查）、`Granted`（授权）、`Double`（避免重复授权）、`Abandoned-Undetermined`（放弃-未指定类型）、`Abandoned-Voluntarily`（放弃-主动放弃）、`Abandoned-Deemed`（放弃-视为放弃）、`Withdrawn-Undetermined`（撤回-未指定类型）、`Withdrawn-Voluntarily`（撤回-主动撤回）、`Withdrawn-Deemed`（撤回-视为撤回）、`Rejected`（驳回）、`Revoked`（全部撤销）、`Expired`（期限届满）、`Non-Payment`（未缴年费）、`Restoration`（权利恢复）、`Ceased`（权利终止）、`P-Revoked`（部分无效）、`Discontinuation`（申请终止）、`PCT published`（PCT 国际公布）、`PCT entering(designated period)`（PCT 进入指定国-指定期内）、`PCT entering(designated expiration)`（PCT 进入指定国-指定期满）、`PCT unentered`（PCT 未进指定国）。 |
| eventStatus | array | 法律事件：`Transfer`（权利转移）、`License`（许可）、`Pledge`（质押/担保）、`Trust`（信托）、`Opposition`（异议）、`Re-examination`（复审）、`Customs`（海关备案）、`Litigation`（诉讼）、`Preservation`（保全）、`Invalid-procedure`（无效程序）、`Oral-procedure`（口头审理）、`Declassification`（国防解密）、`Double application`（一案双申）。 |
| legalDate | integer | 法律状态更新日期（时间戳）。 |
