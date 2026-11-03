# 智慧芽简单著录信息

路径：`/zhihuiya/simpleBibliography`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 81 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | 条件必填 | — | 专利 ID，多个用英文逗号隔开，最多 100 个；与 `patentNumber` 同时存在时优先使用。 |
| patentNumber | string | 条件必填 | — | 公开公告号，多个用英文逗号隔开，最多 100 个。 |

`patentId` 和 `patentNumber` 至少需要提供一个。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 记录数。 |
| allRecordsCount | integer | 总记录数。 |
| data | array | 著录项列表。 |
| columns | array | 渲染的列定义。 |
| type | string | 渲染的样式。 |
| costToken | integer | 消耗 token。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 专利 ID。 |
| title | string | 专利标题。 |
| abstractContent | string | 专利摘要。 |
| publicationNumber | string | 公开号。 |
| pn | string | 公开公告号。 |
| country | string | 国家代码。 |
| publicationCountry | string | 公开国家。 |
| publicationDate | string | 公开日期。 |
| publicationKind | string | 公开类型代码。 |
| patentType | string | 专利类型（发明、实用新型、外观设计等）。 |
| kind | string | 专利类型代码。 |
| applicationNo | string | 申请号。 |
| applicationDate | string | 申请日期。 |
| applicants | array | 申请人列表。 |
| inventors | array | 发明人列表。 |
| assignees | array | 专利权人列表。 |
| assigneeAddresses | array | 专利权人地址列表。 |
| ipcMain | string | IPC 主分类号。 |
| ipcFurther | array | IPC 副分类号列表。 |
| cpcMain | string | CPC 主分类号。 |
| cpcFurther | array | CPC 副分类号列表。 |
| loc | array | LOC 分类号列表。 |
| gbc | array | GBC 分类号列表。 |
| priorityClaims | array | 优先权声明列表。 |
| pctApplicationNo | string | PCT 申请号。 |
| pctFilingDate | string | PCT 申请日期。 |
| pctEntryDate | string | PCT 进入日期。 |
| citedPatents | array | 引用专利列表。 |
| citedNonPatents | array | 引用非专利文献列表。 |
