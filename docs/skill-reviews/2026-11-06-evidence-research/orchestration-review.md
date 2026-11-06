# evidence-research v0.2 子 agent 编排审查

## 范围与基线

用户要求研究中的并行任务可交给子 agent，主 agent 做调度与裁决，参考 delivery-workflow；最终确认配置共用一份，selection 中增加 search 和 review，各自配置不同职责的 agent。以下为源码与文档修订时的审查快照：当时尚未提交、推送或安装，本地试用固定在 `be594bdd42f8c6c736f62b20da68eda058344d45`。后续用户已授权提交远程开发分支并更新本地试用，不创建正式发布；实际交付版本以 Git 记录及本地安装记录为准。提交和安装不改变下文行为用例未执行的事实。

本轮基线为 `develop` / `b211ff5b81f7ca69a66800076cb5381991d1a00a`，开始时工作区干净。读取当前 delivery-workflow 的入口、agents.yaml、agent-selection.md、handoff-contracts.md，以及 evidence-research 的入口、记录约定和权威用例。后续已有的定向回归规则保留，未修改交付用 AGENTS.md 或安装脚本。

## 变更与理由

| 目标 | 当前证据与分类 | 本轮差异 | 兼容与用例 |
| --- | --- | --- | --- |
| 主 agent 调度、子 agent 调查 | evidence-research/SKILL.md 原“多 agent 可选”段，修改 | 对有并行收益且获准的任务主动派工，主 agent 管口径、依赖、核验和最终结论 | 小任务仍可单独执行；ER11/12 复用，ER13 新增 |
| 共用模型配置 | delivery-workflow/agents.yaml 已有 agents、development/testing、progress，复用并扩展 | 新增 selection.search/review，各自空首选和空备用；候选与进度不复制 | 开发/测试字段不变，旧文件兼容；ER14/15/19 新增 |
| 研究选择与接续 | agent-selection.md 的按 ID 合并、角色覆盖、CLI 发现及备用规则，复用 | 调查和复核首次派工前分别选择 search/review，使用不同会话与各自备用 | 不进入开发门槛，不自动继承其他角色；ER14/19 |
| 任务交接和并发隔离 | research-record.md 旧交接字段，修改；新增 agent-orchestration.md | 增加任务单、依赖、状态、资源归属、证据回传和写入隔离 | 只有主 agent 更新公共结论，返回进入待核验；ER13/16 |
| 证据裁决与失败处理 | 共用研究循环已有证据限制，复用并具体化 | 不按多数投票、保留分歧、区分证据缺口与服务故障，切换前确认旧执行停止 | 仅暂停受影响部分，不重复运行/计费；ER16/17 |
| 进度与结束 | delivery-workflow 进度/失败接续规则，按研究职责复用 | 默认 10 分钟、平台更严优先；分段等待、及时报告、口径变化通知、结束收拢 | 不新建后台服务，不承诺无法做到的唤醒；ER06/09 复用，ER17/18 新增 |

配置唯一默认源为 `skills/delivery-workflow/agents.yaml`。原有用户配置和项目覆盖仍是同一套配置机制，不新增 research 专属文件。安装来源通过当前技能目录或明确维护仓库定位，不依赖 sibling 链接；如果共享默认不可用，可使用用户指定的完整现有配置，否则只暂停配置依赖的派工，继续普通研究。

本轮是指令与配置文档更新，无业务数据库、API 或自动调度程序；无需 DDL/API 或业务状态机。任务状态及运行边界在编排说明中给出。

## 权威用例与验证边界

唯一权威用例为 [test-cases.md](test-cases.md) v0.2。ER01—ER12 原业务预期复用，版本入口更新；ER13—ER19 新增覆盖并行、共享配置、矛盾裁决、失败进度和结束。无用例删除或降级。v0.1 [历史报告](review-report.md)对应当时版本，不能证明 v0.2 通过。

本轮定向行为验证清单：ER06、ER09、ER11、ER12、ER13—ER19；原因是模式/口径切换、停止条件、能力限制及新编排机制受到影响。其余场景本轮不运行，不称全系统回归。执行负责人为后续选定的独立评估者，主 agent 核验证据。

以上行为用例目前均为 NOT_RUN：本轮未启动真实调查或付费模型探测，也未确定本轮独立评估执行者的模型选择；不把本次编写用例或结构校验称为多 agent 行为验证。静态检查只验证配置结构、兼容字段、引用和可移植性，实际结果在下节记录。

## 静态检查记录

执行者：主 agent；方式：结构与文件检查，不含真实多 agent 行为执行。

- evidence-research 与 delivery-workflow 的官方 quick_validate 均通过。
- 10 个本轮文件的相对链接检查覆盖 26 处；复制到临时目录、切换工作目录后全部可解析。
- YAML 解析后移除新增 search/review，与 HEAD 配置逐字段相等；agents、development、testing 和 progress 均未改变。研究目录没有另一份 agents.yaml。
- 本轮文档路径、行尾空白和 git diff --check 检查通过；AGENTS.md 与安装脚本没有修改。
- 已安装 v0.1 的入口文件哈希仍为 503d20315d8ddd319cac7c0761ac58fa1ec201dfed6408723e03d36cfbb74f29，未更新本地试用。

以下为未提交文件基线，路径相对维护仓库根；本报告本身不纳入自引用哈希：

| 文件 | SHA-256 |
| --- | --- |
| README.en.md | 2d6069ff3b890940182ad9939d215fbb22cafd0725b8c556442a95ae48c7115e |
| README.md | 203ce24ce97891b30126b8eb456c2699aa28a8d648d2d28dc6a9b5fc004b072d |
| docs/skill-reviews/2026-11-06-evidence-research/review-report.md | 8b980d98b6ee7da3758238534099b5f704d9b49eb7c215f2cb66cbba81446475 |
| docs/skill-reviews/2026-11-06-evidence-research/test-cases.md | efecef79ce6eb57f70d125d44cfe47fedacda7e0bc03a52b3abf2a17b1d689e1 |
| skills/delivery-workflow/agents.yaml | c662189f6ac32d3c1f5a909bdde83ea26521ccd5e0e52d8a95e360b88ee0adb2 |
| skills/delivery-workflow/references/agent-selection.md | 54f0109290b6714593a2ff7f99dd599e4bc26fbd9cbf4b464534483fa899d7b7 |
| skills/evidence-research/SKILL.md | ac6adc2a2d21862aba65a9052750ab4d8e5d60fe87688ceaf533d719ffafb4c4 |
| skills/evidence-research/references/research-record.md | 214472de238b17e070c61eb86f0e79c392ab7f4216ed42b702d8ca0995839f59 |
| skills/evidence-research/references/agent-orchestration.md | e4d25e3d08bed6ef96249e384105f2654c01c92e13090ef5bb0ba76f2fd0e1da |
