# Agent Delivery Playbook

简体中文 | [English](README.en.md)

面向多 Agent 协作的工程交付手册与可复用 Skills，支持内置子 Agent 和本地 Agent CLI。

## 安装

需要 Git、curl 和 POSIX shell（macOS、Linux 或 Windows WSL／Git Bash）：

```sh
curl -fsSL https://raw.githubusercontent.com/yinghuzhu/agent-delivery-playbook/main/scripts/bootstrap.sh -o /tmp/agent-delivery-playbook-bootstrap.sh && sh /tmp/agent-delivery-playbook-bootstrap.sh install --agent shared
```

参数 `--agent shared|codex|claude` 选择共享目录或工具专用目录；其他支持 SKILL.md 的工具用 `--dest` 指定目录。安装不等于所有工具均支持自动发现。脚本克隆到 `${XDG_DATA_HOME:-~/.local/share}/agent-delivery-playbook`，然后为五个完整 skill 建立符号链接。已有不同来源的同名入口会阻止安装，不覆盖已有文件。

默认安装最新 annotated `YYYYMMDDNN` 发布 tag；没有正式版本则停止，不回退分支。bootstrap 从最新发布 tag 下载安装脚本。`--ref` 可固定 tag 或 commit；固定版本不自动更新。`--ref develop` 跟随开发分支。`--source` 可复用本地完整仓库，`--checkout` 可指定克隆位置。移动或删除仓库会使链接失效。

## 配置和更新

个人配置：`${XDG_CONFIG_HOME:-~/.config}/agent-playbook/agents.yaml`。安装时仅在不存在时创建，用户在此填写 CLI、模型、首选及备用。项目根 `agent-playbook.yaml` 可覆盖。优先级：当前用户明确指令 → 项目配置 → 用户配置 → skill 内 `agents.yaml` 默认值；合并规则见 `skills/delivery-workflow/references/agent-selection.md`。

```sh
sh "${XDG_DATA_HOME:-$HOME/.local/share}/agent-delivery-playbook/scripts/install.sh" update
```

默认发布通道更新到更新编号的正式 tag，并要求提交历史可前进；develop 通道仅 fast-forward；固定版本不自动更新。有本地修改或历史分叉时停止。更新保留个人配置，链接指向同一份新版源码；已加载会话可能需要重新读取或重启。自定义克隆位置时给 update 传 `--checkout`。

## 规则与技能

- `AGENTS.md`：人工审阅后合并到目标项目，安装器不覆盖全局规则。
- `delivery-workflow`：设计、开发、Review、独立测试及人工验收。
- `acceptance-qa`：业务验收及关联回归。
- `bug-record`：可追溯缺陷记录。
- `root-cause-investigation`：基于证据排障。
- `release-delivery`：制品、发布、验证及回退。

所有角色遵守项目授权；安装不会授权提交、推送、部署或外部通知。运行时模型可用性仍需实际任务验证。

## 分支与发布

日常开发提交到 `develop`，验证后合入 `main`。正式发布在已验证提交上创建 annotated `YYYYMMDDNN` tag，创建及推送须人工明确授权，既有远程 tag 不移动或覆盖。记录发布 tag、commit SHA、变化及验证结果。默认安装与更新只跟随正式 tag，不跟随 main HEAD。
