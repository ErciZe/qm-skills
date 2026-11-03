# 细分市场洞察信息

路径：`/jiimore/getNicheInfo`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/jiimore.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：`9`

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| nicheId | string | 是 | — | 细分市场ID，最大长度1000字符，只支持单个ID查询 |
| countryCode | string | 否 | US | 国家编码，仅支持 `US`、`JP`、`DE`，默认 `US` |
