#!/bin/bash
#
# Quick install script for agy-cli-skill
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/VastFuture/agy-cli-skill/main/install.sh | bash
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Default installation directory
INSTALL_DIR="${HOME}/.agents/skills/agy-cli-skill"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           agy-cli-skill Installation Script                 ║"
echo "║                                                              ║"
echo "║  Orchestrate Google Antigravity CLI for parallel task       ║"
echo "║  execution, multi-model routing, and intelligent context    ║"
echo "║  injection.                                                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check if agy is installed
print_info "Checking for Antigravity CLI (agy)..."
if ! command -v agy &> /dev/null; then
    print_error "agy not found!"
    echo ""
    echo "Please install Antigravity CLI first:"
    echo ""
    echo "  macOS / Linux:"
    echo "    curl -fsSL https://antigravity.google/cli/install.sh | bash"
    echo ""
    echo "  Windows PowerShell:"
    echo "    irm https://antigravity.google/cli/install.ps1 | iex"
    echo ""
    exit 1
fi
print_success "agy found: $(which agy)"

# Check if git is installed
print_info "Checking for git..."
if ! command -v git &> /dev/null; then
    print_error "git not found! Please install git first."
    exit 1
fi
print_success "git found: $(which git)"

# Create skills directory if it doesn't exist
print_info "Creating skills directory if needed..."
mkdir -p "$(dirname "$INSTALL_DIR")"
print_success "Skills directory ready: $(dirname "$INSTALL_DIR")"

# Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
    print_info "Skill already installed, updating..."
    cd "$INSTALL_DIR"
    git pull origin main
    print_success "Skill updated to latest version"
else
    print_info "Installing skill..."
    git clone https://github.com/VastFuture/agy-cli-skill.git "$INSTALL_DIR"
    print_success "Skill installed to: $INSTALL_DIR"
fi

# Make example scripts executable
print_info "Making example scripts executable..."
chmod +x "$INSTALL_DIR"/examples/*.sh
print_success "Example scripts are executable"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                  Installation Complete! 🎉                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📍 Installed to: $INSTALL_DIR"
echo ""
echo "🚀 Quick Start:"
echo ""
echo "  1. Test agy:"
echo "     agy -p \"echo hello\""
echo ""
echo "  2. List available models:"
echo "     agy models"
echo ""
echo "  3. Try an example:"
echo "     cd $INSTALL_DIR/examples"
echo "     ./parallel-review.sh"
echo ""
echo "📚 Documentation:"
echo "  - English: $INSTALL_DIR/SKILL.md"
echo "  - 中文:     $INSTALL_DIR/SKILL_zh_CN.md"
echo "  - Examples: $INSTALL_DIR/examples/README.md"
echo ""
echo "🔗 More info: https://github.com/VastFuture/agy-cli-skill"
echo ""
