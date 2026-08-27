#!/bin/bash
#
# Example: Parallel Code Review with Multiple Models
# 
# This script demonstrates how to orchestrate agy for parallel code review
# using different models for different review dimensions.
#

set -e

echo "🔍 Starting parallel code review with agy..."
echo ""

# Phase 1: Parallel review with different models
echo "Phase 1: Running parallel reviews..."

agy --model gemini-3.7-flash-high \
    --print-timeout 3m \
    -p "Audit src/ for security issues. 
    Focus on: SQL injection, XSS, authentication bypass, data leaks.
    Output: JSON with file, line, severity, description, fix suggestion." \
    > security-review.json 2>&1 &

agy --model gemini-3.1-pro-high \
    --print-timeout 3m \
    -p "Audit src/ for performance bottlenecks.
    Focus on: N+1 queries, unnecessary loops, inefficient algorithms, memory leaks.
    Output: JSON with file, line, severity, impact, optimization suggestion." \
    > performance-review.json 2>&1 &

agy --model claude-sonnet-4-6 \
    --print-timeout 3m \
    -p "Audit src/ for code quality issues.
    Focus on: code smells, SOLID violations, duplications, naming, complexity.
    Output: JSON with file, line, issue type, refactoring suggestion." \
    > quality-review.json 2>&1 &

agy --model gemini-3.7-flash-medium \
    --print-timeout 3m \
    -p "Audit src/ for best practices violations.
    Focus on: error handling, logging, testing gaps, documentation, type safety.
    Output: JSON with file, line, category, recommendation." \
    > practices-review.json 2>&1 &

echo "⏳ Waiting for all reviews to complete..."
wait

echo "✅ All reviews completed!"
echo ""

# Phase 2: Aggregate results
echo "Phase 2: Aggregating results..."

cat > aggregate-reviews.json <<EOF
{
  "security": $(cat security-review.json),
  "performance": $(cat performance-review.json),
  "quality": $(cat quality-review.json),
  "practices": $(cat practices-review.json)
}
EOF

echo "📊 Review results aggregated to aggregate-reviews.json"
echo ""

# Phase 3: Generate summary report with Claude
echo "Phase 3: Generating summary report..."

agy --model claude-opus-4-6-thinking \
    -p "Analyze these code review results and generate an executive summary:

$(cat aggregate-reviews.json)

Output:
1. Critical issues requiring immediate attention (P0)
2. Important issues to address soon (P1)
3. Nice-to-have improvements (P2)
4. Overall code health score (0-100)
5. Top 3 action items with estimated effort

Format: Markdown with clear sections and severity indicators." \
    > final-report.md

echo "✅ Final report generated: final-report.md"
echo ""

# Display summary
echo "📋 Review Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
head -20 final-report.md
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Output files:"
echo "  - security-review.json"
echo "  - performance-review.json"
echo "  - quality-review.json"
echo "  - practices-review.json"
echo "  - aggregate-reviews.json"
echo "  - final-report.md"
echo ""
echo "✨ Done!"
