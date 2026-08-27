# agy-cli-skill

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/VastFuture/agy-cli-skill.svg)](https://github.com/VastFuture/agy-cli-skill/releases)
[![GitHub stars](https://img.shields.io/github/stars/VastFuture/agy-cli-skill.svg)](https://github.com/VastFuture/agy-cli-skill/stargazers)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/VastFuture/agy-cli-skill/pulls)

Orchestrate Google Antigravity CLI (agy) for parallel task execution, multi-model routing, and intelligent context injection.

**Claude Code** acts as orchestrator, **Antigravity** (agy) acts as executor. Through intelligent orchestration, make agy faster, more accurate, and more token-efficient.

---

## ✨ Features

- **🎯 Context Pre-Injection**: Claude Code collects context before delegating to agy
- **🔄 Conversation Resume**: Continue related work to preserve context across rounds
- **⚡ Parallel Execution**: Run multiple agy instances for independent tasks
- **🤖 Multi-Model Routing**: Route tasks to optimal models (Gemini/Claude/GPT-OSS)
- **⚙️ Effort Control**: Adjust reasoning depth (low/medium/high)
- **📋 Multiple Execution Modes**: Plan, interactive, and non-interactive

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/VastFuture/agy-cli-skill/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/VastFuture/agy-cli-skill.git ~/.agents/skills/agy-cli-skill
```

## 📋 Prerequisites

### 1. Install Antigravity CLI

**macOS / Linux**:
```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

**Windows PowerShell**:
```powershell
irm https://antigravity.google/cli/install.ps1 | iex
```

### 2. Authenticate

```bash
agy
# Follow the authentication flow
```

### 3. Verify

```bash
agy models  # List available models
agy -p "echo hello"  # Test basic functionality
```

## 🎯 Quick Examples

### Single Task
```bash
agy -p "analyze src/auth for security issues"
```

### Parallel Tasks
```bash
agy -p "check lint errors" > lint.txt &
agy -p "review security" > security.txt &
wait
```

### Multi-Model Routing
```bash
# Fast check with Gemini Flash
agy --model gemini-3.7-flash-low -p "quick syntax check"

# Deep review with Claude Opus
agy --model claude-opus-4-6-thinking -p "architecture review"
```

### Resume Conversation
```bash
agy -p "analyze codebase"
agy -c "fix the issues you found"
```

## 🤖 Supported Models

| Model Family | Model ID | Use Case |
|--------------|----------|----------|
| **Gemini Flash** | `gemini-3.7-flash-high/medium/low` | Fast iteration, lint, simple fixes |
| **Gemini Pro** | `gemini-3.1-pro-high/low` | Complex reasoning, architecture design |
| **Claude** | `claude-sonnet-4-6`, `claude-opus-4-6-thinking` | Deep thinking, code review, refactoring |
| **GPT-OSS** | `gpt-oss-120b-medium` | Alternative perspective, comparison |

## 📚 Documentation

- **English Guide**: [SKILL.md](./SKILL.md)
- **中文指南**: [SKILL_zh_CN.md](./SKILL_zh_CN.md)
- **Examples**: [examples/README.md](./examples/README.md)
- **Contributing**: [CONTRIBUTING.md](./CONTRIBUTING.md)

## 🎓 Practical Examples

### 1. Parallel Code Review

Multi-dimensional review using 4 models in parallel:

```bash
cd ~/.agents/skills/agy-cli-skill/examples
./parallel-review.sh
```

**What it does**:
- Security audit (Gemini Flash High)
- Performance audit (Gemini Pro High)
- Quality audit (Claude Sonnet)
- Best practices audit (Gemini Flash Medium)
- Aggregates results and generates executive summary (Claude Opus)

### 2. Iterative Development

5-round workflow with conversation resume:

```bash
./iterative-development.sh
```

**Workflow**:
1. Analysis and planning
2. Implementation
3. Add comprehensive tests
4. Fix test failures (if any)
5. Add documentation

### 3. Multi-Model Consensus

Critical decisions with multiple AI perspectives:

```bash
./multi-model-consensus.sh
```

**Process**:
1. Get designs from 3 models (Gemini/Claude/GPT)
2. Cross-analyze strengths and weaknesses
3. Synthesize best recommendation
4. Validate for fatal flaws

## 🔑 Core Strategies

### Strategy 1: Context Pre-Injection

Claude Code collects context before delegating:

```bash
# Collect errors first
ERRORS=$(npm run build 2>&1 | grep error)

# Inject into agy prompt
agy -p "Fix these build errors:
$ERRORS
Only modify relevant files."
```

### Strategy 2: Conversation Resume

Preserve context across rounds:

```bash
agy -p "analyze code"      # Round 1
agy -c "fix issues"        # Round 2 (continues conversation)
agy -c "add tests"         # Round 3 (continues same conversation)
```

### Strategy 3: Parallel Execution

Run independent tasks simultaneously:

```bash
agy --model gemini-3.7-flash-high -p "audit security" > sec.txt &
agy --model gemini-3.1-pro-high -p "audit performance" > perf.txt &
wait
```

## 🛠️ Integration Examples

### CI/CD Pipeline

```bash
#!/bin/bash
# Quick lint
agy --model gemini-3.7-flash-low --print-timeout 2m \
  -p "lint check, fail on errors" || exit 1

# Security audit
agy --model claude-opus-4-6-thinking --print-timeout 5m \
  -p "security audit with severity levels"
```

### Git Pre-Commit Hook

```bash
#!/bin/bash
STAGED=$(git diff --cached --name-only)
agy --model gemini-3.7-flash-high \
  -p "Review staged files: $STAGED. Check: style, types, logic"
```

### Test-Fix Loop

```bash
#!/bin/bash
TEST_OUTPUT=$(npm test 2>&1)
if [ $? -ne 0 ]; then
  agy -p "Test failures: $TEST_OUTPUT. Analyze and fix."
fi
```

## 🎯 Model Selection Guide

| Task Type | Recommended Model | Reasoning |
|-----------|-------------------|-----------|
| Lint/Format | `gemini-3.7-flash-low` | Fast, simple checks |
| Standard Coding | `gemini-3.7-flash-high` | Balanced speed/quality |
| Architecture Design | `gemini-3.1-pro-high` | Complex reasoning |
| Deep Refactoring | `claude-opus-4-6-thinking` | Deep thinking mode |
| Code Review | `claude-sonnet-4-6` | Thorough analysis |
| Alternative View | `gpt-oss-120b-medium` | Different perspective |

## 🔒 Security

⚠️ **Important Safety Guidelines**:

- ✅ **Always review** agy's changes before committing
- ❌ **Never use** `--dangerously-skip-permissions` in production
- 🔒 **Sandbox untrusted tasks** with `--sandbox` flag
- 📁 **Limit workspace scope** with `--add-dir` to specific directories
- 📊 **Monitor agy actions** in logs and audit trails

## 📖 Command Reference

```bash
# Basic
agy                                    # Interactive TUI
agy -p "prompt"                        # Non-interactive print
agy -c                                 # Continue last conversation
agy --model <model-id> -p "prompt"    # Use specific model

# Parallel
agy -p "task1" > out1.txt &
agy -p "task2" > out2.txt &
wait

# Advanced
agy --effort high -p "prompt"          # High reasoning depth
agy --mode plan -p "prompt"            # Plan mode only
agy --add-dir /path -p "prompt"        # Scope to directory
agy --json-schema '{}' -p "prompt"     # Enforce JSON schema
```

## 🤝 Contributing

Contributions welcome! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## 📝 License

MIT License - see [LICENSE](./LICENSE) for details.

## 🔗 Related Skills

- [qwen-cli-skill](https://github.com/VastFuture/qwen-cli-skill) - Qwen CLI orchestration
- [vast-codex-cli](https://github.com/VastFuture/vast-codex-cli) - OpenAI Codex CLI orchestration
- [vast-gemini-cli](https://github.com/VastFuture/vast-gemini-cli) - Gemini CLI orchestration

## 📮 Support

- **Issues**: [GitHub Issues](https://github.com/VastFuture/agy-cli-skill/issues)
- **Discussions**: [GitHub Discussions](https://github.com/VastFuture/agy-cli-skill/discussions)
- **Official Antigravity Docs**: [antigravity.google/docs/cli](https://antigravity.google/docs/cli/overview)

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=VastFuture/agy-cli-skill&type=Date)](https://star-history.com/#VastFuture/agy-cli-skill&Date)

---

Made with ❤️ for the Claude Code community
