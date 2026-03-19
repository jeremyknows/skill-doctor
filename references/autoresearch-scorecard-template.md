# Autoresearch Scorecard Template

Copy this block into any skill's `## Autoresearch` section. Replace placeholders.

---

## Autoresearch

**Baseline:** [X/6] ([date])  
**Full health score:** [X/12]

**Scoring checklist** (run on 3–5 real outputs, not synthetic examples):

| # | Question | Pass criteria |
|---|----------|---------------|
| 1 | [Objective check 1] | YES/NO |
| 2 | [Objective check 2] | YES/NO |
| 3 | [Objective check 3] | YES/NO |
| 4 | [Objective check 4] | YES/NO |
| 5 | Voice/tone check | YES/NO |
| 6 | [Format/structure check] | YES/NO |

**Score:** [X/6] ([pass rate]%)  
**Target:** 95%+ (consistent across 3 runs)

---

**Mutation candidates** (try these when score plateaus):

1. [Mutation 1 — what to change and why]
2. [Mutation 2]
3. [Mutation 3]

**Graduation criteria:**
- Score 95%+ on 3 consecutive runs → promote mutation to canonical skill

---

**Improvement log:**

| Date | Change | Score |
|------|--------|-------|
| [date] | [description] | [X/12] |

---

## Worked Examples: Scorecard Design by Content Type

### FriendsCaps Blog Post Scorecard (from veefriends-seo)

| # | Question | Pass criteria |
|---|----------|---------------|
| 1 | Opens with product name + specific differentiator? | First sentence names the character + one factual detail |
| 2 | Section order correct? | Intro → Design Story → Product Details → Specs → CTA |
| 3 | No em dashes? | grep `—` → 0 matches |
| 4 | Pricing accurate? | Matches reference: `references/collectible-products-reference.md` |
| 5 | Voice punchy (≤12-word sentences in opener)? | First 3 sentences ≤12 words each |
| 6 | Has CTA with link? | Final paragraph includes "shop now" or equivalent with URL |

### Code Review Scorecard (from complete-code-review)

| # | Question | Pass criteria |
|---|----------|---------------|
| 1 | Each finding has file:line citation? | No finding is "in the code" without exact location |
| 2 | Confidence scores present? | Every finding has 0/25/50/75/100 score |
| 3 | Fix suggestion per finding? | No "consider improving X" without "change Y to Z" |
| 4 | Severity grouped? | Critical → Important → Minor order maintained |
| 5 | Anti-sycophancy: pushback documented? | If user pushed back, reasoning logged |
| 6 | Spec compliance checked before quality? | Stage 1 (spec) completed before Stage 2 (quality) |

### Skill Improvement Scorecard (this skill — skill-doctor)

| # | Question | Pass criteria |
|---|----------|---------------|
| 1 | Score improved after fixes? | Before/after table shows +1 or more |
| 2 | All PRISM conditions addressed? | Tier 1 conditions: 0 remaining open |
| 3 | Verification ran for each fix? | grep or read confirms each claimed fix |
| 4 | Stale references resolved? | Blast radius check confirmed clean |
| 5 | Archive written? | File exists at `analysis/prism/archive/[skill]/[date]-review.md` |
| 6 | SKILL-HEALTH-SCORES.md updated? | New score and date logged |

---

## How to Build a Scorecard for a New Skill

1. **Identify the primary output type.** What does this skill produce? (Blog post, code review, task list, config file, etc.)

2. **List what "good" looks like.** Write 8–10 criteria. Don't worry about objectivity yet.

3. **Make them binary.** Rewrite each as a yes/no question. If you can't, split it or drop it.

4. **Target 4 objective + 2 subjective.** Objective = grep-verifiable or format-checkable. Subjective = voice, tone, appropriateness. Keep subjective to ≤2 questions.

5. **Run on 3 real outputs.** If you score 6/6 on all 3 — the bar is too low. Add harder questions or use a stricter pass criteria.

6. **Document it.** Add the scorecard to `references/` in the skill directory.
