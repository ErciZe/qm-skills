# 亚马逊 ABA-智能查询

路径：`/aba/intelligentQuery`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/amazon_business_insight.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：按动态规则计费：初始SQL生成算力 + 各成功任务执行/重试算力之和 + `round(CSV文件大小MB × 0.075)`；仅成功任务计费，无成功任务时为0。具体消耗以响应中的 `costToken` 及账户实时计费规则为准。

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| analysisDescription | string | 是 | - | 精确描述查询意图的自然语言。 |
| region | string | 否 | `US` | 亚马逊站点代码。可选值：`US`、`DE`、`BR`、`CA`、`AU`、`JP`、`AE`、`ES`、`FR`、`IT`、`SA`、`TR`、`MX`、`SE`、`NL`。 |
| createDownloadUrl | boolean | 否 | `false` | 是否生成CSV下载链接；明确要求下载、导出或生成文件时设为 `true`。 |
