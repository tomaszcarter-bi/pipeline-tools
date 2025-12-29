#!/bin/bash

set -e

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No colour

# Default installation directory
INSTALL_DIR="${HOME}/.local/bin"

# Allow custom installation directory
if [ -n "${1:-}" ]; then
  INSTALL_DIR="$1"
fi

echo "Pipeline Tools Installer"
echo "========================"
echo ""

# Check for glab
if ! command -v glab &> /dev/null; then
  echo -e "${RED}Error: glab is not installed${NC}"
  echo "Please install glab first: https://gitlab.com/gitlab-org/cli"
  exit 1
fi

# Create installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
  echo "Creating directory: $INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
fi

# Copy scripts
echo "Installing scripts to $INSTALL_DIR..."
cp -f bin/watch-pipeline "$INSTALL_DIR/watch-pipeline"
chmod +x "$INSTALL_DIR/watch-pipeline"

echo -e "${GREEN}✓${NC} Installed watch-pipeline"

# Check if INSTALL_DIR is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo ""
  echo -e "${YELLOW}Warning: $INSTALL_DIR is not in your PATH${NC}"
  echo ""
  echo "Add the following to your shell configuration file (~/.bashrc, ~/.zshrc, etc.):"
  echo ""
  echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
  echo ""
else
  echo ""
  echo -e "${GREEN}Installation complete!${NC}"
  echo ""
fi

echo "Available commands:"
echo "  watch-pipeline <pipeline-id> [interval] [repo]"
echo ""
echo "Examples:"
echo "  watch-pipeline 2236689681"
echo "  watch-pipeline 2236689681 10"
echo "  watch-pipeline 2236689681 30 boardiq/other-repo"
echo ""
