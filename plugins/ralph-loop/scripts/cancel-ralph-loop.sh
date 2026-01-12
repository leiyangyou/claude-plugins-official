#!/bin/bash

# Cancel Ralph Loop Script
# Cancels the active ralph-loop for the current session

set -euo pipefail

# Check for session ID from SessionStart hook
if [[ -z "${RALPH_SESSION_ID:-}" ]]; then
  # Fallback: list all state files
  STATE_FILES=$(ls .claude/ralph-loop-*.local.md 2>/dev/null || true)

  if [[ -z "$STATE_FILES" ]]; then
    echo "No active Ralph loops found."
    exit 0
  fi

  echo "⚠️  RALPH_SESSION_ID not set. Found these state files:"
  echo "$STATE_FILES"
  echo ""
  echo "Cannot determine which belongs to this session."
  echo "To cancel all, run: rm .claude/ralph-loop-*.local.md"
  exit 0
fi

STATE_FILE=".claude/ralph-loop-${RALPH_SESSION_ID}.local.md"

if [[ ! -f "$STATE_FILE" ]]; then
  echo "No active Ralph loop in this session."
  exit 0
fi

# Get iteration count before removing
ITERATION=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE" | grep '^iteration:' | sed 's/iteration: *//' || echo "?")

# Remove the state file
rm "$STATE_FILE"

echo "✅ Cancelled Ralph loop (was at iteration $ITERATION)"
