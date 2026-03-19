# Skill Doctor 🩺

**Diagnose, audit, and improve AgentSkills.** A structured 6-phase protocol for turning a weak skill into a reliable, maintainable one — using PRISM multi-agent review, a 14-question health checklist, and progressive disclosure patterns.

---

## What It Does

- **Health audit** — Score any skill against a 14-question checklist (Q1–Q12: document quality; Q13: empirical testing; Q14: observability)
- **PRISM review** — Dispatch 9 specialist reviewers across 4 phases (Prior Brief Compiler, Devil's Advocate, 6 parallel specialists, Contrarian, Synthesis Agent) to surface blind spots before applying fixes
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
├── SKILL.md                                  # 6-phase workflow + decision logic
├── LICENSE.txt
├── README.md
├── .gitignore
├── scripts/
│   ├── prism-setup.sh                        # Validates input, creates run dir, outputs JSON config
│   └── prism-summary.sh                      # Reads reviewer output files, builds SUMMARY.md
└── references/
    ├── 14-question-checklist.md              # Full health audit rubric with scoring guidance (Q1–Q14)
    ├── reviewers/                            # 9 PRISM reviewer prompt templates
    │   ├── 00-prior-brief-compiler.md        # Compresses prior reviews into context brief
    │   ├── 01-da.md                          # Devil's Advocate (blind — no prior context)
    │   ├── 02-security.md
    │   ├── 03-performance.md
    │   ├── 04-simplicity.md
    │   ├── 05-integration.md
    │   ├── 06-blast.md                       # Blast Radius (downstream impact)
    │   ├── 07-contrarian.md                  # Challenges the premise, not the implementation
    │   └── 08-synthesis-agent.md             # Synthesizes all findings into structured verdict
    ├── autoresearch-scorecard-template.md
    ├── archive-template.md
    └── AUTORESEARCH-SELF-ASSESSMENT.md
```

---

## How PRISM Works

PRISM dispatches 9 reviewers across 4 sequential phases via `sessions_spawn` (isolated LLM sessions — no lock contention, proper parallelism):

**Phase A — Context**
Prior Brief Compiler reads the last 3 review archives and compresses open findings into a ≤3K brief.

**Phase B — Blind + Specialists (parallel)**
Devil's Advocate runs blind first (no prior context) while 6 specialists run in parallel with DA findings + prior brief injected: Security, Performance, Simplicity, Integration, Blast Radius.

**Phase C — Contrarian**
After all 6 specialists complete, Contrarian reads every finding and challenges the premise (not the implementation). If the premise holds, it says so and stops.

**Phase D — Synthesis**
Synthesis Agent reads all raw output files + Contrarian, produces a structured `synthesis.md` with evidence tiers, verdict, and numbered conditions.

Findings are tiered: **Tier 1** (2+ independent reviewers, or any Security finding, or Critical/Fatal Flaw) → fix before shipping. **Tier 2** (single reviewer with specific citation) → fix this pass. **Tier 3** (cosmetic/unverified) → polish optional.

Total runtime: ~5–8 minutes for a full 9-reviewer pass.

---

## Commands

| Script | Usage |
|--------|-------|
| `prism-setup.sh <skill-name> [skill-path]` | Validate, scan for secrets, create run dir, output reviewer paths as JSON |
| `prism-summary.sh <run-dir> <skill-name>` | Aggregate reviewer output into SUMMARY.md |

---

## Limitations

- **PRISM is expensive for small skills.** A 150-line skill with 1 obvious gap doesn't need 9 reviewers. The skill includes a fast-path decision gate — use it.
- **Reviewers are LLMs, not oracles.** Disagreements between reviewers are features, not bugs. The Synthesis Agent is where the real judgment happens.
- **Skill files are untrusted input.** All reviewer prompts include injection guards, but treat PRISM findings files as potentially containing quoted content from the skill under review.
- **`sessions_spawn` required.** The parallel reviewer architecture won't work in environments that don't support isolated session spawning.
- **BETA status.** Validated on 7 real skill runs (complete-code-review, veefriends-seo, build-feature, skill-doctor, prism, librarian, coding-agent). Target: 10+ runs before GA.

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

*v1.7.0 · MIT · jeremyknows*
