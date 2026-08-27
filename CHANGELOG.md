# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-27

### Added
- Initial release of agy-cli skill
- Core orchestration patterns for Google Antigravity CLI
- Multi-model routing support (Gemini, Claude, GPT-OSS)
- Context pre-injection strategies
- Conversation resume workflows
- Parallel execution patterns
- Effort level control
- Comprehensive English documentation (SKILL.md)
- Complete Chinese documentation (SKILL_zh_CN.md)
- Three practical examples:
  - `parallel-review.sh` - Multi-dimensional code review with parallel models
  - `iterative-development.sh` - Multi-round development with conversation resume
  - `multi-model-consensus.sh` - Critical decisions with multiple AI perspectives
- Example documentation with customization guide
- Pattern library for common use cases
- Best practices and troubleshooting guide
- MIT License

### Features
- **Context Pre-Injection**: Claude Code collects context before delegating to agy
- **Conversation Resume**: Continue related work with `agy -c` to preserve context
- **Parallel Execution**: Run multiple agy instances for independent tasks
- **Multi-Model Routing**: Route tasks to optimal models based on complexity
- **Effort Control**: Adjust reasoning depth with `--effort` flag (low/medium/high)
- **Execution Modes**: Plan mode, interactive mode, and non-interactive print mode
- **Workspace Management**: Scope work with `--add-dir` and `--new-project`
- **Output Formats**: Support for text, JSON, and stream-json outputs
- **JSON Schema Enforcement**: Structured output with schema validation
- **Sandbox Mode**: Safe execution with terminal restrictions

### Documentation
- Quick start guide with installation and authentication
- Three optimization strategies (context injection, resume, parallel)
- Multi-model routing decision tree
- Prompt design principles
- Comprehensive command reference
- Integration patterns for CI/CD, Git hooks, and testing workflows
- Security considerations and best practices
- Troubleshooting guide
- Pattern library with code examples

### Examples
- **Parallel Review**: 4-way parallel code review (security, performance, quality, practices) with aggregation and executive summary
- **Iterative Development**: 5-round workflow (plan → implement → test → fix → document) with conversation resume
- **Multi-Model Consensus**: 3-model design comparison → cross-analysis → synthesis → validation for critical architectural decisions

### Models Supported
- Gemini 3.7 Flash (high/medium/low)
- Gemini 3.6 Flash (high/medium/low)
- Gemini 3.5 Flash (high/medium/low)
- Gemini 3.1 Pro (high/low)
- Claude Sonnet 4.6
- Claude Opus 4.6 (Thinking)
- GPT-OSS 120B (medium)

[1.0.0]: https://github.com/VastFuture/agy-cli-skill/releases/tag/v1.0.0
