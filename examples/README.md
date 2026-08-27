# Examples

This directory contains practical examples demonstrating different agy orchestration patterns.

## Quick Start

All examples are executable bash scripts. Make them executable first:

```bash
chmod +x examples/*.sh
```

## Available Examples

### 1. Parallel Code Review (`parallel-review.sh`)

**Use Case**: Comprehensive codebase review using multiple models in parallel.

**What it does**:
- Runs 4 parallel reviews (security, performance, quality, practices)
- Uses different models optimized for each dimension
- Aggregates results into a single JSON
- Generates executive summary with Claude Opus

**Models used**:
- Gemini Flash High (security)
- Gemini Pro High (performance)
- Claude Sonnet (quality)
- Gemini Flash Medium (practices)
- Claude Opus Thinking (synthesis)

**Run it**:
```bash
./examples/parallel-review.sh
```

**Output files**:
- `security-review.json`
- `performance-review.json`
- `quality-review.json`
- `practices-review.json`
- `aggregate-reviews.json`
- `final-report.md`

---

### 2. Iterative Development (`iterative-development.sh`)

**Use Case**: Multi-round development workflow with conversation resume.

**What it does**:
1. **Round 1**: Analyze requirements and create detailed plan
2. **Round 2**: Implement the feature
3. **Round 3**: Add comprehensive tests
4. **Round 4**: Fix test failures (if any)
5. **Round 5**: Add documentation

**Key feature**: Uses `agy -c` to continue the same conversation, preserving full context across all rounds.

**Run it**:
```bash
./examples/iterative-development.sh
```

**Interactive**: Pauses between rounds for human review.

---

### 3. Multi-Model Consensus (`multi-model-consensus.sh`)

**Use Case**: Critical architectural decisions requiring multiple perspectives.

**What it does**:
1. **Phase 1**: Get architecture designs from 3 different models in parallel
2. **Phase 2**: Cross-analyze all designs (strengths, weaknesses, differences)
3. **Phase 3**: Synthesize final recommendation combining best elements
4. **Phase 4**: Validate final recommendation for fatal flaws

**Models used**:
- Gemini 3.1 Pro High (design + synthesis)
- Claude Opus 4.6 Thinking (design + analysis)
- GPT-OSS 120B (design)
- Claude Sonnet 4.6 (validation)

**Run it**:
```bash
./examples/multi-model-consensus.sh
```

**Output files**:
- `design-gemini.md`
- `design-claude.md`
- `design-gpt.md`
- `analysis.md`
- `final-recommendation.md`
- `validation.md`

---

## Customization

### Change Target Directory

All examples analyze `src/` by default. To analyze a different directory:

```bash
# Edit the script and change "src/" to your target
sed -i 's|src/|your-dir/|g' examples/parallel-review.sh
```

### Adjust Timeouts

Increase timeout for large codebases:

```bash
# Change --print-timeout from 3m to 10m
sed -i 's|--print-timeout 3m|--print-timeout 10m|g' examples/*.sh
```

### Use Different Models

List available models:
```bash
agy models
```

Then edit the scripts to use your preferred models.

### Add More Parallel Tasks

In `parallel-review.sh`, add more review dimensions:

```bash
agy --model gemini-3.7-flash-high \
    -p "Audit src/ for accessibility issues..." \
    > a11y-review.json 2>&1 &
```

---

## Pattern Library

### Pattern: Parallel + Aggregate

```bash
# Run tasks in parallel
agy -p "task1" > out1.txt &
agy -p "task2" > out2.txt &
wait

# Aggregate results
cat out1.txt out2.txt > combined.txt
```

### Pattern: Context Injection

```bash
# Collect context first
ERRORS=$(npm run build 2>&1 | grep error)

# Inject into prompt
agy -p "Fix these errors: $ERRORS"
```

### Pattern: Multi-Round with Resume

```bash
# Round 1
agy -p "analyze code"

# Round 2 (continues conversation)
agy -c "fix issues"

# Round 3 (continues same conversation)
agy -c "add tests"
```

### Pattern: Multi-Model Comparison

```bash
# Get multiple perspectives
agy --model gemini-3.1-pro-high -p "design API" > design1.txt &
agy --model claude-opus-4-6-thinking -p "design API" > design2.txt &
wait

# Compare and synthesize
agy -p "Compare: $(cat design1.txt design2.txt)"
```

### Pattern: Progressive Enhancement

```bash
# Quick check first
agy --model gemini-3.7-flash-low -p "quick lint"

# Deep dive if issues found
if [ $? -ne 0 ]; then
  agy --model claude-opus-4-6-thinking -p "deep analysis"
fi
```

---

## Best Practices from Examples

### 1. Use Appropriate Models

- **Fast checks**: Gemini Flash Low
- **Standard tasks**: Gemini Flash High
- **Complex reasoning**: Gemini Pro High or Claude Opus
- **Code review**: Claude Sonnet
- **Synthesis**: Claude Opus Thinking

### 2. Structure Output

Always request structured output for easier parsing:

```bash
agy -p "analyze code. Output: JSON with {file, line, issue, fix}"
```

### 3. Set Timeouts

Prevent hanging in CI/CD:

```bash
agy --print-timeout 5m -p "task"
```

### 4. Capture Output

Always redirect stderr too:

```bash
agy -p "task" > output.txt 2>&1
```

### 5. Validate Before Proceeding

Use a final validation step for critical work:

```bash
agy --model claude-sonnet-4-6 -p "validate this solution for fatal flaws"
```

---

## Troubleshooting Examples

### Example hangs or times out

Increase timeout:
```bash
agy --print-timeout 10m -p "task"
```

### "Model not available" error

Check available models:
```bash
agy models
```

Use fallback model in script:
```bash
agy --model gemini-3.7-flash-high -p "task"  # Always available
```

### Context too large

Reduce scope:
```bash
agy --add-dir ./src/auth -p "analyze only auth module"
```

### Parallel tasks interfere

Ensure tasks are truly independent:
- Don't modify same files
- Use different output files
- Check for shared resources

---

## Contributing Examples

Have a useful pattern? Contribute it!

1. Create a new `.sh` file in this directory
2. Follow the existing format (header, phases, output)
3. Add clear comments explaining each step
4. Update this README with your example
5. Submit a PR to VastFuture/agy-cli-skill

---

## Learn More

- **Main Skill Guide**: [../SKILL.md](../SKILL.md)
- **中文指南**: [../SKILL_zh_CN.md](../SKILL_zh_CN.md)
- **Official Docs**: [antigravity.google/docs/cli](https://antigravity.google/docs/cli/overview)
