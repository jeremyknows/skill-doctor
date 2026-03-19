#!/usr/bin/env bash
# prism-setup.sh — Deterministic scaffolding for PRISM reviews
# Usage: prism-setup.sh <skill-name> [skill-path]
#
# Handles everything that does NOT require LLM judgment:
#   1. Validates SKILL_NAME (blocks path traversal / injection)
#   2. Locates the skill (auto-detects path if not provided)
#   3. Checks SKILL.md exists and is readable
#   4. Scans for potential secrets (count only — never echoes content)
#   5. Creates a timestamped run directory
#   6. Writes a manifest.json to the run dir
#   7. Prints JSON to stdout: {"skill_name","skill_path","run_dir","skill_content_path","reviewer_dir","manifest"}
#
# LLM fan-out (sessions_spawn) is handled by Watson, not this script.
# Summary aggregation: use prism-summary.sh after Watson collects reviewer output files.
#
# Requirements: GNU timeout (brew install coreutils)

set -euo pipefail

# ── Startup guard ─────────────────────────────────────────────────────────────
if ! timeout --version 2>&1 | grep -q "GNU"; then
  echo '{"error":"GNU timeout required. Run: brew install coreutils"}' >&2
  exit 1
fi

REVIEW_ARCHIVE_DIR="$HOME/.openclaw/agents/main/workspace/analysis/prism/archive"
REVIEWER_DIR="$HOME/.openclaw/skills/skill-doctor/references/reviewers"

# ── Args ──────────────────────────────────────────────────────────────────────
SKILL_NAME="${1:-}"
SKILL_PATH_ARG="${2:-}"

if [[ -z "$SKILL_NAME" ]]; then
  echo '{"error":"Usage: prism-setup.sh <skill-name> [skill-path]"}' >&2
  exit 1
fi

# ── Validate SKILL_NAME (blocks ../traversal, injection, spaces) ──────────────
if [[ ! "$SKILL_NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
  echo "{\"error\":\"Invalid SKILL_NAME '${SKILL_NAME}': only alphanumerics, dots, hyphens, underscores allowed\"}" >&2
  exit 1
fi

# ── Auto-detect skill path ────────────────────────────────────────────────────
SKILL_PATH=""
if [[ -n "$SKILL_PATH_ARG" ]]; then
  SKILL_PATH="$SKILL_PATH_ARG"
else
  local_path="$HOME/.openclaw/skills/$SKILL_NAME"
  npm_prefix="$(npm prefix --global 2>/dev/null || echo "$HOME/.npm-global")"
  npm_path="$npm_prefix/lib/node_modules/openclaw/skills/$SKILL_NAME"

  if [[ -f "$local_path/SKILL.md" ]]; then
    SKILL_PATH="$local_path"
  elif [[ -f "$npm_path/SKILL.md" ]]; then
    SKILL_PATH="$npm_path"
  else
    echo "{\"error\":\"Cannot find SKILL.md for '${SKILL_NAME}'. Provide path explicitly.\"}" >&2
    exit 1
  fi
fi

if [[ ! -f "$SKILL_PATH/SKILL.md" ]]; then
  echo "{\"error\":\"No SKILL.md found at ${SKILL_PATH}\"}" >&2
  exit 1
fi

# ── Secret scan (count only — never echo raw content) ────────────────────────
SECRET_COUNT=0
SECRET_COUNT=$(grep -icE "(api_key|password|bearer|sk-[a-zA-Z0-9]{10,}|ghp_[a-zA-Z0-9]{10,})" \
  "$SKILL_PATH/SKILL.md" 2>/dev/null || true)

if [[ "$SECRET_COUNT" -gt 0 ]]; then
  # Print warning to stderr only; caller decides whether to abort
  echo "[prism-setup] ⚠️  $SECRET_COUNT potential secret(s) detected. Inspect manually: grep -niE '(api_key|password|bearer|sk-|ghp_)' $SKILL_PATH/SKILL.md" >&2
fi

# ── Create run directory ──────────────────────────────────────────────────────
DATE_STR=$(date '+%Y-%m-%d-%H%M')
RUN_DIR="$REVIEW_ARCHIVE_DIR/$SKILL_NAME/$DATE_STR"
mkdir -p "$RUN_DIR"

# ── Write manifest ────────────────────────────────────────────────────────────
STARTED_AT=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
cat > "$RUN_DIR/manifest.json" <<EOF
{
  "skill": "$SKILL_NAME",
  "skill_path": "$SKILL_PATH",
  "run_dir": "$RUN_DIR",
  "started_at": "$STARTED_AT",
  "secret_count": $SECRET_COUNT
}
EOF

# ── Output JSON for Watson to consume ────────────────────────────────────────
# All paths are absolute. Watson reads reviewer templates and spawns subagents.
printf '%s\n' "$(cat <<EOF
{
  "skill_name": "$SKILL_NAME",
  "skill_path": "$SKILL_PATH",
  "run_dir": "$RUN_DIR",
  "skill_md": "$SKILL_PATH/SKILL.md",
  "reviewer_dir": "$REVIEWER_DIR",
  "reviewers": [
    "$REVIEWER_DIR/01-da.md",
    "$REVIEWER_DIR/02-security.md",
    "$REVIEWER_DIR/03-performance.md",
    "$REVIEWER_DIR/04-simplicity.md",
    "$REVIEWER_DIR/05-integration.md",
    "$REVIEWER_DIR/06-blast.md"
  ],
  "manifest": "$RUN_DIR/manifest.json",
  "secret_count": $SECRET_COUNT
}
EOF
)"
