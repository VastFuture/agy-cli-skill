---
name: agy-cli
description: Orchestrate Google Antigravity CLI (agy) for parallel task execution, multi-model routing, and intelligent context injection. Use when delegating coding tasks to Antigravity, running multi-agent workflows, or leveraging Gemini/Claude/GPT models via agy. 当需要调度 Antigravity CLI、多模型协作、或通过 agy 执行编码任务时使用。
---

# Antigravity CLI Orchestrator

**Role**: Claude Code is the orchestrator, Antigravity (agy) is the executor.

**Core Value**: Through intelligent orchestration, make agy faster, more accurate, and more token-efficient.

---

## Quick Decision Flow

```
Receive Task
    │
    ├─ 1. Can pre-inject context? ──→ Yes → Collect code/errors, inject into prompt
    │
    ├─ 2. Related to existing conversation? ──→ Yes → Resume conversation (--continue)
    │
    ├─ 3. Can split into independent subtasks? → Yes → Execute in parallel
    │
    ├─ 4. Need specific model? ──→ Yes → Route to Gemini/Claude/GPT via --model
    │
    └─ 5. All above are No ───────────→ Create new single session
```

---

## Three Core Optimization Strategies

### Strategy 1: Context Pre-Injection (Most Important)

**Principle**: Claude Code collects relevant information first, injects into prompt, lets agy skip exploration.

| Inject Content | Command Example |
|----------------|-----------------|
| File paths | `agy -p "Fix bug in: src/auth/login.ts, src/utils/token.ts"` |
| Error messages | `agy -p "Fix: $(npm run build 2>&1 \| grep error)"` |
| Code snippets | `agy -p "Optimize: $(cat src/slow.ts)"` |
| Dependencies | `agy -p "Refactor A, deps: B→C→D"` |

**Template**:
```bash
agy -p "[Task]

## Files: $FILES
## Errors: $ERRORS
## Code:
\`\`\`
$CODE
\`\`\`

Constraints: Only modify above files, start directly."
```

### Strategy 2: Conversation Resume

**Principle**: Resume related tasks to inherit context, avoid repeated analysis.

```bash
# First execution
agy -p "analyze src/auth for issues"

# Continue the conversation
agy -c "fix the issues you found"

# Or use --conversation to resume specific conversation by ID
agy --conversation <conversation-id> "continue working"
```

**When to Resume**:
- After analysis → resume for fix (knows what was found)
- After implementation → resume for test (knows what was implemented)
- After test failure → resume for fix (knows what failed)

### Strategy 3: Parallel Execution

**Principle**: Execute well-isolated tasks simultaneously to save total time.

**Parallelizable**:
- Different directories/modules
- Different analysis dimensions (security/performance/quality)
- Read-only operations

**Must be Sequential**:
- Writing same file
- Depends on prior results

```bash
# Parallel execution
agy -p "analyze auth for security issues" > auth.txt 2>&1 &
agy -p "analyze api for performance issues" > api.txt 2>&1 &
wait

# Parallel with different models
agy --model gemini-3.7-flash-high -p "quick lint check" &
agy --model claude-opus-4-6-thinking -p "deep architecture review" &
wait
```

---

## Multi-Model Routing Strategy

### Available Models

| Model Family | Model ID | Use Case |
|--------------|----------|----------|
| **Gemini Flash** | `gemini-3.7-flash-high/medium/low` | Fast iteration, linting, simple fixes |
| **Gemini Pro** | `gemini-3.1-pro-high/low` | Complex reasoning, architecture design |
| **Claude** | `claude-sonnet-4-6`, `claude-opus-4-6-thinking` | Deep thinking, code review, refactoring |
| **GPT-OSS** | `gpt-oss-120b-medium` | Alternative perspective, comparison |

### Routing Decision Tree

```
Task Analysis
    │
    ├─ Simple & Fast (lint, format, quick fix) → Gemini Flash Low
    ├─ Standard coding (implement, test) → Gemini Flash High
    ├─ Complex reasoning (architecture, design) → Gemini Pro High
    ├─ Deep thinking (security, refactor) → Claude Opus Thinking
    └─ Comparison/Alternative view → GPT-OSS
```

### Multi-Model Parallel Pattern

```bash
# Different models for different dimensions
agy --model gemini-3.7-flash-high -p "check lint errors" > lint.txt &
agy --model claude-opus-4-6-thinking -p "review security" > security.txt &
agy --model gemini-3.1-pro-high -p "analyze architecture" > arch.txt &
wait

# Aggregate results
cat lint.txt security.txt arch.txt > full-review.txt
```

---

## Effort Level Control

Control reasoning depth via `--effort` flag:

```bash
agy --effort low -p "quick syntax check"      # Fast, shallow
agy --effort medium -p "implement feature"    # Balanced (default)
agy --effort high -p "architecture review"    # Deep, thorough
```

**Routing by Effort**:
- `low` → Quick checks, formatting, simple fixes
- `medium` → Standard implementation, testing
- `high` → Complex design, security audit, refactoring

---

## Prompt Design Principles

### Structure Formula

```
[Verb] + [Scope] + [Requirements] + [Output Format] + [Constraints]
```

### Verb Selection

| Read-only | Write |
|-----------|-------|
| analyze, review, find, explain | fix, refactor, implement, add |

### Good vs Bad

| Bad | Good |
|-----|------|
| `review code` | `review src/auth for SQL injection, XSS. Output: markdown, severity levels.` |
| `find bugs` | `find bugs in src/utils. Output: file:line, description, fix suggestion.` |
| `improve code` | `refactor Button.tsx to hooks. Preserve props. Don't modify others.` |

### Parallel Consistency

```bash
# Keep structure consistent, output format unified for aggregation
agy -p "analyze src/auth for security. Output JSON." > auth.json &
agy -p "analyze src/api for security. Output JSON." > api.json &
agy -p "analyze src/db for security. Output JSON." > db.json &
wait
```

---

## Execution Modes

### Plan Mode

```bash
agy --mode plan -p "implement user authentication"
# Generates detailed plan without executing
```

### Accept-Edits Mode (Default)

```bash
agy --mode accept-edits -p "fix linting errors"
# Interactive mode, asks for permission before edits
```

### Non-Interactive Print Mode

```bash
agy -p "analyze codebase structure"
# Single prompt, prints response, exits
```

### Dangerous Skip Permissions (Use with Caution)

```bash
agy --dangerously-skip-permissions -p "auto-fix all lint errors"
# Auto-approves all actions, no prompts
```

---

## Comprehensive Examples

### Example 1: Full Workflow Optimization (Pre-inject + Parallel + Multi-Model)

```bash
# Phase 1: Claude Code collects information
ERRORS=$(npm run lint 2>&1)
AUTH_ERR=$(echo "$ERRORS" | grep "src/auth")
API_ERR=$(echo "$ERRORS" | grep "src/api")

# Phase 2: Parallel execution with pre-injected errors, different models
agy --model gemini-3.7-flash-high -p "Fix lint errors:
$AUTH_ERR
Only modify src/auth/" > auth.txt 2>&1 &

agy --model gemini-3.7-flash-high -p "Fix lint errors:
$API_ERR
Only modify src/api/" > api.txt 2>&1 &
wait

# Phase 3: Deep review with Claude
agy --model claude-opus-4-6-thinking -p "Review fixes in src/auth and src/api, check for edge cases"
```

### Example 2: Iterative Development (Single Conversation Multi-Round)

```bash
# Round 1: Analysis
agy -p "analyze codebase, plan auth implementation"

# Round 2-4: Continue same conversation, inherit all context
agy -c "implement as planned"
agy -c "add tests for auth"
agy -c "fix test failures"
```

### Example 3: Code Review (4-Way Parallel → Resume Each for Fix)

```bash
# Parallel review with different models
agy --model gemini-3.7-flash-high -p "audit security issues" > sec.txt &
agy --model gemini-3.1-pro-high -p "audit performance bottlenecks" > perf.txt &
agy --model claude-sonnet-4-6 -p "audit code quality" > qual.txt &
agy --model gemini-3.7-flash-medium -p "audit best practices" > prac.txt &
wait

# Sequential fix based on findings (each in new session)
agy -p "Fix security issues found: $(cat sec.txt)"
agy -p "Optimize performance: $(cat perf.txt)"
# ...
```

### Example 4: Multi-Model Consensus

```bash
# Same task, different models for comparison
agy --model gemini-3.1-pro-high -p "design API for user management" > design-gemini.txt &
agy --model claude-opus-4-6-thinking -p "design API for user management" > design-claude.txt &
wait

# Claude Code synthesizes the best approach
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

## Command Quick Reference

### Basic Commands

```bash
agy                                              # Interactive TUI mode
agy -p "prompt"                                  # Print mode (non-interactive)
agy -i "prompt"                                  # Prompt then enter interactive
agy -c                                           # Continue last conversation
agy --conversation <id>                          # Resume specific conversation
agy --model <model-id> -p "prompt"              # Use specific model
agy --effort high -p "prompt"                    # High reasoning effort
agy --mode plan -p "prompt"                      # Plan mode
agy --add-dir /path/to/dir -p "prompt"          # Add directory to workspace
agy --new-project -p "prompt"                    # Create new project
```

### Parallel Execution

```bash
agy -p "task1" > out1.txt 2>&1 &
agy -p "task2" > out2.txt 2>&1 &
wait
```

### Subcommands

```bash
agy models                                       # List available models
agy agents                                       # List available agents
agy changelog                                    # Show changelog
agy update                                       # Update CLI
agy mcp list                                     # List MCP servers
agy plugin list                                  # List plugins
```

---

## Advanced Features

### JSON Output Mode

```bash
agy --output-format json -p "analyze structure" > output.json
agy --output-format stream-json -p "task" > output.jsonl
```

### JSON Schema Enforcement

```bash
agy --json-schema '{"type":"object","properties":{"issues":{"type":"array"}}}' -p "find issues"
```

### Workspace Management

```bash
# Add multiple directories
agy --add-dir ./src --add-dir ./tests -p "analyze both"

# Create new project context
agy --new-project -p "start new feature"
```

### Sandbox Mode

```bash
agy --sandbox -p "experimental changes"
# Runs with terminal restrictions enabled
```

---

## Integration Patterns

### With CI/CD

```bash
#!/bin/bash
# ci-review.sh

# Quick lint with Gemini Flash
agy --model gemini-3.7-flash-low --print-timeout 2m -p "lint check, fail on errors" || exit 1

# Deep security audit with Claude
agy --model claude-opus-4-6-thinking --print-timeout 5m -p "security audit, output: severity + recommendations"
```

### With Git Hooks

```bash
# pre-commit hook
#!/bin/bash
STAGED=$(git diff --cached --name-only)
agy --model gemini-3.7-flash-high -p "review staged files: $STAGED, check: style, types, logic"
```

### With Testing Workflows

```bash
# Run tests → analyze failures → fix
TEST_OUTPUT=$(npm test 2>&1)
if [ $? -ne 0 ]; then
  agy -p "Test failures:
  $TEST_OUTPUT
  
  Analyze root cause and fix."
fi
```

---

## Best Practices

### 1. Model Selection
- **Default to Gemini Flash High** for standard tasks
- **Use Claude Opus Thinking** for complex reasoning
- **Use Gemini Flash Low** for quick checks
- **Parallel different models** for consensus on critical decisions

### 2. Context Management
- **Pre-inject file paths** when you know what needs work
- **Resume conversations** for related follow-ups
- **Start fresh sessions** for unrelated tasks

### 3. Parallel Execution
- **Isolate by module/directory** to avoid conflicts
- **Use consistent output formats** for easy aggregation
- **Monitor resources** - don't spawn too many parallel agy instances

### 4. Error Handling
- **Capture stdout and stderr** separately when needed
- **Check exit codes** for CI/CD integration
- **Use --print-timeout** to avoid hanging in automated scripts

### 5. Prompt Clarity
- **Be specific** about files, scope, and constraints
- **Request structured output** (JSON, markdown tables)
- **State success criteria** explicitly

---

## Security Considerations

⚠️ **Warning**: AI coding agents have known security risks:
- Autonomous code execution
- Data exfiltration
- Prompt injection
- Supply chain risks

**Mitigations**:
1. **Review all changes** before committing
2. **Never use** `--dangerously-skip-permissions` in production
3. **Sandbox untrusted tasks** with `--sandbox` flag
4. **Monitor agy actions** in audit logs
5. **Limit workspace scope** with `--add-dir`

---

## Troubleshooting

### agy hangs or times out
```bash
# Use shorter timeout
agy --print-timeout 2m -p "quick task"
```

### Context too large
```bash
# Reduce workspace scope
agy --add-dir ./src/auth -p "task"
# Instead of including entire repo
```

### Model not available
```bash
# List available models
agy models
# Use fallback model
agy --model gemini-3.7-flash-high -p "task"
```

### Conversation lost
```bash
# List recent conversations (not available in CLI, check ~/.antigravity/)
# Or start fresh with context injection
agy -p "Context: [previous work summary]
Continue with: [next step]"
```

---

## Reference Links

- **Official Docs**: [antigravity.google/docs/cli/overview](https://antigravity.google/docs/cli/overview)
- **Terms of Service**: [antigravity.google/terms](https://antigravity.google/terms)
- **Privacy Policy**: [policies.google.com/privacy](https://policies.google.com/privacy)

---

## Quick Start Checklist

- [ ] Install: `curl -fsSL https://antigravity.google/cli/install.sh | bash`
- [ ] Authenticate: `agy` (first run)
- [ ] Test: `agy -p "echo hello"`
- [ ] Check models: `agy models`
- [ ] Try parallel: `agy -p "task1" & agy -p "task2" & wait`
- [ ] Try multi-model: `agy --model gemini-3.7-flash-high -p "task"`
- [ ] Try resume: `agy -p "analyze code"` then `agy -c "fix issues"`

Ready to orchestrate! 🚀
