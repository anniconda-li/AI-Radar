INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'deepseek-chat-guide', 'DeepSeek Chat 使用指南',
       '了解 DeepSeek Chat 适合处理什么任务、怎样提问，以及哪些内容必须回到原始来源核对。',
       'product-guide',
'DeepSeek Chat 是面向普通用户的对话产品。它把模型能力包装成可以直接打开的网页和移动端应用，因此不需要安装开发环境，也不需要创建 API Key。

## 它适合做什么

它适合解释概念、整理长文、改写文本、辅助编程和分步骤推理。上传材料后，可以要求它只依据材料提取观点、列出争议或生成结构化摘要；处理代码时，最好同时提供报错、相关代码和期望行为。

它与开放平台不是同一种入口。只是在网页中提问就使用 Chat；需要让自己的程序自动调用模型、批量处理数据或把能力接进网站时，才需要 DeepSeek 开放平台。

## 怎样得到更有用的回答

一次说明背景、目标、限制和输出格式。与其只写“帮我分析”，不如说明材料是什么、分析给谁看、必须回答哪些问题以及希望得到表格、清单还是文章。

复杂任务可以先让它列出计划，再逐步完成。对长材料先要求概括结构，再针对某一章节追问，通常比一次要求完成所有事情更稳定。

## 使用时要保留判断

模型生成的是基于上下文的回答，不等于事实数据库。政策、价格、产品版本、医学、法律和实时新闻应要求它给出来源，并回到官方网站或原始文件核对。

不要上传密码、API Key、身份证件、未公开源码和企业敏感资料。即使任务本身适合 AI，也要先判断材料是否允许提交给第三方服务。',
       JSON_ARRAY(JSON_OBJECT('label', 'DeepSeek Chat', 'url', 'https://chat.deepseek.com/'), JSON_OBJECT('label', 'DeepSeek 官网', 'url', 'https://www.deepseek.com/')),
       'published', 10, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'deepseek' AND o.slug = 'chat';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'deepseek-api-guide', 'DeepSeek 开放平台接入指南',
       '从 API Key、最小请求到后端接入，说明 DeepSeek API 的正确调用链路。',
       'api-guide',
'DeepSeek 开放平台是给程序调用模型的开发者入口。你的后端携带 API Key 把请求发送给平台，平台按实际用量计费，再把结构化结果返回给程序。它不是另一个聊天网页。

## 调用链路

生产系统中的请求应当按照“浏览器 → 自己的后端 → DeepSeek API → 自己的后端 → 浏览器”流动。API Key 只保存在服务器环境变量或密钥服务中，不能写进 Vue、移动端安装包或 Git 仓库。

## 开始前准备

1. 登录开放平台并创建 API Key。
2. 确认账户有可用余额或赠送额度。
3. 从官方价格页确认模型 ID、上下文和输入输出单价。
4. 先在本机终端做一个最小请求，再接入业务代码。

PowerShell 中可以只为当前窗口设置密钥：

```powershell
$env:DEEPSEEK_API_KEY = "替换成你自己的密钥"
```

随后发送最小请求：

```powershell
curl.exe https://api.deepseek.com/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer $env:DEEPSEEK_API_KEY" `
  --data-raw ''{"model":"deepseek-v4-flash","messages":[{"role":"user","content":"你好"}]}''
```

返回 JSON 并出现 `choices` 表示认证、网络和模型名基本正确。401 通常是密钥问题，402 或余额相关错误要检查账户，429 表示限流，400 通常是请求参数或模型名不符合要求。

## 接入业务时还要做什么

设置连接和读取超时，限制输入长度与最大输出，记录模型、Token、耗时和错误类型，并为用户设置频率及费用上限。聊天页面通常还需要流式转发，但应在普通非流式请求成功后再增加这一层复杂度。

价格和模型会变化，本站保存的是核对时快照，真正上线前必须再次查看官方模型与价格页。',
       JSON_ARRAY(JSON_OBJECT('label', 'API 快速开始', 'url', 'https://api-docs.deepseek.com/'), JSON_OBJECT('label', '模型与价格', 'url', 'https://api-docs.deepseek.com/quick_start/pricing')),
       'published', 20, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'deepseek' AND o.slug = 'open-platform';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'kimi-workspace-guide', 'Kimi 智能工作空间指南',
       '从普通问答到研究、文档、表格和演示，了解 Kimi 主产品如何组织任务。',
       'product-guide',
'Kimi 是月之暗面面向普通用户的综合工作空间。它不只提供一问一答，还把深度研究、文档、表格、演示和网页生成等能力放进同一个入口。

## 什么时候使用 Kimi

需要阅读多份材料、比较多个来源、形成报告或把内容加工成文档时，可以从 Kimi 开始。它适合把“我要了解一个问题”继续推进成“我要一份结构清晰、能够继续编辑的结果”。

如果任务会持续读取本地文件、定时运行或需要桌面环境，应该了解 Kimi Work；需要修改本地代码仓库时使用 Kimi Code；程序自动调用模型则使用 Kimi API 开放平台。

## 把目标说清楚

研究型任务应写明资料范围、必须包含的字段、不要采用的来源和最终格式。例如：仅使用各厂商官方页面，比较模型名称、上下文、输入价、输出价和核对日期，并把来源放在最后一列。

生成文档、表格或演示时，先提供目标读者、长度、结构和已有材料。第一版出来后逐段修改，比一开始只给一句模糊要求更容易得到可用结果。

## 验收结果

检查引用是否真的支持结论，表格中的单位是否一致，导出的文件能否继续编辑。涉及价格、版本和实时信息时，不能因为页面看起来完整就跳过官方核对。

不要上传无权处理的个人信息、公司内部文件和密钥。对重要资料可以先删除敏感字段，再用小样本验证效果。',
       JSON_ARRAY(JSON_OBJECT('label', 'Kimi', 'url', 'https://www.kimi.com/'), JSON_OBJECT('label', 'Kimi 产品总览', 'url', 'https://www.kimi.com/products/')),
       'published', 10, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'moonshot' AND o.slug = 'kimi';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'kimi-work-guide', 'Kimi Work 桌面 Agent 指南',
       '了解 Kimi Work 与网页 Kimi 的区别，以及连接本地文件和自动化任务时需要注意的权限。',
       'product-guide',
'Kimi Work 是面向知识工作者的桌面 Agent。与只在网页中处理上传材料不同，它强调连接本地文件、预集成数据源、计划任务和多个 Agent 协作。

## 它解决什么问题

当资料散落在本机目录、网页和外部数据源中，或者同一项工作需要定期重复执行时，桌面 Agent 比普通对话更合适。典型任务包括汇总一批本地文件、持续跟踪公开信息、按固定格式生成周期报告。

## 使用前先划定权限

桌面工具能接触的文件和账号比网页聊天更多。首次使用应创建专门的测试目录，只放允许它读取的副本；不要一开始就授权整个用户目录、云盘或邮箱。

连接数据源时确认是只读还是可写权限。带有自动提交、发送、删除或覆盖能力的操作应保留人工确认，计划任务也要设置可见的执行记录和失败通知。

## 从一个可验证任务开始

先选择十几个无敏感信息的文件，要求它按指定字段生成摘要，并人工抽查每个来源。如果结果可靠，再扩大资料范围或增加定时执行。多 Agent 并行并不自动代表结果更准确，仍要检查任务拆分是否合理、来源是否重复和最终结论是否一致。

## 与其他 Kimi 产品的关系

临时研究和内容创作使用 Kimi；在代码仓库内工作使用 Kimi Code；需要后端集成使用 Kimi API。Kimi Work 的价值在于桌面环境、本地文件与持续自动化，而不是替代所有入口。',
       JSON_ARRAY(JSON_OBJECT('label', 'Kimi Work 产品入口', 'url', 'https://www.kimi.com/products/'), JSON_OBJECT('label', 'Kimi 产品列表', 'url', 'https://www.kimi.com/products/')),
       'published', 20, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'moonshot' AND o.slug = 'kimi-work';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'kimi-code-guide', 'Kimi Code 安装与使用',
       '在 Windows、macOS 或 Linux 安装 Kimi Code，完成登录，并从只读分析开始使用代码 Agent。',
       'installation-guide',
'Kimi Code 是运行在终端和 IDE 中的编程 Agent。它以启动命令时所在的目录作为项目上下文，可以读取代码、修改文件和执行命令，因此“在哪个目录启动”和“允许它做什么”与安装本身同样重要。

## 开始前检查

Windows 先确认 Git for Windows 可用，Kimi Code 会使用 Git Bash：

```powershell
git --version
```

还需要能够访问 Kimi Code 的官方安装资源，并准备 Kimi Code 订阅登录或相应平台的 API Key。不要在磁盘根目录或用户主目录直接启动代码 Agent。

## 按系统安装

Windows PowerShell：

```powershell
irm https://code.kimi.com/kimi-code/install.ps1 | iex
```

macOS 或 Linux Bash：

```bash
curl -fsSL https://code.kimi.com/kimi-code/install.sh | bash
```

远程安装脚本会变化，执行前确认域名来自官方文档。企业电脑还可能受执行策略、安全软件或代理限制，遇到错误应先阅读原始报错，不要反复运行安装脚本。

## 重开终端并验证

```text
kimi --version
```

能显示版本号只代表命令已经安装。接下来进入真实项目目录再启动：

```powershell
cd C:/Users/你的用户名/Desktop/你的项目
kimi
```

首次进入后使用 `/login`，按照自己购买的订阅或 API 服务完成认证。网页会员、Kimi Code 订阅和开放平台按量 API 不是同一套额度。

## 从只读任务开始

第一次可以要求：“先只读分析当前项目，告诉我主要目录、启动命令和测试命令，不要修改文件。”确认它理解项目后，再让它完成一个范围明确的小改动。

修改后检查 Git diff，运行项目原有测试，并确认没有把 `.env`、密钥、构建产物或无关文件加入提交。代码 Agent 能执行命令不代表所有命令都应该自动批准。',
       JSON_ARRAY(JSON_OBJECT('label', 'Kimi Code 文档', 'url', 'https://www.kimi.com/code/docs/'), JSON_OBJECT('label', 'Kimi Code 产品页', 'url', 'https://www.kimi.com/code/')),
       'published', 30, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'moonshot' AND o.slug = 'kimi-code';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'kimi-webbridge-guide', 'Kimi WebBridge 使用说明',
       '理解浏览器扩展如何让 Agent 操作网页，以及授权网页控制能力前必须检查的安全边界。',
       'product-guide',
'Kimi WebBridge 是连接 AI Agent 与浏览器的扩展。它可以让 Agent 点击页面、填写表单、切换页面并提取可见信息，适合需要连续网页操作的研究和自动化任务。

## 它与普通联网搜索的区别

联网搜索通常返回检索结果；浏览器操作则会真正进入网页并执行步骤。例如比较航班可能涉及选择日期、切换筛选条件和读取多个结果页面，而不只是搜索一个关键词。

## 安装和授权前先确认

只从 Kimi 官方产品页进入扩展安装入口，核对发布者和请求的浏览器权限。浏览器扩展可能看到当前标签页内容，因此不要在同时打开密码管理、企业后台或敏感个人信息页面时随意授权自动操作。

## 从只读网页任务开始

第一次先让它打开公开页面并提取标题、价格或表格，不要马上让它登录账号、提交表单或发送内容。检查它选择的元素和提取结果是否准确，再增加点击和填写步骤。

## 需要人工确认的操作

购买、发布、发送消息、修改权限、上传文件和删除数据都可能产生外部影响，应该在真正提交前停下来确认。验证码、登录和支付也不应尝试绕过网站安全机制。

网页结构会变化，自动化步骤可能失效。重要流程应记录失败位置和页面状态，而不是无限重试点击。',
       JSON_ARRAY(JSON_OBJECT('label', 'Kimi WebBridge', 'url', 'https://www.kimi.com/products/'), JSON_OBJECT('label', 'Kimi 产品列表', 'url', 'https://www.kimi.com/products/')),
       'published', 40, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'moonshot' AND o.slug = 'webbridge';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'kimi-api-guide', 'Kimi API 开放平台接入指南',
       '区分 Kimi 网页产品、Code 订阅和开放平台，并完成一次兼容 OpenAI 协议的模型调用。',
       'api-guide',
'Kimi API 开放平台供程序和后端服务调用模型。它与 Kimi 网页会员、Kimi Code 订阅是不同产品：开放平台通常按 Token 用量计费，密钥、端点和额度不能想当然地混用。

## 开始前准备

在开放平台创建 API Key，确认当前可用模型和价格。密钥只应放在后端环境变量中，不能写进 Vue 前端。

PowerShell 当前窗口设置密钥：

```powershell
$env:MOONSHOT_API_KEY = "替换成你自己的密钥"
```

使用 OpenAI 兼容接口完成最小请求：

```powershell
curl.exe https://api.moonshot.cn/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer $env:MOONSHOT_API_KEY" `
  --data-raw ''{"model":"kimi-k2.6","messages":[{"role":"user","content":"用一句话介绍你自己"}]}''
```

## 怎样选择模型

通用对话、多模态理解和复杂推理可以从 Kimi K2.6 开始；编程 Agent 和长程代码任务优先查看 Kimi K2.7 Code。模型 ID、上下文和可用版本以开放平台当前模型列表为准。

## 接入自己的应用

后端负责读取密钥、校验参数、控制最大输出和费用，再把结果返回浏览器。需要聊天体验时可增加流式输出；需要图片或视频输入时先验证文件大小、格式和上传方式。

上线前记录每次请求使用的模型、Token、耗时和错误类型，设置用户频率限制与费用告警。涉及企业或个人数据时，还要核对平台的数据处理规则。',
       JSON_ARRAY(JSON_OBJECT('label', 'Kimi API 快速开始', 'url', 'https://platform.kimi.com/docs/guide/start-using-kimi-api'), JSON_OBJECT('label', 'Kimi 模型列表', 'url', 'https://platform.kimi.com/docs/guide/start-using-kimi-api')),
       'published', 50, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'moonshot' AND o.slug = 'platform';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'z-ai-guide', 'Z.ai 使用指南',
       '了解 Z.ai 的直接使用场景、与智谱开放平台的区别，以及重要内容的核对方法。',
       'product-guide',
'Z.ai 是智谱面向个人用户的 AI 助手入口，可以直接体验 GLM 模型的对话、创作、推理和代码辅助能力。它适合个人任务，不要求用户先理解 API、模型部署或云平台配置。

## 适合的任务

可以用它解释概念、整理材料、生成内容、分析代码和探索多模态能力。第一次使用时选择一个自己能够判断对错的真实小任务，例如根据给定材料生成摘要，并明确要求不要补充材料之外的事实。

## 与开放平台的区别

Z.ai 是给人直接使用的产品；智谱开放平台是给程序调用模型、构建智能体和管理用量的平台。需要自动化批处理、网站集成或企业应用时，应转到开放平台，而不是尝试控制聊天网页。

## 提问和验收

说明目标、受众、材料范围和输出格式。涉及表格或比较时统一单位，涉及实时资料时要求列出来源。生成代码后必须运行测试，生成结论后要回到官方或原始材料核对。

## 数据边界

不要上传密钥、未公开代码、个人身份信息和没有处理权限的文件。模型适合提高整理和推理效率，但不替代专业审查和最终责任。',
       JSON_ARRAY(JSON_OBJECT('label', 'Z.ai', 'url', 'https://chat.z.ai/'), JSON_OBJECT('label', '智谱官网', 'url', 'https://www.zhipuai.cn/')),
       'published', 10, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'zhipu' AND o.slug = 'z-ai';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'zcode-guide', 'ZCode 使用说明',
       '了解 ZCode 面向的长程工程任务，以及在授权代码 Agent 前如何准备仓库和验证改动。',
       'product-guide',
'ZCode 是智谱面向长时间软件工程任务的 Agentic Development Environment。它关注的不只是补全一段代码，而是理解仓库、规划任务、修改多个文件并持续验证结果。

## 适合什么工作

适合跨文件重构、功能实现、测试补充和需要多轮定位的工程任务。一次性问答或只需要解释一段代码时，普通对话工具可能更轻量。

## 使用前准备仓库

先确认项目能够在没有 ZCode 的情况下正常构建和测试，并把当前修改提交或至少保存清晰的 Git diff。删除工作目录中的真实密钥，确认 `.env`、构建产物和依赖目录已经忽略。

## 从理解项目开始

先要求它只读说明目录结构、启动命令、测试命令和可能涉及的模块，不要立即修改。确认理解无误后，把需求拆成可验证的结果，例如新增某个接口并通过指定测试，而不是笼统要求“优化整个项目”。

## 审查执行过程

高风险命令、依赖升级、数据库迁移和大范围删除应逐项确认。完成后检查 diff、运行项目原有测试，并人工阅读关键业务代码。长程运行需要关注是否偏离最初目标，而不能只看最后一句“任务完成”。

ZCode 的安装方式、系统支持和订阅要求可能更新，具体入口应从智谱当前文档进入。',
       JSON_ARRAY(JSON_OBJECT('label', 'ZCode 文档', 'url', 'https://docs.bigmodel.cn/cn/coding-plan/tool/zcode'), JSON_OBJECT('label', 'GLM Coding Plan', 'url', 'https://docs.bigmodel.cn/cn/coding-plan/overview')),
       'published', 20, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'zhipu' AND o.slug = 'zcode';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'glm-coding-plan-guide', 'GLM Coding Plan 接入指南',
       '理解 Coding Plan 与通用 API 的区别，并使用官方助手配置受支持的编程工具。',
       'installation-guide',
'GLM Coding Plan 是供受支持的交互式编程工具使用的订阅，不等于可以任意嵌入网站的通用 API 余额。购买后还需要把套餐专用密钥和端点配置到具体工具中。

## 开始前检查

官方 Coding Tool Helper 通过 npx 运行，先确认 Node.js 和 npm：

```text
node --version
npm --version
```

然后在 Coding Plan 页面准备套餐专用密钥。不要把普通开放平台 API Key、其他厂商密钥和 Coding Plan 密钥混在一起。

## 使用官方配置助手

```text
npx @z_ai/coding-helper
```

按照向导选择自己真实使用的套餐和编程工具。配置完成后重启对应工具；如果已经全局安装助手，可以运行诊断：

```text
coding-helper doctor
```

## 用小项目验证

进入一个可以随时丢弃的测试仓库，让工具先读取项目并回答结构问题，再做一个小修改。这样可以确认模型名、端点、密钥和工具配置是否正确，而不会把首次配置风险带进重要项目。

## 计费与使用边界

Coding Plan 只用于官方列出的交互式编程工具。自建网站、批处理脚本和后端自动调用应使用智谱开放平台通用 API。套餐模型、额度、并发和价格会调整，购买及续费前应查看当前官方页面。',
       JSON_ARRAY(JSON_OBJECT('label', 'Coding Plan 概览', 'url', 'https://docs.bigmodel.cn/cn/coding-plan/overview'), JSON_OBJECT('label', '支持工具', 'url', 'https://docs.bigmodel.cn/cn/coding-plan/tool/others')),
       'published', 30, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'zhipu' AND o.slug = 'coding-plan';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'zhipu-api-guide', '智谱开放平台接入指南',
       '从模型选择、API Key 和最小调用开始，理解智谱开放平台中的模型与平台服务。',
       'api-guide',
'智谱开放平台是 GLM 模型和相关开发服务的统一入口。除了文本与多模态模型 API，还包括智能体、知识库、文件解析、模型评测和内容安全等平台能力。

## 先选择正确入口

直接聊天使用 Z.ai；在现有编程工具中使用套餐额度选择 GLM Coding Plan；让自己的程序调用模型或构建业务应用则使用开放平台。三类入口的账号权益、密钥和计费方式不能混用。

## 完成最小 API 调用

先在控制台创建 API Key，查看当前推荐模型和价格。正式系统必须由后端读取密钥，浏览器只请求自己的后端。

PowerShell 当前窗口设置密钥：

```powershell
$env:ZHIPU_API_KEY = "替换成你自己的密钥"
```

使用兼容接口发送最小请求：

```powershell
curl.exe https://open.bigmodel.cn/api/paas/v4/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer $env:ZHIPU_API_KEY" `
  --data-raw ''{"model":"glm-5.2","messages":[{"role":"user","content":"你好"}]}''
```

模型 ID、接口路径和参数可能更新，实际调用前应以官方快速开始为准。

## 从模型 API 扩展到平台能力

普通生成请求稳定后，再根据业务需要增加流式输出、工具调用、知识库或智能体。一次同时接入太多组件，会让认证、模型、检索和工作流错误难以区分。

## 上线检查

限制输入与最大输出，记录 Token、耗时、错误码和模型版本，设置费用告警。上传文件和构建知识库前确认数据权限、保存周期和企业合规要求。',
       JSON_ARRAY(JSON_OBJECT('label', '模型概览', 'url', 'https://docs.bigmodel.cn/cn/guide/start/model-overview'), JSON_OBJECT('label', '开放平台', 'url', 'https://open.bigmodel.cn/')),
       'published', 40, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'zhipu' AND o.slug = 'open-platform';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'tongyi-guide', '通义使用指南',
       '了解通义适合的个人效率场景，以及什么时候应转向 Qwen Code 或阿里云百炼。',
       'product-guide',
'通义是阿里面向个人用户的 AI 产品入口，适合问答、搜索、写作和日常效率任务。用户直接在网页或移动端使用，不需要先创建云资源或理解模型 API。

## 适合从这里开始的任务

需要快速了解主题、整理公开资料、改写文章或生成内容初稿时，可以直接使用通义。处理给定材料时要说明“只依据附件”，并要求区分材料事实、模型推断和待核对内容。

## 与百炼和 Qwen Code 的区别

通义供人直接使用；Qwen Code 在本地项目目录中读取和修改代码；阿里云百炼供程序调用模型和构建应用。不要为了在网页中问几个问题就创建 API Key，也不要把聊天网页当成后端接口。

## 提高结果质量

提供目标读者、语气、长度、结构和不能出现的内容。比较多个对象时先定义统一维度；研究实时信息时要求列出可访问来源，并检查发布日期和原文是否支持结论。

## 使用边界

不上传密码、Token、客户资料和未公开文件。模型生成的专业建议、价格和政策信息必须再次核对。需要可重复的批量处理流程时，应转向百炼 API，而不是人工复制网页结果。',
       JSON_ARRAY(JSON_OBJECT('label', '通义', 'url', 'https://www.tongyi.com/'), JSON_OBJECT('label', '阿里云百炼', 'url', 'https://www.aliyun.com/product/bailian')),
       'published', 10, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'alibaba' AND o.slug = 'tongyi';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'qwen-code-guide', 'Qwen Code 安装与认证',
       '按系统安装 Qwen Code，完成版本验证和 /auth 认证，并从只读任务开始。',
       'installation-guide',
'Qwen Code 是运行在终端中的开源代码 Agent。安装会把 `qwen` 命令放到电脑上；首次启动后还需要通过 `/auth` 选择百炼按量调用、Coding Plan 或 Token Plan。

## 开始前准备

确认终端能够访问阿里云安装资源，并准备百炼账号。不同计费方案使用的密钥、端点和额度不同，认证时必须选择自己真实购买的方案。

Windows 官方安装命令使用管理员 CMD，而不是 PowerShell：

```bat
curl -fsSL -o %TEMP%\install-qwen.bat https://qwen-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-qwen.bat && %TEMP%\install-qwen.bat --source bailian
```

macOS 或 Linux Bash：

```bash
bash -c "$(curl -fsSL https://qwen-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-qwen.sh)" -s --source bailian
```

## 验证与认证

关闭并重新打开终端：

```text
qwen --version
qwen
```

进入 Qwen Code 后输入：

```text
/auth
```

根据提示选择百炼按量服务或已购买的套餐。认证成功不代表任何模型都可用，模型列表仍受当前方案限制。

## 在项目中安全使用

先进入一个 Git 仓库，让它只读解释目录、启动命令和测试命令。允许修改后检查 diff 并运行测试。不要在用户主目录或磁盘根目录启动，也不要把 API Key、`.env` 和生成缓存提交到仓库。',
       JSON_ARRAY(JSON_OBJECT('label', 'Qwen Code 文档', 'url', 'https://help.aliyun.com/zh/model-studio/qwen-code'), JSON_OBJECT('label', '百炼认证说明', 'url', 'https://help.aliyun.com/zh/model-studio/qwen-code')),
       'published', 20, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'alibaba' AND o.slug = 'qwen-code';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'model-studio-guide', '阿里云百炼开发指南',
       '理解百炼的模型服务、API Key、区域与应用构建能力，并完成最小接入。',
       'api-guide',
'阿里云百炼是模型与应用开发平台。它不仅提供通义千问模型调用，还管理第三方模型、API Key、知识库、智能体应用、模型评测和企业权限。

## 先确认区域和计费方式

中国内地与国际站的模型、域名、价格和免费额度可能不同。先确定业务部署区域，再在对应工作空间创建 API Key。普通按量 Key、Coding Plan 专用 Key 和 Token Plan 凭证不可混用。

## 最小调用优先

在控制台选择一个当前可用模型，复制官方示例并完成一次普通非流式调用。PowerShell 可以临时设置通用百炼密钥：

```powershell
$env:DASHSCOPE_API_KEY = "替换成你自己的密钥"
```

使用 OpenAI 兼容模式的示例：

```powershell
curl.exe https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer $env:DASHSCOPE_API_KEY" `
  --data-raw ''{"model":"qwen3.7-plus","messages":[{"role":"user","content":"你好"}]}''
```

端点和模型 ID 要以当前区域的官方文档为准。

## 什么时候使用知识库或智能体

模型 API 适合直接生成；知识库负责从私有材料检索相关片段；智能体和工作流负责组合模型、工具与多个步骤。先验证单一模型调用，再逐层增加组件。

## 生产系统要补齐什么

使用 RAM 权限限制账号能力，密钥保存在服务器，设置请求超时、限流和费用告警。记录模型 ID、Token、耗时与错误码；启用搜索、代码解释器或 MCP 时还要单独核对工具费用。',
       JSON_ARRAY(JSON_OBJECT('label', '百炼产品说明', 'url', 'https://help.aliyun.com/zh/model-studio/what-is-model-studio'), JSON_OBJECT('label', '模型价格', 'url', 'https://help.aliyun.com/zh/model-studio/model-pricing')),
       'published', 30, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'alibaba' AND o.slug = 'model-studio';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'bailian-coding-plan-guide', '百炼 Coding Plan 使用说明',
       '说明套餐专用 Key、Base URL、额度与通用按量 API 的区别，避免配置错误产生额外费用。',
       'subscription-guide',
'百炼 Coding Plan 是面向交互式 AI 编程工具的固定月费套餐。它可以接入 Qwen Code、Claude Code、OpenCode、Cursor 等受支持工具，但禁止用于自建应用后端和非交互式批处理。

## 它与通用 API 的关键区别

Coding Plan 使用 `sk-sp-` 开头的专用 Key，Base URL 包含 `coding`；百炼通用按量 API 通常使用 `sk-` Key 和普通 DashScope 地址。配错通用 Key 会产生按量账单，而不是消耗套餐额度。

## 开通后的配置顺序

1. 在 Coding Plan 页面确认套餐状态和当前支持模型。
2. 复制套餐专用 API Key。
3. 根据具体工具选择 OpenAI 或 Anthropic 兼容 Base URL。
4. 在工具中选择官方明确支持的完整模型 ID。
5. 用测试项目发起一个简单任务并查看套餐用量。

## 额度不是 Token 余额

套餐通常按模型调用次数和多个周期额度限制，并不等同于可自由抵扣的 Token 金额。复杂 Agent 任务一次用户请求可能触发多次模型调用。额度用完后通常会失败，而不是自动切换到按量计费。

## 使用限制

专用 Key 仅限本人和允许的交互式工具使用，不应共享、提交到仓库或放入网站后端。套餐支持模型、价格、并发和续费规则都可能更新，购买前必须查看官方概览和 FAQ。',
       JSON_ARRAY(JSON_OBJECT('label', 'Coding Plan 概览', 'url', 'https://help.aliyun.com/zh/model-studio/coding-plan'), JSON_OBJECT('label', 'Coding Plan FAQ', 'url', 'https://help.aliyun.com/zh/model-studio/coding-plan-faq')),
       'published', 40, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'alibaba' AND o.slug = 'coding-plan';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'doubao-guide', '豆包使用指南',
       '了解豆包的直接使用场景、桌面与移动入口，以及何时应转向火山方舟。',
       'product-guide',
'豆包是面向个人用户的 AI 助手，提供网页、桌面和移动端入口，覆盖对话、搜索、内容创作和多模态任务。普通用户可以直接使用，不需要创建火山引擎云资源。

## 适合的使用场景

可以用豆包解释问题、搜索和整理公开信息、生成内容初稿、处理图片或语音相关任务。第一次使用时选择一个能够人工验证的目标，并明确资料范围与输出格式。

## 与火山方舟的区别

豆包是给人直接使用的应用；火山方舟是给开发者调用模型和构建服务的平台；AgentKit 面向企业级 Agent 的运行、工具、记忆和治理。需要程序自动调用时应进入方舟，而不是操作豆包网页。

## 多端使用时注意

桌面客户端可能需要访问本地文件、麦克风或剪贴板。只授予完成任务需要的权限，不使用的权限及时关闭。上传文件前确认内容是否允许进入第三方服务。

## 核对生成内容

实时新闻、产品价格和政策应回到原始页面。图片、音频和文字生成结果还要检查版权、事实和使用场景，不能因为输出流畅就直接公开发布。',
       JSON_ARRAY(JSON_OBJECT('label', '豆包', 'url', 'https://www.doubao.com/'), JSON_OBJECT('label', '火山引擎', 'url', 'https://www.volcengine.com/')),
       'published', 10, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'volcengine' AND o.slug = 'doubao';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'volcengine-ark-guide', '火山方舟接入指南',
       '从模型选择和推理接入开始，理解方舟中的评测、精调与生产服务。',
       'api-guide',
'火山方舟是火山引擎的大模型服务平台，提供模型推理、评测、精调和生产部署。它搭载豆包及其他模型，面向开发者和企业，而不是个人聊天产品。

## 先完成模型选择

在模型列表中确认能力类型、上下文、输入输出形式、计费单位和区域。文本、多模态、图像和视频模型的请求结构与计费方式不同，不能只比较一个“每 Token 价格”。

## 最小接入顺序

1. 开通方舟并创建具备最小权限的凭证。
2. 在控制台选择模型或创建推理接入点。
3. 从当前官方快速开始复制对应区域的 SDK 或 HTTP 示例。
4. 先完成一个非流式、小输入请求。
5. 再增加流式输出、图片、视频或工具调用。

方舟部分模型调用会涉及接入点 ID，因此不要从第三方文章复制过期地址或模型名。

## 评测和精调分别解决什么

评测用于在真实业务样本上比较模型质量、成本和延迟；精调用于让模型适应特定数据与任务。先建立可重复评测集，再决定是否精调，否则很难证明额外成本带来了提升。

## 上线要求

后端保存凭证并做限流，记录请求模型、Token、媒体规格、耗时和错误。为费用设置预算和告警；涉及企业数据时核对地域、数据保存、安全和权限策略。',
       JSON_ARRAY(JSON_OBJECT('label', '火山方舟文档', 'url', 'https://www.volcengine.com/docs/82379/1399008?lang=zh'), JSON_OBJECT('label', '火山方舟产品页', 'url', 'https://www.volcengine.com/product/ark')),
       'published', 20, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'volcengine' AND o.slug = 'ark';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'agentkit-guide', 'AgentKit 产品与落地指南',
       '理解 AgentKit 中的运行时、工具、记忆、知识库、安全和可观测能力。',
       'platform-guide',
'AgentKit 是火山引擎用于构建、部署、运行和运维企业级 Agent 的平台。它解决的不只是“调用一次模型”，而是让一个会调用工具、保存状态并持续运行的 Agent 进入生产环境。

## 主要组成

- **运行时**：为 Agent 提供托管执行环境和弹性资源。
- **工具与 MCP**：连接已有 API、数据源和外部服务。
- **记忆与知识库**：分别处理跨会话信息和可检索的业务材料。
- **身份与安全**：控制用户、Agent 和工具能够访问什么。
- **评测与可观测**：记录执行链路、Token、耗时、错误和结果质量。

## 从简单 Agent 开始

先用一个模型和一个只读工具完成明确任务，例如根据公开数据生成报告。不要一开始同时连接生产数据库、写操作和多个 Agent。能够重放任务并解释每一步之后，再增加记忆、知识库和复杂调度。

## 工具调用的风险

Agent 生成文字通常是可撤销的，但调用删除、发送、支付和修改权限等工具会产生真实影响。为工具设置最小权限、参数校验、超时和审计日志，高风险操作必须保留人工确认。

## 上线验收

准备正常、异常、恶意输入和工具失败样本，检查 Agent 是否会越权、无限循环或输出错误结论。设置最大步骤数、费用预算和失败降级；通过运行追踪定位到底是模型、工具、数据还是基础设施出错。',
       JSON_ARRAY(JSON_OBJECT('label', 'AgentKit 文档', 'url', 'https://www.volcengine.com/docs/86681?lang=zh'), JSON_OBJECT('label', 'AgentKit 产品页', 'url', 'https://www.volcengine.com/product/agentkit')),
       'published', 30, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'volcengine' AND o.slug = 'agentkit';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'wenxiaoyan-guide', '文小言使用指南',
       '了解文小言在 AI 搜索、问答和创作中的使用方式，以及如何核对搜索型回答。',
       'product-guide',
'文小言是百度面向个人用户的 AI 搜索、问答和创作入口。它适合直接完成信息检索、概念解释、材料整理和内容生成，不要求用户先进入百度智能云控制台。

## 搜索型回答怎样使用

先把问题写成可以核对的目标，例如限定时间范围、地区、数据指标和来源类型。要求回答区分事实、推断和建议，并列出支持关键结论的原始页面。

## 处理材料和创作

提供已有材料、目标读者、语气、篇幅和结构。生成摘要时要求保留重要数字与限定条件；生成文章时先确认事实框架，再修改表达，避免把流畅文字误当成可靠事实。

## 与百度千帆的区别

文小言供个人直接使用；百度千帆面向开发者和企业，提供模型 API、Agent、知识库和工具。需要批量处理、系统集成或企业权限控制时，应使用千帆。

## 隐私与核对

不要上传身份证件、账号凭证、客户资料和未公开文件。搜索结果可能遗漏、过时或引用二手来源，重要决策必须进入原网页检查发布日期、上下文和完整条件。',
       JSON_ARRAY(JSON_OBJECT('label', '文小言', 'url', 'https://yiyan.baidu.com/'), JSON_OBJECT('label', '百度智能云', 'url', 'https://cloud.baidu.com/')),
       'published', 10, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'baidu' AND o.slug = 'wenxiaoyan';

INSERT INTO articles (provider_id, offering_id, slug, title, summary, article_type, content_markdown, source_links, status, sort_order, published_at, verified_at)
SELECT p.id, o.id, 'qianfan-guide', '百度千帆开发指南',
       '理解千帆中的模型服务、Agent、知识库、工具与企业能力，并按正确顺序开始。',
       'platform-guide',
'百度千帆是面向开发者和企业的大模型服务及 Agent 开发平台。它围绕模型服务、Agent 引擎、工具与 MCP、知识库和企业级治理组织能力。

## 先确定要解决的问题

只需要程序生成文本或理解图片时，从模型 API 开始；需要使用企业材料回答问题时增加知识库；需要模型连续规划并调用业务系统时，再进入 Agent 开发。不要因为平台功能多就一次全部启用。

## 最小接入路径

1. 开通千帆并确认账号与项目区域。
2. 创建最小权限的访问凭证。
3. 从模型列表选择一个与输入形式匹配的模型。
4. 使用当前官方 API 或 SDK 示例完成最小请求。
5. 记录模型 ID、输入输出 Token、耗时和错误。

不同模型、区域和服务可能使用不同调用方式，端点和鉴权代码应从当前官方文档复制，而不是沿用旧教程。

## 构建 Agent 时的职责划分

模型负责理解与生成，知识库负责检索企业材料，工具负责执行外部动作，Agent 负责规划和组合步骤。每一层都应该能够独立测试，否则错误出现时无法判断是检索、模型还是工具造成的。

## 费用与生产治理

模型、搜索增强、知识库解析、工具和部署资源可能分别计费。上线前设置预算、限流和告警，使用企业权限体系控制凭证。准备评测集检查回答依据、工具越权、恶意输入和失败降级，并保留完整调用日志。',
       JSON_ARRAY(JSON_OBJECT('label', '百度千帆文档', 'url', 'https://cloud.baidu.com/doc/Qianfan/index.html'), JSON_OBJECT('label', '模型服务计费', 'url', 'https://cloud.baidu.com/doc/qianfan/s/wmh4sv6ya')),
       'published', 20, CURRENT_TIMESTAMP, '2026-07-12'
FROM providers p JOIN offerings o ON o.provider_id = p.id
WHERE p.slug = 'baidu' AND o.slug = 'qianfan';
