# 智慧芽检索式专利检索

路径：`/zhihuiya/querySearchPatent`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 3 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| queryText | string | 是 | — | Analytics 检索式，最大 12,000 字符，支持 `TACD:`、`TAC:`、`TA:` 等字段前缀和 `AND`/`OR`/`NOT` 布尔运算。 |
| limit | integer | 否 | `10` | 返回专利个数，范围 1–1000。 |
| offset | integer | 否 | `0` | 偏移量，范围 0–19,999；`limit + offset` 不能超过 20,000。 |
| sort | array | 否 | — | 排序条件数组，每个元素为 `{field, order}`；`field`：`PBDT_YEARMONTHDAY`、`APD_YEARMONTHDAY`、`ISD`、`SCORE`；`order`：`DESC` 或 `ASC`。 |
| stemming | integer | 否 | `0` | 是否开启截词检索：`1` 开启、`0` 关闭。 |
| collapseType | string | 否 | `ALL` | 去重方式：`ALL`、`APNO`、`DOCDB`、`INPADOC`、`EXTEND`。 |
| collapseBy | string | 否 | — | 去重排序字段：`APD`、`PBD`、`AUTHORITY`、`SCORE`。 |
| collapseOrder | string | 否 | — | 去重排序顺序：`OLDEST` 或 `LATEST`。 |
| collapseOrderAuthority | array | 否 | — | 受理局优先级数组，仅当 `collapseBy=AUTHORITY` 时有效。 |

缺少 `queryText` 时网关返回 `errcode: 400`；例如 `TACD: virtual reality` 表示在标题、摘要、权利要求和说明书中检索该词。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| errcode | integer | 业务状态，`200` 表示成功。 |
| errmsg | string | 成功为 `ok`，失败为错误描述。 |
| total | integer | 本次返回结果数。 |
| data | array | 专利列表。 |
| columns | array | 渲染列元信息，不是数据记录。 |
| type | string | 渲染样式。 |
| costToken | integer | 消耗 token。 |
| allRecordsCount | integer | 检索命中总数。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 智慧芽专利 ID。 |
| pn | string | 公开（公告）号。 |
| title | string | 专利标题。 |
| apdt | integer | 申请日（YYYYMMDD）。 |
| pbdt | integer | 公开日（YYYYMMDD）。 |
| apno | string | 申请号。 |
| authority | string | 受理局，例如 `US`。 |
| inventor | string | 发明人，多人以 `\|` 分隔。 |
| originalAssignee | string | 原始申请人，多个以 `\|` 分隔。 |
| currentAssignee | string | 当前申请人，多个以 `\|` 分隔。 |
