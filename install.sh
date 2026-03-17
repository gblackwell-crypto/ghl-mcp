#!/bin/bash
set -e

# ── GoHighLevel MCP Server Installer ─────────────────────────────────────────
# Connects your GHL sub-account to Claude Code in under 60 seconds.

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "══════════════════════════════════════════════════"
echo "  GoHighLevel MCP Server — Sub-Account Setup"
echo "══════════════════════════════════════════════════"
echo ""

# ── Check Python ──────────────────────────────────────────────────────────────
if command -v python3 &>/dev/null; then
    PYTHON=python3
elif command -v python &>/dev/null; then
    PYTHON=python
else
    echo "ERROR: Python 3 is required but not found."
    echo "Install it from https://python.org/downloads"
    exit 1
fi

echo "Using Python: $($PYTHON --version)"

# ── Create venv & install deps ────────────────────────────────────────────────
echo ""
echo "Setting up virtual environment..."
$PYTHON -m venv "$REPO_DIR/.venv"
"$REPO_DIR/.venv/bin/pip" install -q -r "$REPO_DIR/requirements.txt"
echo "Dependencies installed."

# ── Collect credentials ───────────────────────────────────────────────────────
echo ""
echo "You need two things from GoHighLevel:"
echo ""
echo "  1. Private Integration Token (Sub-Account level)"
echo "     → GHL Sub-Account Settings > Integrations > Private Integrations"
echo "     → Create one with the scopes you need, copy the token"
echo ""
echo "  2. Location ID (your sub-account ID)"
echo "     → Look at the URL when you're inside your sub-account:"
echo "     → https://app.gohighlevel.com/v2/location/XXXXXXX/..."
echo "     → The XXXXXXX part is your Location ID"
echo ""

read -rp "Paste your Private Integration Token: " GHL_TOKEN
echo ""
read -rp "Paste your Location ID: " GHL_LOCATION

if [ -z "$GHL_TOKEN" ] || [ -z "$GHL_LOCATION" ]; then
    echo "ERROR: Both values are required."
    exit 1
fi

# ── Register with Claude Code ─────────────────────────────────────────────────
VENV_PYTHON="$REPO_DIR/.venv/bin/python"
MAIN_PY="$REPO_DIR/main.py"

echo ""
echo "Registering MCP server with Claude Code..."

claude mcp add ghl \
    -e GHL_PRIVATE_TOKEN="$GHL_TOKEN" \
    -e GHL_LOCATION_ID="$GHL_LOCATION" \
    -- "$VENV_PYTHON" "$MAIN_PY"

echo ""
echo "══════════════════════════════════════════════════"
echo "  Done! Restart Claude Code and you're live."
echo "══════════════════════════════════════════════════"
echo ""
echo "Try saying: \"Show me all my contacts in GHL\""
echo ""
echo "──────────────────────────────────────────────────"
echo "  Built by @tenfoldmarc"
echo "  Follow for more AI automation builds:"
echo "  https://instagram.com/tenfoldmarc"
echo "──────────────────────────────────────────────────"
echo ""
