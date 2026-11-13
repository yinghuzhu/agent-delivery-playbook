# 定向测试范围与接续审查 v0.2

日期：2026-11-14。维护基线 develop / d4fe6438eb3f900d3abb9d8ede716398cc0edd96；已有未跟踪 docs/requirements/ 不纳入本轮。用户批准修改、提交推送及本地安装；未批准正式 tag，人工验收尚待用户完成。

## 变更与用例维护

历史问题是无关功能被一般保护性清单列成必跑，环境失败又成为当前验收门槛；另有额外 SDK 加固扩大实现及跨系统验证范围。当前已安装技能含定向原则，本次强化具体准入和范围接续，不把问题归因于原则缺失或单纯版本过旧。

- delivery-workflow 和交接契约增加实际修改点、行为传播路径、用例和必要层级的对应关系；最短完整业务链不等于覆盖链上所有能力。
- acceptance-qa 同步准入、范围外故障及测试者回传主 agent 的处理；共享契约真实影响未修改调用方时仍须验证，用户明确要求的覆盖不得自行取消。
- 额外加固/接入升级不自动成为当前交付前置。状态询问后继续已授权阶段，最终人工验收和 Git/发布授权仍独立。
- 新增 TR09—TR14；TR01—TR08 原有预期保留。本轮未重跑环境复用及浏览器并发旧用例，不把它们计为新版通过；范围外产品用例保留编号，不废弃或改标通过。

## 独立行为验证

主 agent 修订并亲自 Review；另一内置会话 scope_forward 只收到当前 skills、合成 diff/调用链和原任务，不收到预期、问题归因或其他评估结果。未指定新供应商/模型；实际模型身份和费用未核实。输入及原始产物完整保存在 [范围验证证据](scope-evidence.json) 的 files 中，可还原到临时目录重放；权威预期留在 test-cases.md，不交评估者。

| 用例 | 实际观察 | 判定与层级 |
| --- | --- | --- |
| TR09 | 任务单保留 LOAD_SUCCESS/LOAD_RETRY/LATE_TIMER/BUSY_CLOSE/SAVE_DEDUP/SUBMIT_DEDUP；附件、独立入口、全角色扩展移出；CORS 不阻塞且不申请无关修改 | PASS，独立模拟任务单 |
| TR10 | V1 共享拦截器影响上传，纳入重放/去重和有传播依据的关联检查；CORS 此时阻塞相关用例，不改回范围外隐藏 | PASS，独立模拟决策 |
| TR11 | V2 新跑 Retry/timer 影响链，保存/上传复用有效 v1 结果，不因换执行者全部重跑 | PASS，独立模拟决策 |
| TR12 | V3 门控列独立建议，V4 明确保留用户要求的角色/旧客户端维度，不扩展到全系统 | PASS，独立模拟决策 |
| TR13 | 拒绝默认 npm test 全仓命令，给出 node 文件/名称过滤；明确真实标题映射尚未提供，命令是待核验模板；必要浏览器交互保留，不额外引入数据库测试 | PASS，过滤与层级决策；未验证业务命令运行 |
| TR14 | V5 状态回复后继续主 Review/已授权接续；测试完成后先核验证据，交人工验收，不擅自 Git/发布 | PASS，独立模拟决策 |

这验证了执行者如何选择范围、如何形成任务单；没有执行真实产品测试、浏览器、模型故障切换或部署，不能宣称业务通过或长期行为已被保证。正式项目中的精确用例步骤、标题映射和制品等仍须按实际资料准备。评估者未虚构这些缺失前提，主 agent 核验原始产物后接受上述边界。

## 检查与固定版本

delivery-workflow、acceptance-qa 的 skill-creator quick_validate 通过；默认 Python 缺 PyYAML，使用 uv 离线缓存运行校验，未安装全局依赖。主 agent 检查相对引用、可迁移性及 git diff --check。本次不改安装脚本、候选/个人模型配置，不新增 Mermaid、DDL/API 或业务代码；无需运行产品全量测试。

路径相对仓库根；报告本身不纳入自引用哈希，最终提交包含下列版本。

| 文件 | SHA-256 |
| --- | --- |
| AGENTS.md | 0a099e322f4548b72f87a118ae4aa2c608950da442cc6e4f7ecf48aa4fe3b07d |
| skills/delivery-workflow/SKILL.md | d1d82cd08df6b51797b1c0807e448d8a1be30be7dcd419c2947fd91d98e82bb8 |
| skills/delivery-workflow/references/handoff-contracts.md | 9513c57eba9d8d860fab333d86a79a1d59bf9cbf696e32340c8f151de793b03d |
| skills/acceptance-qa/SKILL.md | cec6996f913c83223b201d3da718df30282f027fe27f7d6ba17561c3932a88dc |
| docs/skill-reviews/2026-11-06-delivery-workflow-testing/test-cases.md | 0fb497bf6a8ce2ea74446c50144ae0da5d667bf4baa3cf6e0b29271e39512b86 |
