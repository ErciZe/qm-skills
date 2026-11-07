# 来源记录

- 仓库：https://github.com/msitarzewski/agency-agents
- 上游项目：Agency Agents；仓库所有者：`msitarzewski`，不将仓库所有者自动视为每个角色的作者。
- 原角色名称：PPC Campaign Strategist。
- 原文件作者字段：John Williams (@itallstartedwithaidea)。
- 版权归属：Copyright (c) 2025 AgentLand Contributors，按上游 LICENSE 保留。
- 固定提交：b859c515d813efcfc4755d3471dd9e7686c7706d
- 原文 SHA-256：`3e172aa58ad7f9ea3bad947def69dfe26d66134c0aa88dca60e5aea4b8e25f67`（固定提交原文件的完整下载字节，不是本地改写正文）。
- 最近来源核验：2026-11-07，固定提交的原文件与许可证已实际读取。
- 原文件：[paid-media/paid-media-ppc-strategist.md](https://github.com/msitarzewski/agency-agents/blob/b859c515d813efcfc4755d3471dd9e7686c7706d/paid-media/paid-media-ppc-strategist.md)
- 许可证：MIT，随包保留 [LICENSE](LICENSE)。
- 适配日期：2026-11-07。
- 状态：Noway AI 格式适配，上游正文完整保留，本地边界单独标注、非上游官方 Amazon 专家认证，未完成真实 Agent 业务验收。

## 与原文的区别

上游完整正文按原语言保留，包括角色定位、专业方法、工作流程、交付模板、示例代码与参考指标（仅规范文件末尾换行）。未合并其他来源或现有 Skill，也未将通用或多平台角色改为 Amazon 专属角色。

仅替换 YAML 元数据以适配本仓库：名称加 agency 前缀，增加 displayName、scope 和 requiredCapabilities；description 保留原文。上游 color、emoji、vibe、tools、author 等元数据不作为宿主配置；作者归属见上方记录，工具声明不构成授权。

SKILL.md 开头的“本地适配边界”为全部行为差异：排除真实 Amazon API 直接及间接调用，保留公开联网研究与已授权的非 Amazon 集成；写入、花费、部署和定时任务按实际授权执行；角色经历不冒充事实，指标及代码作为待验证参考。该边界优先于上游执行指示，不修改正文中的方法或模板。

## 跟踪上游升级

- 跟踪分支：`main`，这是发现更新的入口，不是本地已采用版本。
- [最新原文件](https://github.com/msitarzewski/agency-agents/blob/main/paid-media/paid-media-ppc-strategist.md)
- [该文件提交历史](https://github.com/msitarzewski/agency-agents/commits/main/paid-media/paid-media-ppc-strategist.md)
- [从当前基线到 main 的仓库差异](https://github.com/msitarzewski/agency-agents/compare/b859c515d813efcfc4755d3471dd9e7686c7706d...main)（按上述原文件路径筛选）。
- [固定版本原始文本](https://raw.githubusercontent.com/msitarzewski/agency-agents/b859c515d813efcfc4755d3471dd9e7686c7706d/paid-media/paid-media-ppc-strategist.md)
- [固定版本许可证](https://github.com/msitarzewski/agency-agents/blob/b859c515d813efcfc4755d3471dd9e7686c7706d/LICENSE)，SHA-256：`9a45258434d5cedf0af73c9ad4771373701225038d246c49219026c33677f66f`。

升级时先比较原文件与许可证，再逐项评估本地适配差异。保留真实 Amazon API 禁令（包括 MCP/代理间接调用），不扩大为禁止所有联网、非 Amazon API 或凭证依赖。新增真实 Amazon 调用工作流须剔除并记录差异；其他变动逐项评审。原文换路径或移除时记录待确认，不按同名文件猜来源。

只有实际采用并完成本地验证后才更新固定提交、原文校验值和适配差异；仅检查到上游更新时保持基线不变。升级须独立评审，不自动覆盖本地改写、不自动推送或发布。
