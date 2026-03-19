#!/usr/bin/env bash
# prism-summary.sh — Aggregate reviewer output files into SUMMARY.md
# Usage: prism-summary.sh <run-dir> <skill-name>
#
# Called by Watson AFTER all sessions_spawn reviewer subagents complete.
# Collects *-raw.txt files (reviewer outputs) and prior-findings-brief.md.
# Does NOT include synthesis.md — synthesis agent reads raw files directly.
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

  # Include prior brief if it exists (context for synthesis)
  if [[ -f "$RUN_DIR/prior-findings-brief.md" ]]; then
    echo "## Prior Findings Context"
    echo ""
    cat "$RUN_DIR/prior-findings-brief.md"
    echo ""
    echo "---"
    echo ""
  fi

  echo "## Reviewer Outputs"
  echo ""

  # Standard reviewer order — contrarian last (runs after consensus)
  for role_key in devil-advocate security performance simplicity integration blast-radius contrarian; do
    findings="$RUN_DIR/${role_key}-raw.txt"
    [[ -f "$findings" ]] || continue
    echo "### $role_key"
    echo ""
    cat "$findings"
    echo ""
    echo "---"
    echo ""
  done

  # Note synthesis separately — it reads raw files directly, not via SUMMARY
  if [[ -f "$RUN_DIR/synthesis.md" ]]; then
    echo "## Synthesis"
    echo ""
    echo "_Synthesis written to \`$RUN_DIR/synthesis.md\` — read that file directly._"
    echo ""
  fi
} > "$SUMMARY_FILE"

echo "$SUMMARY_FILE"

# Emit to bus
bash ~/.openclaw/scripts/sub-agent-complete.sh \
  "prism-${SKILL_NAME}" "na" \
  "PRISM review of ${SKILL_NAME} complete — summary at ${SUMMARY_FILE}" \
  2>/dev/null || true
