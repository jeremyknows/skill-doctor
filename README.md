# Skill Doctor 🩺

**Diagnose, audit, and improve AgentSkills.** A structured 6-phase protocol for turning a weak skill into a reliable, maintainable one — using PRISM multi-agent review, a 14-question health checklist, and progressive disclosure patterns.

---

## What It Does

- **Health audit** — Score any skill against a 14-question checklist (trigger conditions, gotchas, dependencies, progressive disclosure, autoresearch loop, and more)
- **PRISM review** — Dispatch 6 specialist reviewers in parallel (Devil's Advocate, Security, Performance, Simplicity, Integration, Blast Radius) to surface blind spots before applying fixes
- **Prescribe & fix** — Synthesize reviewer findings into tiered conditions; apply only what's needed
- **Verify** — Re-audit post-fix; confirm the score improved
- **Archive** — Write a PRISM archive so future auditors know what was already reviewed

---

## Install

```bash
# Claude Code / OpenClaw
git clone https://github.com/jeremyknows/skill-doctor ~/.openclaw/skills/skill-doctor
```

Or install via [ClawHub](https://clawhub.com):
```bash
clawhub install skill-doctor
```

---

## Setup

No external tools required beyond the OpenClaw runtime. The PRISM scripts use `sessions_spawn` for parallel reviewer dispatch — no OpenAI API key or additional credentials needed.

Optional: `sub-agent-complete.sh` for bus event emission on Phase 6 (included in OpenClaw).

---

## Usage

### Natural language

```
Audit the veefriends-seo skill and show me the gaps
Run PRISM on coding-agent
Health check the librarian skill
Improve complete-code-review — it scored 7/12 last time
```

### Phase selector (for experienced use)

| Situation | Start at |
|-----------|----------|
| Never audited | Phase 1 — Diagnose |
| Score ≥ 9, gaps obvious | Phase 4 — Fix |
| Score ≤ 7 | Phase 2 — PRISM |
| PRISM done, conditions known | Phase 4 — Fix |
| Fixes applied | Phase 5 — Verify |
| Just archiving | Phase 6 — Archive |

---

## What's in the Box

```
skill-doctor/
├── SKILL.md                          # 6-phase workflow + decision logic
├── LICENSE.txt
├── README.md
├── .gitignore
├── scripts/
│   ├── prism-setup.sh                # Validates input, creates run dir, outputs JSON config
│   └── prism-summary.sh              # Reads reviewer output files, builds SUMMARY.md
└── references/
    ├── 12-question-checklist.md      # Full health audit rubric with scoring guidance
    ├── reviewers/                    # 6 individual PRISM reviewer prompt templates
    │   ├── 01-da.md                  # Devil's Advocate (blind)
    │   ├── 02-security.md
    │   ├── 03-performance.md
    │   ├── 04-simplicity.md
    │   ├── 05-integration.md
    │   └── 06-blast.md
    ├── autoresearch-scorecard-template.md
    ├── archive-template.md
    └── AUTORESEARCH-SELF-ASSESSMENT.md
```

---

## How PRISM Works

PRISM dispatches 6 reviewers in parallel via `sessions_spawn` (isolated LLM sessions — no lock contention, proper parallelism):

1. **Devil's Advocate** runs blind first — finds fatal flaws without anchoring to other opinions
2. **5 specialists** run in parallel with DA findings injected — Security, Performance, Simplicity, Integration, Blast Radius
3. Findings are tiered: Tier 1 (fix before shipping) → Tier 2 (fix this pass) → Tier 3 (polish)
4. Watson synthesizes, applies fixes, re-audits

Total runtime: ~3–5 minutes for a full 6-reviewer pass.

---

## Commands

| Script | Usage |
|--------|-------|
| `prism-setup.sh <skill-name> [skill-path]` | Validate, scan for secrets, create run dir |
| `prism-summary.sh <run-dir> <skill-name>` | Aggregate reviewer output into SUMMARY.md |

---

## Limitations

- **PRISM is expensive for small skills.** A 150-line skill with 1 obvious gap doesn't need 6 reviewers. The skill includes a fast-path decision gate — use it.
- **Reviewers are LLMs, not oracles.** Disagreements between reviewers are features, not bugs. The synthesis step is where the real judgment happens.
- **Skill files are untreated input.** All reviewer prompts include injection guards, but treat PRISM findings files as potentially containing quoted sensitive content from the skill under review.
- **`sessions_spawn` required.** The parallel reviewer architecture won't work in environments that don't support isolated session spawning.
- **BETA status.** Validated on 6 real skill runs (complete-code-review, veefriends-seo, build-feature, prism, librarian, coding-agent). Graduate to GA after 10+ runs.

---

## After Improving a Skill

If you're preparing the improved skill for GitHub, run [`publish-skills`](https://clawhub.com/skills/publish-skills) next:

```
Run publish-skills checklist on skill-doctor
```

publish-skills covers: frontmatter spec compliance, LICENSE.txt, README patterns, consistency review, and GitHub verification steps. skill-doctor improves quality; publish-skills prepares for release.

---

## Related Skills

| Skill | When to use |
|-------|-------------|
| `skill-creator` | Creating a new skill from scratch |
| `publish-skills` | Prepping an improved skill for GitHub |
| `complete-code-review` | Reviewing software code (not skill files) |
| `prism` | Full PRISM protocol reference |

---

*v1.4.0 (BETA) · MIT · jeremyknows*
