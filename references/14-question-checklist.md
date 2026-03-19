# 14-Question Skill Health Checklist

**Source:** Watson's Skills Intelligence System, synthesized from Thariq/Anthropic research + Watson operational experience.

Score each question: **YES** (1.0) | **PARTIAL** (0.5) | **NO** (0) | **N/A** (excluded from denominator)

---

## The 12 Questions

### Q1 — Trigger Conditions
**"Does the description field read as trigger conditions, not a summary?"**

✅ YES: Lists specific scenarios, phrases, or use cases. User can determine from description alone whether to invoke.
⚠️ PARTIAL: Has some triggers but also has summary text mixed in.
❌ NO: Describes what the skill does, not when to use it.

**Fix:** Rewrite description as: "Use when: (1)... (2)... NOT for: ..."
**Size constraint:** Cowork plugin loads ALL descriptions always. Keep under ~200 chars or it eats context budget.

---

### Q2 — Gotchas Section
**"Are there Gotchas / Known Limitations sections for non-obvious behavior?"**

✅ YES: Explicit `## Known Limitations & Gotchas` or `## Gotchas` section with specific footguns.
⚠️ PARTIAL: Has a "Common Mistakes" or similar, but warnings are scattered rather than consolidated.
❌ NO: Warnings exist only inline throughout the skill, or no warnings at all.

**Why this matters:** Gotchas sections are the highest-signal content for autoresearch. They enable objective pass/fail scoring.

---

### Q3 — Progressive Disclosure
**"Is the file system used for progressive disclosure?"**

✅ YES: Has `references/`, `scripts/`, or `examples/` subdirectory with supporting content. Core SKILL.md is lean.
⚠️ PARTIAL: References to external files exist but directory structure not fully utilized.
❌ NO: All content in one monolithic SKILL.md.

**Threshold:** Extract to references/ when SKILL.md > 500 lines or when sections are pure boilerplate.

---

### Q4 — Avoids Railroading
**"Does the skill avoid over-specifying when Claude should act?"**

✅ YES: Provides principles and decision frameworks. Claude exercises judgment.
⚠️ PARTIAL: Some rigid "ALWAYS/NEVER" language but mostly principle-based.
❌ NO: "Iron Law" / extensive NEVER lists / forces specific sequences without allowing judgment.

**Fix:** Replace "NEVER do X" with "Prefer Y over X because Z". Keep hard NEVER only for safety-critical rules.

---

### Q5 — Config State
**"If the skill has user-configurable state, is it stored in config.json or plugin data?"**

✅ YES: Uses `${CLAUDE_PLUGIN_DATA}` or `config.json` for persistent state.
❌ NO: Hardcodes user-specific values in SKILL.md.
**N/A:** Skill has no persistent state requirements. (Most skills are N/A here.)

---

### Q6 — Scripts/Helpers
**"Are there scripts or code libraries that Claude can discover and use?"**

✅ YES: Has `scripts/` directory with helper scripts, or references/ has executable templates.
❌ NO: Skill is pure guidance text; no bundled code.

**Note:** This is often N/A for conceptual/workflow skills. Only mark NO if scripts would genuinely add value.

---

### Q7 — Output Scoreability
**"Can you define a yes/no checklist for the skill's outputs?"**

✅ YES: Clear output format with checkable criteria (section order, required fields, length constraints).
⚠️ PARTIAL: Some objective criteria but quality is partly subjective.
❌ NO: Output quality is entirely judgment-based with no checkable criteria.

**Fix:** Add a scorecard in `references/` — 4–6 yes/no questions that an agent can run on any output.

---

### Q8 — 9-Category Fit
**"Does the skill fit cleanly into one of Thariq's 9 categories?"**

| # | Category | Examples |
|---|----------|---------|
| 1 | Library/API Reference | veefriends-seo, weather, bluebubbles |
| 2 | Code Scaffolding | build-feature, test-driven-development |
| 3 | Data Fetching & Analysis | librarian, gog, last30days |
| 4 | Code Quality & Review | complete-code-review, skill-doctor, prism |
| 5 | Business Process Automation | gh-issues, x-engage, ordercli |
| 6 | Runbooks | restart-mc, emergency-commands, node-connect |
| 7 | Product Verification | verification-before-completion, receiving-feedback |
| 8 | CI/CD | commit-commands, github |
| 9 | Infra Ops | healthcheck, tmux, 1password |

✅ YES: Fits one category cleanly.
⚠️ PARTIAL: Spans two adjacent categories (document both in frontmatter).
❌ NO: Doesn't fit any category — reconsider scope.

---

### Q9 — Trigger Specificity
**"Is the skill triggered only when genuinely useful?"**

✅ YES: Trigger conditions are specific enough that over-triggering is unlikely.
⚠️ PARTIAL: Description is broad enough it could fire on tangentially related requests.
❌ NO: Trigger is so generic it will fire on many unrelated requests.

**Check:** Read the description and ask "would this trigger on something I don't want it to?"

---

### Q10 — Examples
**"Are there worked examples, reference code, or output templates?"**

✅ YES: Has at least one concrete example — full input→output, or output template with real values.
⚠️ PARTIAL: Has structural examples (section names) but no filled-in content.
❌ NO: No examples anywhere.

---

### Q11 — Dependencies Documented
**"Are dependencies (tools, skills, scripts) formally documented?"**

✅ YES: Has `## Dependencies` section listing all required tools, companion skills, and scripts.
⚠️ PARTIAL: Dependencies mentioned inline but not consolidated.
❌ NO: Dependencies assumed without documentation.

---

### Q12 — Verification Hooks
**"Does the skill include verification steps or hooks for confirming output quality?"**

✅ YES: Has a verification phase, checklist, or specific commands to confirm the skill worked.
⚠️ PARTIAL: Some verification guidance but not systematic.
❌ NO: Skill ends without any "did it work?" confirmation step.

---

### Q13 — Empirical Testing
**"Has this skill been run on 3+ real inputs and scored for output quality?"**

✅ YES: Improvement log or autoresearch section documents runs on real inputs with before/after quality scores.
⚠️ PARTIAL: Run on real inputs but no quality scoring; or synthetic examples only.
❌ NO: Skill has never been run operationally, or only tested on itself.

**Why this matters:** Document quality (Q1–Q12) is necessary but not sufficient. A skill can score 10/12 and still fail silently in production. This question catches the gap. New skills start NO — that's expected. The goal is moving to PARTIAL within 2 weeks of deployment.

**Validation threshold:** Run on 3–5 distinct real inputs. Grade each output on the skill's own scorecard (Q7). If scoring criteria don't exist, that's a Q7 failure first.

**Template:** See `references/autoresearch-scorecard-template.md` for a blank run-log template to fill in.

---

### Q14 — Observability
**"Does the skill have hooks to detect failures in production?"**

✅ YES: Skill emits bus events on completion, logs outputs to a checkable location, or includes a built-in health check command.
⚠️ PARTIAL: Some outputs are logged but failures are silent; no alerting.
❌ NO: Skill produces outputs with no trail — failures are invisible until someone notices.

**Fix:** At minimum, emit `sub-agent-complete.sh` at the end of each run. Better: log a run summary with pass/fail indicators to a known path. Best: include a quick health-check command in the skill that validates a recent output.

**Example:** See `references/AUTORESEARCH-SELF-ASSESSMENT.md` for a worked observability implementation.

**Note:** This is often N/A for simple utility skills. Only mark as a real gap if the skill is in production for high-stakes workflows (content generation, external communications, code review).

---

## Scoring Table Template

```markdown
| # | Question | Answer | Rationale |
|---|----------|--------|-----------|
| Q1 | Description as trigger conditions? | YES/PARTIAL/NO/N/A | |
| Q2 | Gotchas section? | | |
| Q3 | Progressive disclosure? | | |
| Q4 | Avoids railroading? | | |
| Q5 | Config state correct? | | |
| Q6 | Scripts/helpers? | | |
| Q7 | Output scoreable? | | |
| Q8 | 9-category fit? | | |
| Q9 | Not over-triggered? | | |
| Q10 | Examples present? | | |
| Q11 | Dependencies documented? | | |
| Q12 | Verification hooks? | | |
| Q13 | Empirical testing (3+ real runs scored)? | | |
| Q14 | Observability (bus events / run log)? | | |

**Score:** X/14  (new skills: N/A Q13 and Q14, score out of 12 until first real runs)
**Gaps:** [list NO and PARTIAL items]
```
