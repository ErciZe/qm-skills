# 智慧芽详细著录信息

路径：`/zhihuiya/bibliography`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/zhihuiya_patent.md)；核对日期：2026-11-03。

- **积分消耗**：动态计费：消耗算力 = 81 × 返回 `data` 条数。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| patentId | string | 条件必填 | — | 专利 ID，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符；与 `patentNumber` 同时存在时优先使用。 |
| patentNumber | string | 条件必填 | — | 公开公告号，多个用英文逗号隔开，上限 100 条，最大长度 60,000 字符。 |

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| total | integer | 记录数。 |
| data | array | 著录项目数据列表。 |
| columns | array | 渲染的列。 |
| type | string | 渲染的样式。 |
| costToken | integer | 消耗 token。 |

### data 数组中的每个对象

| 字段 | 类型 | 说明 |
|------|------|------|
| patentId | string | 专利 ID。 |
| pn | string | 公开公告号。 |
| inventionTitle | array | 专利标题语言和名称。 |
| abstracts | array | 专利摘要。 |
| patentType | string | 专利类型：`APPLICATION` 发明申请、`PATENT` 授权发明、`UTILITY` 实用新型、`DESIGN` 外观设计。 |
| applicants | array | 原始申请人。 |
| assignees | array | 当前申请（专利权）人。 |
| inventors | array | 发明人。 |
| agents | array | 专利申请人。 |
| agency | array | 申请代理机构。 |
| examiners | array | 审查员信息。 |
| priorityClaims | array | 优先权声明。 |
| applicationReference | object | 申请文件引用数据。 |
| publicationReference | object | 公开文件引用数据。 |
| datesOfPublicAvailability | object | 公开可用日期。 |
| classificationIpcr | object | IPC 分类号。 |
| classificationCpc | object | CPC 分类号。 |
| classificationUpc | object | 美国专利分类号。 |
| classificationLoc | array | LOC 分类号。 |
| classificationFi | array | FI 分类号。 |
| classificationFterm | array | F_term 分类号。 |
| classificationGbc | object | GBC 分类号。 |
| referenceCitedPatents | array | 引用专利文献。 |
| referenceCitedOthers | array | 引用非专利文献。 |
| relatedDocuments | array | 分案、继续申请信息。 |
| pctOrRegionalFilingData | object | PCT 或区域阶段申请数据。 |
| pctOrRegionalPublishingData | object | PCT 或区域阶段公开数据。 |
| exdt | integer | 智慧芽专利预估到期日。 |
