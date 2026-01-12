#!/bin/bash

# Ralph Loop SessionStart Hook
# Persists session_id as env var for use by setup script and cancel-ralph

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Extract session_id
SESSION_ID=$(echo "$HOOK_INPUT" | jq -r '.session_id')

if [[ -z "$SESSION_ID" ]] || [[ "$SESSION_ID" == "null" ]]; then
  exit 0
fi

# Persist session_id as env var for the session
# This survives context compaction and is accessible to all bash commands
echo "export RALPH_SESSION_ID=$SESSION_ID" >> "$CLAUDE_ENV_FILE"

exit 0
