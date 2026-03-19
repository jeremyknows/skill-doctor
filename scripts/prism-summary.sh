#!/usr/bin/env bash
# prism-summary.sh — Aggregate reviewer output files into SUMMARY.md
# Usage: prism-summary.sh <run-dir> <skill-name>
#
# Called by Watson AFTER all sessions_spawn reviewer subagents complete and
# have written their findings to <run-dir>/<role>-raw.txt files.
#
# Output: prints path to SUMMARY.md on stdout

set -euo pipefail

RUN_DIR="${1:-}"
SKILL_NAME="${2:-}"

if [[ -z "$RUN_DIR" || -z "$SKILL_NAME" ]]; then
  echo "Usage: prism-summary.sh <run-dir> <skill-name>" >&2
  exit 1
fi

if [[ ! -d "$RUN_DIR" ]]; then
  echo "ERROR: run directory not found: $RUN_DIR" >&2
  exit 1
fi

SUMMARY_FILE="$RUN_DIR/SUMMARY.md"

{
  echo "# PRISM Review — $SKILL_NAME"
  echo "**Date:** $(date '+%Y-%m-%d %H:%M')"
  echo ""
  echo "## Reviewer Results"
  echo ""

  for findings in "$RUN_DIR"/*-raw.txt; do
    # Guard: skip if glob found no matches
    [[ -f "$findings" ]] || continue
    role=$(basename "$findings" -raw.txt)
    echo "### $role"
    echo ""
    cat "$findings"
    echo ""
    echo "---"
    echo ""
  done
} > "$SUMMARY_FILE"

echo "$SUMMARY_FILE"

# Emit to bus
bash ~/.openclaw/scripts/sub-agent-complete.sh \
  "prism-${SKILL_NAME}" "na" \
  "PRISM review of ${SKILL_NAME} complete — summary at ${SUMMARY_FILE}" \
  2>/dev/null || true
