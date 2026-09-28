# 领星密码凭证配置向导

仅在本轮 Keychain 清单确认用户尚未配置领星密码凭证时使用；不能以环境变量不存在作为唯一依据。先告诉用户：密码只填写在 QM 打开的加密一次性页面，不要发在聊天里。按以下顺序发送说明，并附上对应图片；图片与步骤一一对应，不要只发送图片。

1. 在 QM 会话右上角点击钥匙图标，打开 **Keychain**。配图：`keychain-entry.png`。
2. 点击 **Add credential**。填写 **Service** 为 `领星密码`，**Environment variable** 为 `LINGXING_PWD`，**Purpose** 为 `领星登录表单使用的密码`，然后点击 **Continue**。环境变量字段虽然标为 optional，本流程仍需填写，供沙箱按名称取用。配图：`keychain-fields.png`。
3. 点击 **Open the one-time page**。在新打开的一次性页面中由用户本人粘贴密码，并点击 **Submit securely**。看到 `Received — you can close this tab and return to the conversation.` 后关闭该页，回到 QM 点击 **Done**。配图：`keychain-one-time.png`。截图只展示打开一次性页面的入口，不包含密码输入页。
4. 请用户在原会话回复“已配置”。在新轮次先核对 Keychain 清单中的所有者、作用域和授权状态。若清单提供 `LINGXING_PWD` 的命令级凭证 handle，执行检查命令时通过 `credentials` 字段传入准确 handle；否则按当前会话的环境注入方式检查。只检查变量是否存在，不打印值。若凭证存在但本轮仍不可用，报告作用域或授权问题，不让用户在聊天中提供密码或重复创建凭证。

三张配图来自 QM Keychain 页面，分别对应钥匙入口、凭证字段和一次性页面入口。它们以 UTF-8 Base64 文本存放在本 Skill 的 `assets/` 下，因为 Skill Pack 不接受二进制资产。需要发图时，在沙箱中一次性执行：

```bash
set -e
mkdir -p "$PWD/work/lingxing-credential-guide"
base64 -d < skills/lingxing-erp-login/assets/keychain-entry.png.b64 > "$PWD/work/lingxing-credential-guide/keychain-entry.png"
base64 -d < skills/lingxing-erp-login/assets/keychain-fields.png.b64 > "$PWD/work/lingxing-credential-guide/keychain-fields.png"
base64 -d < skills/lingxing-erp-login/assets/keychain-one-time.png.b64 > "$PWD/work/lingxing-credential-guide/keychain-one-time.png"
```

当前轮有 `post` 工具时，用其 `files` 参数发送三个 PNG 和上述步骤；没有 `post` 时，调用 `attach` 发送 PNG，并在回复中给出步骤。以工具结果确认发送成功；若当前会话无法发送图片，保留完整文字步骤并说明图片不可用。不要把 Base64 正文贴进聊天，也不要将一次性页面链接转发给其他人。
