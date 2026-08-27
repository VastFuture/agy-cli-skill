#!/bin/bash
#
# Example: Iterative Development with Conversation Resume
#
# This script demonstrates how to use agy's conversation resume feature
# for iterative development workflow.
#

set -e

echo "🚀 Starting iterative development workflow..."
echo ""

# Round 1: Analysis and Planning
echo "Round 1: Analysis and Planning"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

agy --model gemini-3.1-pro-high \
    -p "Analyze the codebase and create a detailed plan for implementing user authentication.
    
    Requirements:
    - JWT-based authentication
    - Email/password login
    - OAuth2 (Google, GitHub)
    - Password reset flow
    - Rate limiting
    - CSRF protection
    
    Output:
    1. Architecture overview
    2. Files to create/modify
    3. Dependencies needed
    4. Implementation steps with estimated time
    5. Security considerations
    6. Testing strategy"

echo ""
read -p "Review the plan. Press Enter to continue with implementation..."
echo ""

# Round 2: Implementation
echo "Round 2: Implementation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

agy -c "Implement the authentication system as planned.
    
    Focus on:
    - Follow the plan exactly
    - Use TypeScript with strict types
    - Add JSDoc comments for public APIs
    - Handle all error cases
    - Log important events
    
    Stop after implementation, before testing."

echo ""
read -p "Review the implementation. Press Enter to continue with tests..."
echo ""

# Round 3: Testing
echo "Round 3: Add Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

agy -c "Add comprehensive tests for the authentication system.
    
    Test coverage:
    - Unit tests for all utility functions
    - Integration tests for auth flow
    - Security tests (SQL injection, XSS, etc.)
    - Edge cases (invalid tokens, expired sessions)
    - Mock external dependencies
    
    Use Jest framework with appropriate matchers."

echo ""
echo "Running tests..."
npm test

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Tests failed!"
    
    # Round 4: Fix test failures
    echo "Round 4: Fix Test Failures"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    TEST_OUTPUT=$(npm test 2>&1)
    
    agy -c "Fix the test failures:
    
    Test output:
    $TEST_OUTPUT
    
    Analyze:
    1. Root cause of each failure
    2. Whether it's a test issue or implementation issue
    3. Correct fix for each
    
    Apply fixes and ensure all tests pass."
    
    echo ""
    echo "Running tests again..."
    npm test
fi

echo ""
echo "✅ All tests passed!"
echo ""

# Round 5: Documentation
echo "Round 5: Add Documentation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

agy -c "Add documentation for the authentication system.
    
    Create:
    1. API documentation (OpenAPI/Swagger)
    2. Usage guide in README.md
    3. Architecture diagram (Mermaid)
    4. Security best practices guide
    5. Troubleshooting section
    
    Use clear examples and code snippets."

echo ""
echo "✨ Iterative development completed!"
echo ""
echo "📊 Summary:"
echo "  ✓ Analysis and planning"
echo "  ✓ Implementation"
echo "  ✓ Comprehensive tests"
echo "  ✓ Test fixes (if needed)"
echo "  ✓ Documentation"
echo ""
echo "🎉 Authentication system ready for review!"
