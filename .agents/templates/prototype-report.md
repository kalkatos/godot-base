# Prototype Report: [Prototype Name]

> **Date**: [YYYY-MM-DD]
> **Slug**: [prototype-folder-name]

---

## Hypothesis

[The falsifiable hypothesis this prototype set out to test:
"If the player [does X], will they feel [Y] — evidenced by [measurable signal Z]."]

---

## Riskiest Assumption Tested

[What was identified as the biggest risk, and whether it proved out. Reference risks.md if applicable.]

---

## Approach

[What was built, how long it took, what shortcuts were taken deliberately.]

**Shortcuts taken (intentional):**
- [e.g., hardcoded values, placeholder art, no menus, monolith script, etc.]

---

## Result

[What actually happened — specific observations, not opinions. Quote playtesters
directly where possible.]

---

## Metrics

| Metric | Value |
|--------|-------|
| Prototype duration | [e.g., 4 hours] |
| Playtesters | [N internal / N external] |
| Feel assessment | [Specific — "response felt sluggish at 200ms" not "felt bad"] |
| Hypothesis verdict | [CONFIRMED / PARTIALLY CONFIRMED / REFUTED] |

---

## Recommendation: [PROCEED / PIVOT / KILL]

[One paragraph explaining the recommendation with evidence from the result above.]

---

## If Proceeding

[What the prototype revealed that should directly inform production:]

- **Core tuning values discovered:** [e.g., "jump height of 3.5 units felt best"]
- **Assumptions confirmed:** [What the concept doc assumed that proved true]
- **Assumptions disproved:** [What the concept doc assumed that proved wrong]
- **Emergent mechanics:** [Behaviors that appeared during testing worth formalizing]

**Next step:** Run `/milestone` to start the Production phase, or `/prototype` to test another risk.

---

## If Pivoting

[What alternative direction the results suggest — what felt almost right and what
to adjust. Be specific about what to change, not just that something needs changing.]

**Pivot direction:** [What to try differently]
**What to keep:** [What worked and should be preserved]
**Next step:** `/prototype [revised-target]`

---

## If Killing

[Why this concept does not work — what specific signal led to this verdict.
This report is the deliverable; no further action needed on this concept.]

**Next step:** Return to `/game-concept` with a new direction.

---

## Lessons Learned

[What this prototype taught that applies beyond this specific concept.]

- **What assumptions were broken by actually building this?**
  [...]

- **What surprised us that didn't show up in the brainstorm?**
  [...]

- **What would we test differently next time?**
  [...]

---

> *Prototype code location: `prototypes/[concept-name]-concept/`*
> *This code is throwaway. Never refactor into production.*
