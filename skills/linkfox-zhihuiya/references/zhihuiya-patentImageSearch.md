# 智慧芽专利图像检索

路径：`/zhihuiya/patentImageSearch`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：81 算力。

## 请求参数

POST Body（JSON）：

必填参数：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| url | string | 是 | — | 图像 URL，最大 1,000 字符。 |
| patentType | string | 是 | `D`（API 默认） | 专利类型：`D`（外观专利）或 `U`（实用新型专利）；实用新型 skill 固定使用 `U`。 |
| model | integer | 是 | 外观 `1`；实用新型 `4` | 外观专利：`1`（智能联想，推荐）、`2`（搜索此图）；实用新型：`3`（匹配形状）、`4`（匹配形状/图案/色彩，推荐）。 |

可选参数：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| country | string | 否 | — | 专利受理局国家/组织/地区代码，多个用英文逗号隔开；不传表示全部受理局。 |
| loc | string | 否 | — | LOC 分类，多个分类号可用 `AND`/`OR`/`NOT` 连接。 |
| legalStatus | string | 否 | — | 详细法律状态代码，多个用英文逗号隔开：`1` 公开、`2` 实质审查、`3` 授权、`8` 避免重复授权、`11` 撤回、`12` 撤回-未指定类型、`17` 撤回-视为撤回、`18` 撤回-主动撤回、`13` 驳回、`14` 全部撤销、`15` 期限届满、`16` 未缴年费、`21` 权利恢复、`22` 权利终止、`23` 部分无效、`24` 申请终止、`30` 放弃、`19` 放弃-视为放弃、`20` 放弃-主动放弃、`25` 放弃-未指定类型、`222` PCT 未进入指定国-指定期内、`223` PCT 进入指定国-指定期内、`224` PCT 进入指定国-指定期满、`225` PCT 未进入指定国-指定期满。 |
| simpleLegalStatus | string | 否 | — | 简单法律状态：`0` 失效、`1` 有效、`2` 审中、`220` PCT 指定期满、`221` PCT 指定期内、`999` 未确认。 |
| assignees | string | 否 | — | 申请（专利权）人，最大 1,000 字符。 |
| applyStartTime | string | 否 | — | 申请起始日期，格式 `yyyyMMdd`。 |
| applyEndTime | string | 否 | — | 申请截止日期，格式 `yyyyMMdd`。 |
| publicStartTime | string | 否 | — | 公开起始日期，格式 `yyyyMMdd`。 |
| publicEndTime | string | 否 | — | 公开截止日期，格式 `yyyyMMdd`。 |
| limit | integer | 否 | `10` | 返回专利条数，1–100。 |
| offset | integer | 否 | `0` | 偏移量，0–1000。 |
| field | string | 否 | `SCORE` | 排序字段：`SCORE`（相关性）、`APD`（申请日）、`PBD`（公开日）、`ISD`（授权日）。 |
| order | string | 否 | `desc` | `field` 为日期字段时有效：`desc` 或 `asc`。 |
| lang | string | 否 | `original` | 标题语言：`original`（原文）、`cn`（中文翻译）、`en`（英文翻译）。 |
| preFilter | integer | 否 | `1` | 是否开启前置国家/LOC 过滤：`1` 开启、`0` 关闭。 |
| stemming | integer | 否 | `0` | 是否开启截词：`1` 开启、`0` 关闭。 |
| mainField | string | 否 | — | 专利主要字段，包括标题、摘要、权利要求、说明书、公开号、申请号、申请人、发明人和 IPC/UPC/LOC 分类号，最大 1,000 字符。 |
| includeMachineTranslation | boolean | 否 | — | 是否搜索包含机器翻译数据。 |
| scoreExpansion | boolean | 否 | — | 是否进行分数拓展。 |
| isHttps | integer | 否 | `0` | 图片域名协议：`1` 返回 HTTPS、`0` 返回 HTTP。 |
| returnImgId | boolean | 否 | `false` | 是否返回 `imgId`。 |

`model` 必须与 `patentType` 匹配：`D` 只能使用 1–2，`U` 只能使用 3–4。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 本次返回的记录数。 |
| allRecordsCount | integer | 数据库中匹配的总记录数。 |
| data | array | 匹配的专利记录列表。 |
| columns | array | 渲染的列定义。 |
| type | string | 渲染的样式。 |
| costToken | integer | 消耗 token。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 相似专利 ID。 |
| patentPn | string | 相似专利号。 |
| apno | string | 申请号。 |
| title | string | 专利名称。 |
| inventor | string | 发明人。 |
| originalAssignee | string | 原始申请人。 |
| currentAssignee | string | 当前申请人。 |
| authority | string | 受理局国家代码。 |
| url | string | 相似专利附图 URL。 |
| score | number | 相似度分数；分数越高越相似，仅当 `field=SCORE` 时有效。 |
| loc | array | LOC 分类。 |
| locMatch | integer | 是否命中高权重 LOC：`1` 命中、`0` 未命中；仅当 `model=1` 且 `field=SCORE` 时有效。 |
| apdt | integer | 申请日（时间戳）。 |
| pbdt | integer | 公开日（时间戳）。 |
| imgId | string | 专利附图 `img_id`；仅当 `returnImgId=true` 时返回。 |
