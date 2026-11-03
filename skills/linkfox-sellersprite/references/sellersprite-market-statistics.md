# 卖家精灵-选市场统计

路径：`/sellersprite/market/statistics`；请求方式：POST；参数放入 SCM 代理的 `params`，不是外层字段。

来源：[LinkFox 官方文档](https://agent-files.linkfox.com/skills/_tools_matrix/api-docs/tools/sellersprite.md)；核对日期：2026-11-03。

以下为当前请求参数契约。未填的选填参数保留为空缺，不猜默认筛选；参数中的 false、0 与空值有不同含义。

- **积分消耗**：15 积分

## 请求参数

POST Body（JSON）：

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| marketplace | string | 是 | `US` | 站点编码 |
| nodeIdPath | string | 是 | — | 节点 ID 路径字符串，例如 `1064954:1069242:1069784:1069820:1069838:1069828` |
| month | string | 否 | — | `nearly` 或 `yyyyMM` |
| topN | integer | 否 | `10` | 头部 Listing 数量，用于头部相关指标口径 |
| newProduct | integer | 否 | `6` | 新品定义（月） |

#### marketplace 可选值

| 取值 | 含义 |
|------|------|
| US | 美国站 USD($) |
| JP | 日本站 JPY(￥) |
| UK | 英国站 GBP(£) |
| DE | 德国站 EUR(€) |
| FR | 法国站 EUR(€) |
| IT | 意大利站 EUR(€) |
| ES | 西班牙站 EUR(€) |
| CA | 加拿大站 C$($) |
| IN | 印度站 INR(₹) |

#### month

- **格式**：`^(nearly|(19|20)\d{2}(0[1-9]|1[0-2]))$`
- **`nearly`**：最近30天。
- **`yyyyMM`**：具体月份，例如 `202507`；最多支持当前月往前共24个月内的月份。
