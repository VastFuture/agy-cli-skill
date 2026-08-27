---
name: agy-cli
description: 编排 Google Antigravity CLI (agy) 进行并行任务执行、多模型路由和智能上下文注入。当将编码任务委托给 Antigravity、运行多代理工作流或通过 agy 使用 Gemini/Claude/GPT 模型时使用。
---

# Antigravity CLI 编排器

**角色定位**：Claude Code 是编排者，Antigravity (agy) 是执行者。

**核心价值**：通过智能编排，让 agy 更快、更准、更省 token。

---

## 快速决策流程

```
收到任务
    │
    ├─ 1. 能否预注入上下文？ ──→ 是 → 收集代码/错误，注入到 prompt
    │
    ├─ 2. 与已有对话相关？ ────→ 是 → 复用对话 (--continue)
    │
    ├─ 3. 可拆分为独立子任务？ → 是 → 并行执行
    │
    ├─ 4. 需要特定模型？ ──────→ 是 → 通过 --model 路由到 Gemini/Claude/GPT
    │
    └─ 5. 以上都否 ───────────→ 新建单会话串行执行
```

---

## 三大优化策略

### 策略 1: 上下文预注入（最重要）

**原理**：Claude Code 先收集相关信息，注入 prompt，让 agy 跳过探索。

| 注入内容 | 命令示例 |
|----------|----------|
| 文件路径 | `agy -p "Fix bug in: src/auth/login.ts, src/utils/token.ts"` |
| 错误信息 | `agy -p "Fix: $(npm run build 2>&1 \| grep error)"` |
| 代码片段 | `agy -p "Optimize: $(cat src/slow.ts)"` |
| 依赖关系 | `agy -p "Refactor A, deps: B→C→D"` |

**模板**：
```bash
agy -p "[任务]

## 文件: $FILES
## 错误: $ERRORS
## 代码:
\`\`\`
$CODE
\`\`\`

约束: 只修改上述文件，直接开始。"
```

### 策略 2: 对话复用

**原理**：关联任务复用已有对话，继承上下文，避免重复分析。

```bash
# 首次执行
agy -p "analyze src/auth for issues"

# 继续对话
agy -c "fix the issues you found"

# 或使用 --conversation 通过 ID 恢复特定对话
agy --conversation <conversation-id> "continue working"
```

**何时复用**：
- 分析后修复 → 复用（知道发现了什么）
- 实现后测试 → 复用（知道实现了什么）
- 测试后修复 → 复用（知道哪里失败）

### 策略 3: 并行执行

**原理**：隔离良好的任务同时执行，节省总时间。

**可并行**：
- 不同目录/模块
- 不同分析维度（安全/性能/质量）
- 只读操作

**需串行**：
- 写同一文件
- 依赖前序结果

```bash
# 并行执行
agy -p "analyze auth for security issues" > auth.txt 2>&1 &
agy -p "analyze api for performance issues" > api.txt 2>&1 &
wait

# 并行使用不同模型
agy --model gemini-3.7-flash-high -p "quick lint check" &
agy --model claude-opus-4-6-thinking -p "deep architecture review" &
wait
```

---

## 多模型路由策略

### 可用模型

| 模型系列 | 模型 ID | 使用场景 |
|----------|---------|----------|
| **Gemini Flash** | `gemini-3.7-flash-high/medium/low` | 快速迭代、代码检查、简单修复 |
| **Gemini Pro** | `gemini-3.1-pro-high/low` | 复杂推理、架构设计 |
| **Claude** | `claude-sonnet-4-6`, `claude-opus-4-6-thinking` | 深度思考、代码审查、重构 |
| **GPT-OSS** | `gpt-oss-120b-medium` | 替代视角、对比分析 |

### 路由决策树

```
任务分析
    │
    ├─ 简单快速（lint、格式化、快速修复）→ Gemini Flash Low
    ├─ 标准编码（实现、测试）→ Gemini Flash High
    ├─ 复杂推理（架构、设计）→ Gemini Pro High
    ├─ 深度思考（安全、重构）→ Claude Opus Thinking
    └─ 对比/替代观点 → GPT-OSS
```

### 多模型并行模式

```bash
# 不同模型处理不同维度
agy --model gemini-3.7-flash-high -p "check lint errors" > lint.txt &
agy --model claude-opus-4-6-thinking -p "review security" > security.txt &
agy --model gemini-3.1-pro-high -p "analyze architecture" > arch.txt &
wait

# 聚合结果
cat lint.txt security.txt arch.txt > full-review.txt
```

---

## 推理深度控制

通过 `--effort` 标志控制推理深度：

```bash
agy --effort low -p "quick syntax check"      # 快速、浅层
agy --effort medium -p "implement feature"    # 平衡（默认）
agy --effort high -p "architecture review"    # 深度、全面
```

**按深度路由**：
- `low` → 快速检查、格式化、简单修复
- `medium` → 标准实现、测试
- `high` → 复杂设计、安全审计、重构

---

## Prompt 设计要点

### 结构公式

```
[动词] + [范围] + [要求] + [输出格式] + [约束]
```

### 动词选择

| 只读 | 写入 |
|------|------|
| analyze, review, find, explain | fix, refactor, implement, add |

### 好 vs 差

| 差 | 好 |
|-----|-----|
| `review code` | `review src/auth for SQL injection, XSS. Output: markdown, severity levels.` |
| `find bugs` | `find bugs in src/utils. Output: file:line, description, fix suggestion.` |
| `improve code` | `refactor Button.tsx to hooks. Preserve props. Don't modify others.` |

### 并行时保持一致

```bash
# 结构一致，输出格式统一，便于聚合
agy -p "analyze src/auth for security. Output JSON." > auth.json &
agy -p "analyze src/api for security. Output JSON." > api.json &
agy -p "analyze src/db for security. Output JSON." > db.json &
wait
```

---

## 执行模式

### 计划模式

```bash
agy --mode plan -p "implement user authentication"
# 生成详细计划但不执行
```

### 接受编辑模式（默认）

```bash
agy --mode accept-edits -p "fix linting errors"
# 交互模式，编辑前询问权限
```

### 非交互打印模式

```bash
agy -p "analyze codebase structure"
# 单次 prompt，打印响应后退出
```

### 危险跳过权限（谨慎使用）

```bash
agy --dangerously-skip-permissions -p "auto-fix all lint errors"
# 自动批准所有操作，无提示
```

---

## 综合示例

### 示例 1: 全流程优化（预注入 + 并行 + 多模型）

```bash
# Phase 1: Claude Code 收集信息
ERRORS=$(npm run lint 2>&1)
AUTH_ERR=$(echo "$ERRORS" | grep "src/auth")
API_ERR=$(echo "$ERRORS" | grep "src/api")

# Phase 2: 并行执行，预注入各自错误，使用不同模型
agy --model gemini-3.7-flash-high -p "Fix lint errors:
$AUTH_ERR
Only modify src/auth/" > auth.txt 2>&1 &

agy --model gemini-3.7-flash-high -p "Fix lint errors:
$API_ERR
Only modify src/api/" > api.txt 2>&1 &
wait

# Phase 3: 用 Claude 做深度审查
agy --model claude-opus-4-6-thinking -p "Review fixes in src/auth and src/api, check for edge cases"
```

### 示例 2: 迭代开发（单对话多轮复用）

```bash
# Round 1: 分析
agy -p "analyze codebase, plan auth implementation"

# Round 2-4: 继续同一对话，继承全部上下文
agy -c "implement as planned"
agy -c "add tests for auth"
agy -c "fix test failures"
```

### 示例 3: 代码审查（4 路并行 → 各自修复）

```bash
# 并行审查，使用不同模型
agy --model gemini-3.7-flash-high -p "audit security issues" > sec.txt &
agy --model gemini-3.1-pro-high -p "audit performance bottlenecks" > perf.txt &
agy --model claude-sonnet-4-6 -p "audit code quality" > qual.txt &
agy --model gemini-3.7-flash-medium -p "audit best practices" > prac.txt &
wait

# 根据发现串行修复（每个新会话）
agy -p "Fix security issues found: $(cat sec.txt)"
agy -p "Optimize performance: $(cat perf.txt)"
# ...
```

### 示例 4: 多模型共识

```bash
# 同一任务，不同模型对比
agy --model gemini-3.1-pro-high -p "design API for user management" > design-gemini.txt &
agy --model claude-opus-4-6-thinking -p "design API for user management" > design-claude.txt &
wait

# Claude Code 综合最佳方案
GEMINI=$(cat design-gemini.txt)
CLAUDE=$(cat design-claude.txt)

agy -p "Compare these two API designs and recommend the best:

Gemini's design:
$GEMINI

Claude's design:
$CLAUDE

Provide synthesis with rationale."
```

---

## 命令速查表

### 基础命令

```bash
agy                                              # 交互式 TUI 模式
agy -p "prompt"                                  # 打印模式（非交互）
agy -i "prompt"                                  # Prompt 后进入交互
agy -c                                           # 继续最近对话
agy --conversation <id>                          # 恢复特定对话
agy --model <model-id> -p "prompt"              # 使用特定模型
agy --effort high -p "prompt"                    # 高推理深度
agy --mode plan -p "prompt"                      # 计划模式
agy --add-dir /path/to/dir -p "prompt"          # 添加目录到工作区
agy --new-project -p "prompt"                    # 创建新项目
```

### 并行执行

```bash
agy -p "task1" > out1.txt 2>&1 &
agy -p "task2" > out2.txt 2>&1 &
wait
```

### 子命令

```bash
agy models                                       # 列出可用模型
agy agents                                       # 列出可用代理
agy changelog                                    # 显示更新日志
agy update                                       # 更新 CLI
agy mcp list                                     # 列出 MCP 服务器
agy plugin list                                  # 列出插件
```

---

## 高级特性

### JSON 输出模式

```bash
agy --output-format json -p "analyze structure" > output.json
agy --output-format stream-json -p "task" > output.jsonl
```

### JSON Schema 约束

```bash
agy --json-schema '{"type":"object","properties":{"issues":{"type":"array"}}}' -p "find issues"
```

### 工作区管理

```bash
# 添加多个目录
agy --add-dir ./src --add-dir ./tests -p "analyze both"

# 创建新项目上下文
agy --new-project -p "start new feature"
```

### 沙盒模式

```bash
agy --sandbox -p "experimental changes"
# 启用终端限制运行
```

---

## 集成模式

### 与 CI/CD 集成

```bash
#!/bin/bash
# ci-review.sh

# 用 Gemini Flash 快速 lint
agy --model gemini-3.7-flash-low --print-timeout 2m -p "lint check, fail on errors" || exit 1

# 用 Claude 深度安全审计
agy --model claude-opus-4-6-thinking --print-timeout 5m -p "security audit, output: severity + recommendations"
```

### 与 Git Hooks 集成

```bash
# pre-commit hook
#!/bin/bash
STAGED=$(git diff --cached --name-only)
agy --model gemini-3.7-flash-high -p "review staged files: $STAGED, check: style, types, logic"
```

### 与测试工作流集成

```bash
# 运行测试 → 分析失败 → 修复
TEST_OUTPUT=$(npm test 2>&1)
if [ $? -ne 0 ]; then
  agy -p "Test failures:
  $TEST_OUTPUT
  
  Analyze root cause and fix."
fi
```

---

## 最佳实践

### 1. 模型选择
- **标准任务默认用 Gemini Flash High**
- **复杂推理用 Claude Opus Thinking**
- **快速检查用 Gemini Flash Low**
- **关键决策并行多模型** 达成共识

### 2. 上下文管理
- **知道需要改什么时预注入文件路径**
- **相关后续任务复用对话**
- **无关任务新建会话**

### 3. 并行执行
- **按模块/目录隔离** 避免冲突
- **使用一致的输出格式** 便于聚合
- **监控资源** - 不要生成太多并行 agy 实例

### 4. 错误处理
- **需要时分别捕获 stdout 和 stderr**
- **检查退出码** 用于 CI/CD 集成
- **使用 --print-timeout** 避免自动化脚本挂起

### 5. Prompt 清晰度
- **明确文件、范围和约束**
- **请求结构化输出**（JSON、markdown 表格）
- **显式说明成功标准**

---

## 安全注意事项

⚠️ **警告**：AI 编码代理存在已知安全风险：
- 自主代码执行
- 数据泄露
- Prompt 注入
- 供应链风险

**缓解措施**：
1. **提交前审查所有更改**
2. **生产环境绝不使用** `--dangerously-skip-permissions`
3. **用 `--sandbox` 标志沙盒化不可信任务**
4. **在审计日志中监控 agy 操作**
5. **用 `--add-dir` 限制工作区范围**

---

## 故障排除

### agy 挂起或超时
```bash
# 使用更短的超时
agy --print-timeout 2m -p "quick task"
```

### 上下文过大
```bash
# 减少工作区范围
agy --add-dir ./src/auth -p "task"
# 而不是包含整个仓库
```

### 模型不可用
```bash
# 列出可用模型
agy models
# 使用备用模型
agy --model gemini-3.7-flash-high -p "task"
```

### 对话丢失
```bash
# 列出最近对话（CLI 中不可用，检查 ~/.antigravity/）
# 或用上下文注入重新开始
agy -p "Context: [previous work summary]
Continue with: [next step]"
```

---

## 参考链接

- **官方文档**: [antigravity.google/docs/cli/overview](https://antigravity.google/docs/cli/overview)
- **服务条款**: [antigravity.google/terms](https://antigravity.google/terms)
- **隐私政策**: [policies.google.com/privacy](https://policies.google.com/privacy)

---

## 快速入门检查清单

- [ ] 安装: `curl -fsSL https://antigravity.google/cli/install.sh | bash`
- [ ] 认证: `agy`（首次运行）
- [ ] 测试: `agy -p "echo hello"`
- [ ] 检查模型: `agy models`
- [ ] 尝试并行: `agy -p "task1" & agy -p "task2" & wait`
- [ ] 尝试多模型: `agy --model gemini-3.7-flash-high -p "task"`
- [ ] 尝试复用: `agy -p "analyze code"` 然后 `agy -c "fix issues"`

准备好编排了！🚀
