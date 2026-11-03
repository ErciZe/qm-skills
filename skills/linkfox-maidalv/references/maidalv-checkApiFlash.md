# 卖大律-TRO与知识产权风险检测

路径：`/maidalv/checkApiFlash`；请求方式：POST；参数放入 SCM 代理的 `params`。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/maidalv_product_tro_detection.md)；核对日期：2026-11-03。

- **积分消耗**：技能文档标注消耗 113 算力（约 150000 token），实际以账户计费结果为准。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| mainProductImage | string | 是 | — | 主商品图片，可为公开图片 URL，或带 `data:image/...;base64,` 前缀的 Base64 data URI；最大长度 1000 |
| referenceImages | string[] | 否 | — | 相似产品参考图片数组，元素为 URL 或 data URI，最多 3 张 |
| otherProductImages | string[] | 否 | — | 额外产品图片数组，元素为 URL 或 data URI，最多 5 张 |
| ipImages | string[] | 否 | — | 与知识产权相关的图片数组，元素为 URL 或 data URI，最多 3 张 |
| referenceText | string | 否 | — | 相似产品文本，例如产品标题；最大长度 1000 字符 |
| description | string | 否 | — | 产品描述，建议仅填写产品标题；最大长度 1000 字符 |
| ipKeywords | string[] | 否 | — | 与知识产权相关的关键词数组，最多 20 个 |
| language | string | 否 | `zh` | 法律评估报告语言，仅影响 `report` 字段；可选 `zh` 或 `en` |

图片 URL 必须可公开访问；本地图片需先上传获取公开 URL，或转换为带 `data:image/...;base64,` 前缀的 data URI。

## 上游响应

| 字段 | 类型 | 说明 |
|------|------|------|
| errcode | integer | 业务状态码，`200` 表示成功 |
| errmsg | string | 状态说明，成功时为 `ok` |
| status | string | 分析整体状态，成功时为 `success` |
| checkId | string | 本次检测的唯一标识 |
| type | string | 渲染样式，例如 `tableListWorkbenches` |
| costToken | integer | 本次调用消耗的 token |
| total | integer | 高风险侵权项数量，即 `results` 数组长度 |
| riskLevel | string | 总体风险评估：`高风险`、`中风险` 或 `低风险` |
| results | array | 高风险潜在侵权项列表，字段见下方“侵权项字段” |
| nonResults | array | 非高风险或低相似度 IP 项列表，含可能的 TRO 原告信息，字段见下方“侵权项字段” |
| columns | array | 渲染列定义，仅供展示；长度可能与数据数组不同 |

### 侵权项字段（results / nonResults 元素）

| 字段 | 类型 | 说明 |
|------|------|------|
| ipType | string | IP 类型：`Trademark`、`Copyright` 或 `Patent` |
| text | string | IP 文本内容，如商标文字、专利标题或版权标题 |
| ipOwner | string | 知识产权权利人 |
| regNo | string | 注册号，可能为 JSON 字符串形式的数组，例如 `["1221667"]` |
| riskLevel | string | 风险级别：`High Risk`、`Medium Risk` 或 `Low Risk`；无评分时不出现 |
| riskScore | number | 0-10 数值风险分；无评分时不出现 |
| riskDescription | string | 风险级别文字说明；无评分时不出现 |
| ipAssetUrls | string[] | IP 证据图片 URL 列表 |
| plaintiffId | integer | TRO 原告 ID，仅当该 IP 出现在 TRO 案件中时出现 |
| plaintiffName | string | TRO 原告名称，仅当该 IP 出现在 TRO 案件中时出现 |
| numberOfCases | integer | 该原告提起的案件数量；无案件细节时可能为 `null` |
| lastCaseDocket | string | 最近案件的法院案号；无案件细节时可能为 `null` |
| lastCaseDateFiled | string | 最近案件的立案日期；无案件细节时可能为 `null` |
| report | string | AI 生成的法律评估报告，语言由 `language` 参数决定 |

侵权项字段按需返回：非 TRO、未评分的项目不会返回原告、案件和风险评分字段，而不是将其统一返回为 `null`。高风险项目位于 `results`，其余项目位于 `nonResults`。
