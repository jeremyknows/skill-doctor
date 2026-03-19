# skill-doctor Self-Assessment (Autoresearch)

Extracted from SKILL.md v1.4. Last updated: 2026-03-18.

---

## Q1–Q14 Scoring (v1.4)

| # | Question | Answer | Rationale |
|---|----------|--------|-----------|
| Q1 | Description as trigger conditions? | YES | Lists 5 specific use cases + NOT FOR list |
| Q2 | Gotchas section? | YES | Explicit Known Limitations & Gotchas section, 10 entries |
| Q3 | Progressive disclosure? | YES | references/reviewers/, 12-question-checklist, autoresearch, archive-template, prism-templates |
| Q4 | Avoids railroading? | YES | Phase gates are decision frameworks, not iron laws |
| Q5 | Config state correct? | N/A | No persistent state |
| Q6 | Scripts/helpers bundled? | YES | prism-setup.sh, prism-summary.sh, review-common.sh |
| Q7 | Output scoreable? | YES | Before/after score table; PRISM verdict table |
| Q8 | 9-category fit? | YES | Code Quality & Review |
| Q9 | Not over-triggered? | YES | Very specific triggers |
| Q10 | Examples present? | YES | Worked example (build-feature Phase 1→6) |
| Q11 | Dependencies documented? | YES | Full Dependencies section |
| Q12 | Verification hooks? | YES | Phase 5 explicit |
| Q13 | Empirical testing? | PARTIAL | 3 skills run this session; no formal output scoring |
| Q14 | Observability? | PARTIAL | sub-agent-complete.sh on Phase 6; no structured run log |

**Score:** 11.5/14 (12/12 on original checklist, 82% on extended checklist)

---

## Worked Example — build-feature Audit (Phase 1→6)

| Phase | Action | Result |
|-------|--------|--------|
| P1: Diagnose | Read SKILL.md (528 lines), `grep "^## "`, `ls references/` | Score: 7/12. Gaps: broken spawn params, no complexity gate, broken refs, stale doc names |
| P2: PRISM R1 | 6 agents in parallel, DA blind | All APPROVE WITH CONDITIONS. Integration found invalid `model=` in 6 spawn calls. Blast found 11 stale docs. |
| P3: Prescribe | Tier 1: broken spawn syntax (Integration, 2 reviewers); Tier 2: complexity gate, broken refs | 7 conditions total |
| P4: Fix | Fixed spawn params, added Complexity Gate, removed broken git-worktrees refs, added completion emit, updated 5 docs | 528 lines → extracted spawn-templates.md → 350 core lines |
| P5: Verify | `grep -E "model=\|max_depth="` → 0 hits. `ls references/` → spawn-templates.md present. | Score: 10/12 ✅ |
| P6: Archive | Written to `analysis/prism/archive/build-feature/2026-03-18-review.md` | SKILL-HEALTH-SCORES.md updated |

---

## Improvement Log

| Date | Version | Change | Score |
|------|---------|--------|-------|
| 2026-03-18 | v1.0 | Initial creation, synthesized from full-day improvement work on 3 skills | 10/12 |
| 2026-03-18 | v1.1 | PRISM R1: security guards (injection, secrets, trust model), fast-path checklist, worked example, registry entries | 10/12 |
| 2026-03-18 | v1.2 | Bash orchestrator (prism.sh + review-common.sh): timeout handling, parallel fan-out, auto path detection. Reviewer templates split to references/reviewers/ | 10/12 |
| 2026-03-18 | v1.3 | Root cause fix: replaced `openclaw agent --local` (session-lock contention) with `sessions_spawn` for LLM fan-out. Bash now handles only deterministic scaffolding. prism.sh split into prism-setup.sh + prism-summary.sh. review-common.sh v2.0 | 10/12 |
| 2026-03-18 | v1.4 | PRISM dogfood (skill-doctor on skill-doctor): added Q13+Q14 to checklist, Phase 3.5 gate, Phase 6b stalled detection, high-traffic definition, consensus resolution rules, extracted autoresearch self-assessment to references/ | 10/12 |
