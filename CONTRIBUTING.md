# Contributing to agy-cli-skill

Thank you for your interest in contributing! This document provides guidelines for contributing to the agy-cli-skill project.

## Code of Conduct

Be respectful, constructive, and helpful. We're all here to learn and improve.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/VastFuture/agy-cli-skill/issues)
2. If not, create a new issue using the bug report template
3. Include:
   - Clear description of the bug
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, agy version, model used)
   - Command output or error messages

### Suggesting Features

1. Check if the feature has already been requested in [Issues](https://github.com/VastFuture/agy-cli-skill/issues)
2. If not, create a new issue using the feature request template
3. Include:
   - Clear description of the feature
   - Use case and motivation
   - Example usage
   - Any alternative solutions considered

### Contributing Examples

We especially welcome new orchestration patterns and examples!

1. Create a new `.sh` file in the `examples/` directory
2. Follow the existing format:
   - Clear header comment explaining the use case
   - Phases or rounds with echo messages
   - Proper error handling
   - Output file management
   - Summary at the end

3. Make it executable:
   ```bash
   chmod +x examples/your-example.sh
   ```

4. Update `examples/README.md` with:
   - Description of your example
   - What it does
   - Models used
   - How to run it
   - Expected output

5. Test your example:
   ```bash
   ./examples/your-example.sh
   ```

### Contributing Documentation

1. For English documentation, edit `SKILL.md`
2. For Chinese documentation, edit `SKILL_zh_CN.md`
3. Keep both versions in sync
4. Follow the existing structure and style
5. Use clear, concise language
6. Include code examples where helpful

### Pull Request Process

1. Fork the repository
2. Create a new branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make your changes:
   - Write clear, descriptive commit messages
   - Keep commits focused and atomic
   - Follow existing code style

4. Test your changes:
   ```bash
   # For examples
   ./examples/your-example.sh
   
   # For documentation
   # Review in markdown viewer
   ```

5. Update documentation:
   - Add your changes to `CHANGELOG.md` under `[Unreleased]`
   - Update `README.md` if needed
   - Update relevant documentation files

6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

7. Create a Pull Request:
   - Use the PR template
   - Provide clear description of changes
   - Link related issues
   - Check all boxes in the checklist

## Development Guidelines

### Example Script Guidelines

- **Shebang**: Start with `#!/bin/bash`
- **Header**: Include clear comment explaining use case
- **Error handling**: Use `set -e` to exit on errors
- **Output**: Echo progress messages for each phase
- **Cleanup**: Handle temporary files appropriately
- **Documentation**: Comment complex logic

Example structure:
```bash
#!/bin/bash
#
# Example: Description of what this does
#
# Brief explanation of the use case and workflow
#

set -e

echo "🚀 Starting workflow..."
echo ""

# Phase 1: Description
echo "Phase 1: Doing something..."
agy --model ... -p "..." > output.txt
echo "✅ Phase 1 completed!"
echo ""

# Phase 2: Description
echo "Phase 2: Doing something else..."
agy -c "..." 
echo "✅ Phase 2 completed!"
echo ""

echo "✨ Workflow completed!"
```

### Documentation Guidelines

- **Clear headings**: Use descriptive section titles
- **Code blocks**: Use proper syntax highlighting
- **Examples**: Include practical, runnable examples
- **Consistency**: Follow existing formatting
- **Completeness**: Cover all important aspects
- **Accuracy**: Test all commands and examples

### Commit Message Guidelines

Follow conventional commits format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat(examples): add CI/CD integration example

Add example demonstrating integration with GitHub Actions
and GitLab CI for automated code review workflows.

Closes #42
```

```
docs(skill): clarify multi-model routing strategy

Improve explanation of when to use each model and add
decision tree diagram.
```

## Style Guide

### Bash Scripts

- Use 4 spaces for indentation
- Quote variables: `"$VAR"` not `$VAR`
- Use `$()` for command substitution, not backticks
- Check exit codes: `if [ $? -ne 0 ]; then`
- Use meaningful variable names

### Markdown

- Use ATX-style headers (`#` not underlines)
- One sentence per line (makes diffs cleaner)
- Use fenced code blocks with language tags
- Keep line length under 100 characters for prose
- Use relative links for internal references

## Testing

Before submitting a PR:

1. **Test examples**:
   ```bash
   cd examples
   ./your-example.sh
   ```

2. **Verify documentation**:
   - Check all links work
   - Verify code examples are accurate
   - Ensure consistent formatting

3. **Run with different models**:
   ```bash
   # Test with multiple models to ensure compatibility
   agy --model gemini-3.7-flash-high -p "test"
   agy --model claude-sonnet-4-6 -p "test"
   ```

## Getting Help

- **Questions**: Open a [Discussion](https://github.com/VastFuture/agy-cli-skill/discussions)
- **Bugs**: Open an [Issue](https://github.com/VastFuture/agy-cli-skill/issues)
- **Contributing**: This document
- **Documentation**: [SKILL.md](./SKILL.md) and [SKILL_zh_CN.md](./SKILL_zh_CN.md)

## Recognition

Contributors will be:
- Listed in release notes
- Credited in commit history
- Appreciated by the community! 🎉

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to agy-cli-skill! 🚀
