# agy-cli Skill

Orchestrate Google Antigravity CLI for parallel task execution, multi-model routing, and intelligent context injection.

## Installation

```bash
# Clone this skill
git clone https://github.com/VastFuture/agy-cli-skill.git ~/.agents/skills/agy-cli-skill

# Or add as symlink
ln -s /path/to/agy-cli-skill ~/.agents/skills/agy-cli-skill
```

## Prerequisites

1. **Install Antigravity CLI**:
   ```bash
   # macOS / Linux
   curl -fsSL https://antigravity.google/cli/install.sh | bash
   
   # Windows PowerShell
   irm https://antigravity.google/cli/install.ps1 | iex
   ```

2. **Authenticate**:
   ```bash
   agy
   # Follow the authentication flow
   ```

3. **Verify installation**:
   ```bash
   agy models  # List available models
   agy -p "echo hello"  # Test basic functionality
   ```

## Quick Start

### Single Task
```bash
# Let Claude Code orchestrate agy
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

## Features

- **Context Pre-Injection**: Claude Code collects info before delegating to agy
- **Conversation Resume**: Continue related work in the same context
- **Parallel Execution**: Run multiple agy instances for different modules
- **Multi-Model Routing**: Use Gemini/Claude/GPT based on task complexity
- **Effort Control**: Adjust reasoning depth with `--effort` flag
- **Execution Modes**: Plan, interactive, or non-interactive

## Usage Patterns

### 1. Pre-Inject Context (Recommended)
```bash
# Claude Code collects errors first
ERRORS=$(npm run build 2>&1 | grep error)

# Then injects into agy prompt
agy -p "Fix these build errors:
$ERRORS
Only modify relevant files."
```

### 2. Parallel Code Review
```bash
# Different models for different dimensions
agy --model gemini-3.7-flash-high -p "audit security" > sec.txt &
agy --model gemini-3.1-pro-high -p "audit performance" > perf.txt &
agy --model claude-sonnet-4-6 -p "audit quality" > qual.txt &
wait

# Aggregate results
cat sec.txt perf.txt qual.txt > full-review.txt
```

### 3. Iterative Development
```bash
# Round 1: Plan
agy -p "plan implementation of user auth"

# Round 2-4: Execute iteratively
agy -c "implement as planned"
agy -c "add tests"
agy -c "fix test failures"
```

### 4. Multi-Model Consensus
```bash
# Get different perspectives
agy --model gemini-3.1-pro-high -p "design API" > design-gemini.txt &
agy --model claude-opus-4-6-thinking -p "design API" > design-claude.txt &
wait

# Compare and synthesize
agy -p "Compare these designs and recommend best: $(cat design-*.txt)"
```

## Model Selection Guide

| Task Type | Recommended Model | Reasoning |
|-----------|-------------------|-----------|
| Lint/Format | `gemini-3.7-flash-low` | Fast, simple checks |
| Standard Coding | `gemini-3.7-flash-high` | Balanced speed/quality |
| Architecture Design | `gemini-3.1-pro-high` | Complex reasoning |
| Deep Refactoring | `claude-opus-4-6-thinking` | Deep thinking mode |
| Code Review | `claude-sonnet-4-6` | Thorough analysis |
| Alternative View | `gpt-oss-120b-medium` | Different perspective |

## Integration Examples

### CI/CD Pipeline
```bash
#!/bin/bash
# .github/workflows/review.sh

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
# .git/hooks/pre-commit

STAGED=$(git diff --cached --name-only)
agy --model gemini-3.7-flash-high \
  -p "Review staged files: $STAGED
  Check: style, types, logic
  Output: pass/fail with reasons"
```

### Test-Fix Loop
```bash
#!/bin/bash
# scripts/test-fix.sh

TEST_OUTPUT=$(npm test 2>&1)
if [ $? -ne 0 ]; then
  agy -p "Test failures:
  $TEST_OUTPUT
  
  Analyze root cause and provide fixes."
fi
```

## Best Practices

1. **Pre-inject context when possible** - saves agy exploration time
2. **Resume conversations for related work** - preserves context
3. **Parallel independent tasks** - reduces total time
4. **Use appropriate models** - match model to task complexity
5. **Structure prompts clearly** - verb + scope + constraints + output format
6. **Monitor resources** - don't spawn too many parallel instances
7. **Review all changes** - never auto-commit without review

## Security

⚠️ **Important Safety Guidelines**:

- **Always review** agy's changes before committing
- **Never use** `--dangerously-skip-permissions` in production
- **Sandbox untrusted tasks** with `--sandbox` flag
- **Limit workspace scope** with `--add-dir` to specific directories
- **Monitor agy actions** in logs and audit trails

## Troubleshooting

### agy not found
```bash
# Install agy first
curl -fsSL https://antigravity.google/cli/install.sh | bash

# Verify installation
which agy
agy --help
```

### Authentication failed
```bash
# Re-authenticate
agy  # Follow the login flow
```

### Model not available
```bash
# List available models
agy models

# Use fallback model
agy --model gemini-3.7-flash-high -p "task"
```

### Context too large
```bash
# Reduce workspace scope
agy --add-dir ./src/specific-module -p "task"
```

### Timeout issues
```bash
# Use shorter timeout for CI/CD
agy --print-timeout 2m -p "quick task"
```

## Documentation

- **English Guide**: [SKILL.md](./SKILL.md)
- **中文指南**: [SKILL_zh_CN.md](./SKILL_zh_CN.md)
- **Official Docs**: [antigravity.google/docs/cli](https://antigravity.google/docs/cli/overview)

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Add examples or documentation
4. Submit a pull request

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Related Skills

- [qwen-cli-skill](https://github.com/VastFuture/qwen-cli-skill) - Qwen CLI orchestration
- [vast-codex-cli](https://github.com/VastFuture/vast-codex-cli) - OpenAI Codex CLI orchestration
- [vast-gemini-cli](https://github.com/VastFuture/vast-gemini-cli) - Gemini CLI orchestration

## Support

- **Issues**: [GitHub Issues](https://github.com/VastFuture/agy-cli-skill/issues)
- **Discussions**: [GitHub Discussions](https://github.com/VastFuture/agy-cli-skill/discussions)

---

Made with ❤️ for the Claude Code community
