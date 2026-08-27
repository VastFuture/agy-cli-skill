#!/bin/bash
#
# Verify agy-cli-skill installation
#
# This script checks that all dependencies are installed and
# the skill is properly configured.
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0

# Print functions
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_test() {
    echo -n "  Testing: $1 ... "
}

print_pass() {
    echo -e "${GREEN}✓ PASS${NC}"
    ((PASSED++))
}

print_fail() {
    echo -e "${RED}✗ FAIL${NC}"
    echo -e "    ${YELLOW}$1${NC}"
    ((FAILED++))
}

print_info() {
    echo -e "    ${BLUE}ℹ${NC} $1"
}

# Main verification
print_header "agy-cli-skill Installation Verification"

# Test 1: Check if agy is installed
print_test "agy CLI installed"
if command -v agy &> /dev/null; then
    print_pass
    AGY_VERSION=$(agy --version 2>&1 || echo "unknown")
    print_info "Version: $AGY_VERSION"
    print_info "Location: $(which agy)"
else
    print_fail "agy not found. Install: curl -fsSL https://antigravity.google/cli/install.sh | bash"
fi

# Test 2: Check if git is installed
print_test "git installed"
if command -v git &> /dev/null; then
    print_pass
    print_info "Version: $(git --version)"
else
    print_fail "git not found. Install git first."
fi

# Test 3: Check if skill directory exists
print_test "Skill directory exists"
SKILL_DIR="${HOME}/.agents/skills/agy-cli-skill"
if [ -d "$SKILL_DIR" ]; then
    print_pass
    print_info "Location: $SKILL_DIR"
else
    print_fail "Skill not installed. Run: curl -fsSL https://raw.githubusercontent.com/VastFuture/agy-cli-skill/main/install.sh | bash"
fi

# Test 4: Check if SKILL.md exists
print_test "SKILL.md exists"
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    print_pass
else
    print_fail "SKILL.md missing"
fi

# Test 5: Check if examples directory exists
print_test "Examples directory exists"
if [ -d "$SKILL_DIR/examples" ]; then
    print_pass
    EXAMPLE_COUNT=$(ls -1 "$SKILL_DIR/examples"/*.sh 2>/dev/null | wc -l)
    print_info "Found $EXAMPLE_COUNT example scripts"
else
    print_fail "Examples directory missing"
fi

# Test 6: Check if examples are executable
print_test "Example scripts are executable"
if [ -d "$SKILL_DIR/examples" ]; then
    NON_EXECUTABLE=$(find "$SKILL_DIR/examples" -name "*.sh" ! -perm -u+x 2>/dev/null | wc -l)
    if [ "$NON_EXECUTABLE" -eq 0 ]; then
        print_pass
    else
        print_fail "Found $NON_EXECUTABLE non-executable scripts. Run: chmod +x $SKILL_DIR/examples/*.sh"
    fi
else
    print_fail "Examples directory not found"
fi

# Test 7: Check agy authentication
print_test "agy authentication"
AGY_AUTH_TEST=$(agy -p "echo test" 2>&1)
if [[ "$AGY_AUTH_TEST" == *"login"* ]] || [[ "$AGY_AUTH_TEST" == *"auth"* ]]; then
    print_fail "agy not authenticated. Run: agy (and follow login flow)"
elif [[ "$AGY_AUTH_TEST" == *"error"* ]] && [[ "$AGY_AUTH_TEST" != *"test"* ]]; then
    print_fail "agy authentication error: $AGY_AUTH_TEST"
else
    print_pass
fi

# Test 8: Check if models are available
print_test "Model availability"
MODEL_LIST=$(agy models 2>&1)
if [[ "$MODEL_LIST" == *"gemini"* ]] || [[ "$MODEL_LIST" == *"claude"* ]]; then
    print_pass
    MODEL_COUNT=$(echo "$MODEL_LIST" | grep -c "gemini\|claude\|gpt" || echo 0)
    print_info "Available models: $MODEL_COUNT"
else
    print_fail "No models available. Check agy authentication."
fi

# Test 9: Test basic agy functionality
print_test "Basic agy functionality"
TEST_OUTPUT=$(agy --print-timeout 30s -p "return the word SUCCESS" 2>&1 || echo "FAILED")
if [[ "$TEST_OUTPUT" == *"SUCCESS"* ]]; then
    print_pass
else
    print_fail "agy basic test failed"
fi

# Test 10: Check documentation accessibility
print_test "Documentation files"
DOC_FILES=("README.md" "SKILL.md" "SKILL_zh_CN.md" "LICENSE" "CONTRIBUTING.md" "CHANGELOG.md")
MISSING_DOCS=0
for doc in "${DOC_FILES[@]}"; do
    if [ ! -f "$SKILL_DIR/$doc" ]; then
        ((MISSING_DOCS++))
    fi
done
if [ "$MISSING_DOCS" -eq 0 ]; then
    print_pass
    print_info "All documentation files present"
else
    print_fail "$MISSING_DOCS documentation files missing"
fi

# Summary
echo ""
print_header "Verification Summary"

TOTAL=$((PASSED + FAILED))
echo -e "  Total tests: ${BLUE}$TOTAL${NC}"
echo -e "  Passed: ${GREEN}$PASSED${NC}"
echo -e "  Failed: ${RED}$FAILED${NC}"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! Installation is complete and working.${NC}"
    echo ""
    echo "🚀 Next steps:"
    echo "  1. Try an example: cd $SKILL_DIR/examples && ./parallel-review.sh"
    echo "  2. Read the docs: cat $SKILL_DIR/SKILL.md"
    echo "  3. List models: agy models"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please fix the issues above.${NC}"
    echo ""
    echo "💡 Common fixes:"
    echo "  - Install agy: curl -fsSL https://antigravity.google/cli/install.sh | bash"
    echo "  - Authenticate: agy (and follow login flow)"
    echo "  - Reinstall skill: curl -fsSL https://raw.githubusercontent.com/VastFuture/agy-cli-skill/main/install.sh | bash"
    echo ""
    exit 1
fi
