#!/bin/bash
#
# Example: Multi-Model Consensus for Critical Decisions
#
# This script demonstrates how to get multiple AI models to review
# the same problem and synthesize the best solution.
#

set -e

echo "🤝 Starting multi-model consensus workflow..."
echo ""

# Define the problem
PROBLEM="Design a scalable API architecture for a real-time messaging system that needs to support:
- 1M+ concurrent WebSocket connections
- Message persistence and history
- End-to-end encryption
- Group chats and direct messages
- Read receipts and typing indicators
- File attachments (up to 100MB)
- Message search across history
- Cross-platform (Web, iOS, Android)

Constraints:
- Budget: \$5K/month infrastructure
- Team: 3 backend engineers
- Timeline: 3 months to MVP
- Compliance: GDPR, CCPA

Provide:
1. Architecture diagram (text description)
2. Technology stack with justification
3. Database schema
4. API design (RESTful + WebSocket)
5. Scaling strategy
6. Security approach
7. Cost breakdown
8. Implementation phases"

echo "Problem Statement:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$PROBLEM"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Phase 1: Get designs from different models
echo "Phase 1: Collecting designs from different models..."
echo ""

echo "  → Gemini 3.1 Pro (Google's perspective)..."
agy --model gemini-3.1-pro-high \
    --effort high \
    -p "$PROBLEM" \
    > design-gemini.md 2>&1 &

echo "  → Claude Opus 4.6 (Anthropic's perspective)..."
agy --model claude-opus-4-6-thinking \
    --effort high \
    -p "$PROBLEM" \
    > design-claude.md 2>&1 &

echo "  → GPT-OSS (Alternative perspective)..."
agy --model gpt-oss-120b-medium \
    --effort high \
    -p "$PROBLEM" \
    > design-gpt.md 2>&1 &

echo "⏳ Waiting for all models to complete..."
wait

echo "✅ All designs collected!"
echo ""

# Phase 2: Cross-analyze designs
echo "Phase 2: Cross-analyzing designs..."
echo ""

GEMINI_DESIGN=$(cat design-gemini.md)
CLAUDE_DESIGN=$(cat design-claude.md)
GPT_DESIGN=$(cat design-gpt.md)

agy --model claude-opus-4-6-thinking \
    -p "Analyze these three architecture designs for the same problem:

## Gemini's Design
$GEMINI_DESIGN

## Claude's Design
$CLAUDE_DESIGN

## GPT's Design
$GPT_DESIGN

Provide a comparative analysis:

1. **Strengths and Weaknesses Table**
   - Compare each design on: scalability, security, cost, complexity, maintainability
   - Use a markdown table with scores 1-10

2. **Key Differences**
   - Technology choices
   - Architecture patterns
   - Trade-offs made

3. **Common Ground**
   - What all three agree on
   - Likely best practices

4. **Red Flags**
   - What any design got wrong
   - Missing considerations
   - Unrealistic assumptions

5. **Synthesis Recommendation**
   - Best elements from each design
   - Optimal hybrid approach
   - Rationale for each choice

Be brutally honest and technical." \
    > analysis.md

echo "✅ Cross-analysis completed!"
echo ""

# Phase 3: Generate final recommendation
echo "Phase 3: Generating final recommendation..."
echo ""

ANALYSIS=$(cat analysis.md)

agy --model gemini-3.1-pro-high \
    -p "Based on this comparative analysis:

$ANALYSIS

Generate the FINAL recommended architecture that synthesizes the best from all three designs.

Output:
1. Executive Summary (2-3 paragraphs)
2. Final Architecture (detailed)
3. Technology Stack (with version numbers)
4. Implementation Roadmap (3 phases)
5. Risk Mitigation Plan
6. Success Metrics
7. Decision Log (why we chose X over Y)

Make it actionable and ready to present to stakeholders." \
    > final-recommendation.md

echo "✅ Final recommendation generated!"
echo ""

# Phase 4: Validation check
echo "Phase 4: Running validation check..."
echo ""

FINAL=$(cat final-recommendation.md)

agy --model claude-sonnet-4-6 \
    -p "Review this final architecture recommendation for fatal flaws:

$FINAL

Check for:
- Single points of failure
- Security vulnerabilities
- Cost overruns
- Unrealistic timelines
- Technology mismatches
- Scalability bottlenecks
- Team skill gaps

Output:
- ✅ APPROVED (no fatal flaws)
- ⚠️  CONCERNS (list them with severity)
- ❌ REJECTED (major issues, do not proceed)

Be conservative - if unsure, flag it." \
    > validation.md

echo "✅ Validation completed!"
echo ""

# Display results
echo "📊 Multi-Model Consensus Results:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Generated files:"
echo "  1. design-gemini.md     - Gemini's design"
echo "  2. design-claude.md     - Claude's design"
echo "  3. design-gpt.md        - GPT's design"
echo "  4. analysis.md          - Comparative analysis"
echo "  5. final-recommendation.md - Synthesized recommendation"
echo "  6. validation.md        - Validation check"
echo ""

VALIDATION_RESULT=$(head -1 validation.md)
echo "🔍 Validation Result:"
echo "   $VALIDATION_RESULT"
echo ""

if [[ "$VALIDATION_RESULT" == *"APPROVED"* ]]; then
    echo "✅ Architecture approved! Ready to present to stakeholders."
elif [[ "$VALIDATION_RESULT" == *"CONCERNS"* ]]; then
    echo "⚠️  Architecture has concerns. Review validation.md before proceeding."
else
    echo "❌ Architecture rejected. Major issues found. Review validation.md."
    exit 1
fi

echo ""
echo "📄 Final Recommendation Preview:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
head -30 final-recommendation.md
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ Multi-model consensus process completed!"
echo "🎯 Confidence level: HIGH (validated by 4 different AI models)"
