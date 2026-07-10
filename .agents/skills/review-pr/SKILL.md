---
name: review-pr
description: Standardized PR review for senior agents (Griffin, Hag, Kavu, Levi). Produces structured feedback with a clear verdict, categorized concerns, and actionable guidance for the agent being reviewed. Covers both pre-production (pitch, game concept, risks, prototypes) and production (milestones, dailies, code, art, sound, sprint reviews) contexts.
---

# /review-pr — Senior Agent PR Review

Standardized review format for senior agents reviewing the work of other agents. This skill is used across the entire Dian process — from pre-production design reviews through production code reviews to end-of-sprint assessments.

## When to Load

This skill is used in every review gate across the process:

**Pre-production (no kanban — direct process chain):**
- @Hag reviews Capy's pitch (`pitch.md`)
- @Hag reviews Capy's game concept (`game-concept.md`)
- @Hag reviews Capy's risk analysis (`risks.md`)
- @Griffin reviews Brute's prototype code → technical validity, results of tests
- @Hag reviews Brute's prototype → can it answer the risk question?

**Production — Milestone & Daily (direct process chain):**
- @Griffin reviews Elk's milestone PR → technical feasibility, dependencies
- @Hag reviews Elk's milestone PR → design alignment, sprint ordering
- @Griffin reviews Elk's daily PR → technical priorities, blockers, pace
- @Hag reviews Elk's daily PR → vision alignment, design decisions

**Production — Implementation (kanban paired review tasks):**
- @Griffin reviews Angel's code PRs
- @Griffin reviews Jack's GUI PRs
- @Griffin reviews Imp's test PRs

**Production — Art & Sound (direct process chain):**
- @Kavu reviews Fairy's art assets PR
- @Levi reviews sprint-review PRs (sound domain)

**Production — Sprint Review (direct process chain):**
- @Griffin reviews sprint-review PR (programming side)
- @Hag reviews sprint-review PR (game design side)
- @Kavu reviews sprint-review PR (art design side)
- @Levi reviews sprint-review PR (sound design side)

## Review Workflow

### 1. Determine Your Review Context

Before diving in, identify **what** you're reviewing. The criteria differ significantly:

| Context | Phase | What to check | Kanban? |
|---|---|---|---|
| Pitch | Pre-prod | Is it compelling? Does it highlight unique selling points? Does it match the market research? | No |
| Game Concept | Pre-prod | Is the vision clear? Are core mechanics defined? Is the player fantasy coherent? | No |
| Risk Analysis | Pre-prod | Are risks genuine unknowns? Are prototype questions falsifiable? Are the highest-impact risks prioritized? | No |
| Prototype (code) | Pre-prod | Does the technical approach answer the risk question? Are the results valid? Is the PROCEED/PIVOT/KILL verdict supported? | No |
| Prototype (design) | Pre-prod | Does the prototype answer the risk question? Is the verdict correct based on playtest evidence? | No |
| Milestone | Production | Are sprints feasible? Do they respect dependencies? Do they align with the game concept? | No |
| Daily | Production | Are priorities correct? Are blockers addressed? Do decisions align with the vision? | No |
| Game Design PR | Production | Does the design deliver on the task spec? Are there internal contradictions? Is it implementable by programmers? Does it align with the game concept? | No* |
| Code PR | Production | Architecture, correctness, performance, standards compliance | Yes |
| GUI PR | Production | Does the UI match the design? Are assets used correctly? Is it functional? | Yes |
| Test PR | Production | Do tests cover the right things? Are edge cases tested? Are assertions meaningful? **Must verify all tests pass — any failing test is an automatic NEEDS REVISION.** | Yes |
| Art Assets | Production | Visual cohesion, readability, completeness | No |
| Sprint Review | Production | Domain-specific assessment of sprint output | No* |

> \\* Sprint reviews and Game Design PR reviews are normally a direct process chain step with no kanban task. However, the orchestrator (Elk) MAY create kanban review tasks for them to coordinate parallel senior reviews. When a sprint review or game-design-pass review arrives as a kanban task (status `blocked`, skills includes `review-pr`), treat it as a kanban-based review: follow Section 6.5, report the verdict redundantly (PR comment, kanban_comment, kanban_complete summary + metadata), and mark the task DONE after posting.

### 2. Read the PR

Pull the PR details (title, description, diff) and the linked design documents referenced in the PR description. Cross-reference against:
- `.docs/game-concept.md` — does the work align with the vision?
- `.docs/glossary.md` — are terms used correctly?
- `.docs/roadmap.md` — does this advance the current sprint?
- `.docs/risks.md` — (pre-production prototypes only) what risk is being tested?
- `.docs/decisions.md` — any recent decisions that affect this review?

### 3. Check Against Decisions & Glossary

**This is a mandatory checkpoint before producing your verdict.** Do not skip it.

1. Open `.docs/decisions.md` and scan the most recent entries:
   - Has a recent decision been made that affects what you're reviewing? (e.g., "we decided to use X pattern for Y" — does the PR follow it?)
   - Has a decision been reversed or superseded? (e.g., "DECISION: use `POW` over `ATK`" — does the PR use the old term?)
   - Are there decisions about scope or direction that the PR contradicts?

2. Open `.docs/glossary.md` and check every domain term in the PR:
   - Are all terms spelled and cased correctly? (`ATK` vs `Atk`, `POW` vs `Power`, `CombatController` vs `combat_controller`)
   - Are terms used with their glossary-defined meaning? (using "Turn" when the glossary defines it as a specific concept)
   - Are any new terms introduced without a corresponding glossary entry? Flag them.

3. Cross-reference both docs against the PR's diff, description, and linked design documents:
   - **Decisions conflict** → flag as a blocking issue (the work contradicts an established decision)
   - **Glossary mismatch** → flag as a blocking issue (terminology drift makes the codebase unmaintainable)
   - **Missing glossary entry for new term** → flag as a suggestion (the term should be added to glossary.md)

> **Why this matters:** `decisions.md` is the project's memory of why things are the way they are. Reviewing without it is like reading a diff without commit history. `glossary.md` is the contract for how the team talks about the game. Terminology drift — calling the same thing by different names in different files — is one of the fastest ways to make a codebase unreadable.

### 4. Produce Verdict

Exactly one of:

- **APPROVED** — ready to merge. No blocking issues.
- **NEEDS REVISION** — blocking issues must be addressed before merge.

**Hard rule for Test PRs:** If you are reviewing a test PR (Imp's PR), you MUST verify that **all tests pass** — zero failures. If any test fails, the verdict is automatically **NEEDS REVISION**. Pre-existing failures are still failures — the PR must fix them or the PR author must document why they can't be fixed and get explicit approval from the human. Do not approve a test PR with failing tests.

### 5. Write Structured Feedback

Use the sections relevant to your role and your review context. Skip sections outside your domain or irrelevant to the current context.

---

#### For Griffin (Senior Programmer)

**Production Code Review (Angel, Jack, Imp PRs):**
- **Architecture** — layering, data models, interfaces, signals, extensibility
- **Performance** — bottlenecks, memory, load concerns
- **Correctness** — edge cases, error handling, data flow
- **Standards** — naming conventions, project patterns, code organization
- **Blocking Issues** — must-fix items preventing merge
- **Suggestions** — nice-to-have improvements

**Prototype Review (Brute's prototypes):**
- **Technical Validity** — was the right prototype path chosen (Engine/HTML/Paper)?
- **Result Integrity** — are the results valid, or are there confounding factors?
- **Verdict Support** — does the technical evidence support the PROCEED/PIVOT/KILL verdict?
- **Blocking Issues** — flaws in methodology that invalidate the results
- **Suggestions** — technical improvements for the next prototype (if PIVOT)

**Milestone Review:**
- **Technical Feasibility** — can the sprints be achieved in the estimated timeframes?
- **Dependencies** — do sprints respect technical dependencies (system A before system B)?
- **Missing Groundwork** — are any sprints missing technical prerequisites?
- **Blocking Issues** — sprints that are technically impossible or missing critical steps
- **Suggestions** — reordering or scope adjustments

**Daily Review:**
- **Technical Priorities** — are the right technical tasks prioritized?
- **Blocker Assessment** — are blockers being addressed appropriately?
- **Pace** — is the development pace sustainable?
- **Blocking Issues** — critical technical concerns not addressed in the plan
- **Suggestions** — task refinement or reordering

**Sprint Review:**
- **Code Quality** — architecture consistency, technical debt assessment
- **Completeness** — does the output match the sprint's programming objectives?
- **Test Coverage** — is test coverage adequate for the features built?
- **Blocking Issues** — technical gaps that must be resolved before the next sprint
- **Suggestions** — technical improvements for the next sprint

---

#### For Hag (Senior Game Designer)

**Pre-production — Pitch Review:**
- **Compellingness** — does this pitch grab attention? Would a player want this game?
- **Unique Selling Points** — are the USPs clear and differentiated from existing games?
- **Market Alignment** — does the pitch align with the market research findings?
- **Target Audience** — is the intended audience clear and well-defined?
- **Blocking Issues** — fatal flaws in the pitch (too generic, no hook, wrong audience)
- **Suggestions** — ways to sharpen the message or highlight stronger angles

**Pre-production — Game Concept Review:**
- **Vision Clarity** — is the game's vision clear and coherent?
- **Core Mechanics** — are the mechanics well-defined and internally consistent?
- **Player Fantasy** — does the concept deliver on its promised player experience?
- **Unique Features** — are the differentiators genuine, not just buzzwords?
- **Blocking Issues** — gaps in the concept that prevent prototyping
- **Suggestions** — mechanics to expand, clarify, or reconsider

**Pre-production — Risk Analysis Review:**
- **Risk Authenticity** — are these genuine unknowns, or things already proven in other games?
- **Falsifiability** — is each prototype question falsifiable and measurable?
- **Prioritization** — are the highest-impact, highest-uncertainty risks at the top?
- **Missing Risks** — are there critical risks not identified that could kill the project?
- **Blocking Issues** — risks that are too vague to prototype or missing entirely
- **Suggestions** — additional risks to consider, sharper prototype questions

**Pre-production — Prototype Review (design side):**
- **Risk Answer** — does the prototype answer the risk question? Is the evidence clear?
- **Verdict Correctness** — is the PROCEED/PIVOT/KILL verdict correct based on playtest evidence?
- **Design Insights** — are there design insights beyond the stated hypothesis?
- **Fun Signal** — was any "fun moment" observed in playtest? Does it suggest something worth pursuing?
- **Blocking Issues** — the verdict is clearly wrong based on the evidence presented
- **Suggestions** — design refinements for the next iteration

**Production — Milestone Review:**
- **Design Alignment** — do the sprints align with the game concept's vision?
- **Player Experience Progression** — does the sprint ordering build the experience incrementally?
- **Priority Check** — are design-critical sprints deprioritized when they should be early?
- **Blocking Issues** — sprints in the wrong order or missing design-critical work
- **Suggestions** — sprint reordering, scope adjustments

**Production — Daily Review:**
- **Vision Alignment** — does today's plan advance the game's vision?
- **Design Decisions** — are any design decisions conflicting with the game concept?
- **Blocking Issues** — design problems in the plan that need immediate correction
- **Suggestions** — design refinements for today's tasks

**Production — Game Design Pass Review (Capy's PRs):**
- **Task Alignment** — does the design deliver what the task specification asked for?
- **Internal Consistency** — are there contradictions between sections of the design doc (e.g., MVP table says "no screen shake" but VFX storyboard includes it)?
- **Implementability** — can Angel and Jack build from this spec without guessing? Are dimensions, colors, z-orders, and trigger points specified?
- **Vision Alignment** — does the design advance the game concept's vision?
- **Glossary & Docs Alignment** — are terms used consistently with `.docs/glossary.md` and `.docs/game-concept.md`?
- **Blocking Issues** — contradictions, missing specifications, or design choices that conflict with established docs
- **Suggestions** — refinements, edge cases to consider, clarifications for the implementers

**Production — Sprint Review:**
- **Design Cohesion** — does the sprint output deliver the intended player experience?
- **Scope Check** — did the sprint stay within its defined design scope?
- **Decisions Audit** — are design decisions consistent and well-documented?
- **Blocking Issues** — design gaps that must be addressed before the next sprint
- **Suggestions** — design priorities for the next sprint

---

#### For Kavu (Senior Art Director)

- **Visual Cohesion** — does it fit the game's visual style?
- **Readability** — is it clear at gameplay scale?
- **Completeness** — are all art assets needed for the sprint identified or delivered?
- **Blocking Issues** — must-fix art problems preventing merge
- **Suggestions** — visual refinements

---

#### For Levi (Sound Designer)

- **Audio Cohesion** — do the sound assets fit the game's audio style and mood?
- **Completeness** — are all required audio assets for the sprint identified or delivered?
- **Quality of Descriptions** — are descriptions specific enough for a sound designer to work from?
- **Blocking Issues** — must-fix audio problems preventing merge
- **Suggestions** — audio refinements

---

### 6. Post the Review

Post the review as a PR comment using the GitHub API or `gh` CLI. See `references/gh-review-commands.md` for exact `gh pr review` commands with `--body-file`. Format:

```
## Review: @SeniorAgent (Role)

**Verdict:** APPROVED / NEEDS REVISION

### [Category]
- Concern / observation

### Blocking Issues
- [ ] Issue 1
- [ ] Issue 2

### Suggestions
- Nice-to-have 1
```

### 6.5 Complete the Kanban Task (Production Implementation Reviews)

**When this review is a kanban task (production implementation), report your verdict redundantly in THREE places** so the orchestrator can extract it reliably:

**A) `kanban_comment` — post the verdict with PR reference:**
```
kanban_comment(
    task_id=os.environ["HERMES_KANBAN_TASK"],
    body="VERDICT: APPROVED\nPR: https://github.com/<owner>/<repo>/pull/<N>\n\n<structured review feedback>",
)
```

**B) `kanban_complete` summary — include the verdict:**
```
"VERDICT: APPROVED — <one-line summary of review findings>."
```

**C) `kanban_complete` metadata — include the verdict as structured data:**
```json
{
  "verdict": "APPROVED",
  "pr_number": <N>,
  "findings": ["<summary of findings>"]
}
```

Full completion call:
```python
kanban_comment(
    task_id=os.environ["HERMES_KANBAN_TASK"],
    body="VERDICT: APPROVED\nPR: https://github.com/<owner>/<repo>/pull/<N>\n\n### Blocking Issues\n- None\n\n### Suggestions\n- <optional improvements>",
)
kanban_complete(
    summary="VERDICT: APPROVED — <one-line summary>. PR #<N> reviewed.",
    metadata={
        "verdict": "APPROVED",
        "pr_number": <N>,
        "pr_url": "https://github.com/<owner>/<repo>/pull/<N>",
        "findings": ["<summary>"],
    },
)
```

**Only for kanban-based reviews.** Direct process chain reviews (pitch, concept, milestone, daily, art, sprint review) post the PR comment only — no kanban task exists to complete.

### 7. Follow Up

**If the review was dispatched via kanban (production implementation):**
- Mark the review task as **done** in kanban — whether APPROVED or NEEDS REVISION. The PR comment is the deliverable. Report your verdict redundantly (Section 6.5: metadata, summary, comment).
- The orchestrator (Elk) handles the next step via the orchestrator_decision task:
  - APPROVED → Elk dispatches the next day task or reports completion
  - NEEDS REVISION → Elk creates a revision chain (worker revision → re-review → decision)
  - After 3 NEEDS REVISION rounds → Elk escalates to the human
- The worker's task is already DONE. No unblocking is needed.
- **Do NOT try to re-review through the same task.** If the orchestrator creates a re-review task, it will be a NEW kanban task assigned to you.

**If the review is part of the direct process chain (pre-production, milestone, daily, art, sprint review):**
- No kanban task exists — your PR comment is the deliverable.
- The process chain advances to the next step per PROCESS.md.

**Revision round limit:** Handled by the orchestrator (Elk), not the reviewer. At 3 NEEDS REVISION rounds, Elk escalates to the user. As a reviewer, you just post your honest verdict — don't pre-empt escalation.

## Pitfalls

- **Don't review outside your domain.** A senior programmer shouldn't comment on art direction unless it's a technical art issue. A sound designer reviews audio — stay in your lane.
- **Match criteria to context.** Reviewing a prototype with production code criteria (architecture, performance) is wrong — prototypes are throwaway. Reviewing production code with prototype criteria (just answer the question) is also wrong — production code must be maintainable.
- **Be specific in blocking issues.** "This needs work" is not actionable. "The damage formula doesn't account for DEF per glossary.md line 12" is.
- **Check glossary alignment.** Mismatched terminology (e.g., "ATK" vs "POW") is a blocking issue — terminology drift makes the codebase unmaintainable.
- **One verdict per review.** Don't mix APPROVED for one file and NEEDS REVISION for another — if anything is blocking, the whole PR is NEEDS REVISION.
- **Pre-production reviews don't use kanban.** Don't look for a kanban task when reviewing a pitch, game concept, risk analysis, or prototype — these are direct process chain steps.
