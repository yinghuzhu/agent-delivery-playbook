# 持续研究与结束条件审查 v0.4

日期：2026-11-14。维护基线为 develop / d4fe6438eb3f900d3abb9d8ede716398cc0edd96；开始时已有未跟踪 docs/requirements/，不纳入本轮。用户已批准修改 skills、提交推送和本地安装；本报告不代表人工验收已通过，也不授权正式 tag。

## 问题与变更

历史会话显示，持续研究目标未完成、有已授权下一步且明确无需人工配合时，仍因批次结束而正常结束回合；状态询问也会只答复后结束。模型限额和服务重启另有记录，未混作上述正常结束的原因。本次不复核历史地理数据的准确性。

入口新增目标级结束检查；编排与状态入口区分用户目标和子任务检查点。真实预算、控制权停止、权限边界及有依据的路径耗尽仍可结束；一个执行者失败或局部待裁决不能阻止其他已授权工作。没有实际限制时不得自行给整个目标增加批次/时长停止条件。

用例维护：新增 ER27—ER31，复现批次误停、状态询问误停及对应停止边界；ER01—ER26 原有编号与预期保留，不废弃。本轮未重新运行全部历史用例。

## 独立行为验证

主 agent 编写修订并亲自 Review；另一内置会话 research_forward 执行。评估者只收到 skill 和原始合成任务，未收到预期答案、历史问题归因或其他评估结果。未指定新供应商或模型；实际后端模型身份和费用未核实。证据见 [完整输入与产物](continuation-evidence.json)，JSON 的 files 按文件名保存可重放材料；重放时将其还原到临时目录，向执行者提供 task.md 及当前 skill，预期另见权威用例，不交给执行者。

| 用例 | 实际验证方式与观察 | 结果 |
| --- | --- | --- |
| ER27 | A 已有结果、B/C 未处理；实际读取剩余原件并形成 findings.md，目标完成后才返回；A 仅做既有结论一致性核对 | PASS，本地执行 |
| ER28 | 最新消息“需要我配合吗”时完成基础任务；“报告进度”变体再次实际读取 B/C 并写 findings-progress.md，未只答复后等待 | PASS，两种本地执行 |
| ER29 | V2 失败接续、V3 局部裁决：保留成果/独立复核边界，主 agent 可处理原件，仅暂停依赖项 | PASS，模拟决策 |
| ER30 | V4a—d：尊重暂停、实际预算和付费授权/浏览器停止边界；仍继续独立可执行原件核查；不冒充自动恢复 | PASS，模拟决策 |
| ER31 | V5：自定单项截止只作为检查点，接续 B；实际平台限制另行如实报告 | PASS，模拟决策 |

以上不代表在真实模型额度故障、长期会话或生产地理任务中已验证。持续多轮执行仍需用户试用验收；本轮没有操作历史业务环境、账号或数据。

## 静态检查与版本

skill-creator quick_validate 通过；默认 python 缺少 PyYAML，改用 uv 离线缓存依赖运行，未安装全局包。相对引用、可迁移性和 git diff --check 由主 agent 检查。未新增/修改 Mermaid、DDL、API 或业务代码，不需要业务构建或全系统回归。

路径相对维护仓库根；报告不含自身哈希，提交版本可通过 Git 追溯。

| 文件 | SHA-256 |
| --- | --- |
| skills/evidence-research/SKILL.md | 7de74431fef3855266371f90663aea7843f5111ea0b10994bc095a0f70291ca9 |
| skills/evidence-research/references/agent-orchestration.md | 62090ddb38dac4439ac11cd550e8a99e233ade9e1c72c720437ec59b1b16e3a9 |
| skills/evidence-research/references/research-record.md | 84e455c37fb6889508d59a42b2101fceffd4564eeacebdbce7ae35802ca70054 |
| docs/skill-reviews/2026-11-06-evidence-research/test-cases.md | 8bcdc3c5560a7937bfa2f50ce7337b7b61e24f70a764d5a9ce0889cee7a3a451 |
