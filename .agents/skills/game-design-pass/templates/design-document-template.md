# [Mechanic Name] — Design Document

**Status:** Draft
**Task:** <task-id>
**Date:** YYYY-MM-DD
**Game:** <from game-concept.md title>
**Related Docs:** <links to related design docs, game-concept.md, glossary entries>

---

## 1. Design Intent

> 2-3 sentences on what this mechanic should achieve for the player experience.

## 2. Player Experience

> Walk through the mechanic from the player's perspective. What do they see, hear, feel? What decisions do they make? What feedback do they receive?

## 3. Design Theory

> Cite 2-5 books/lenses from the Knowledge Library (see /game-design-pass SKILL.md) and explain how they informed specific decisions.
>
> Example:
> - **Game Feel (Book 6):** The parry window is set to 200ms because Swink's research shows this is the sweet spot for "tight but fair" action responses.
> - **A Theory of Fun (Book 4):** The damage formula uses diminishing returns on stacking to ensure the player must grok new patterns rather than repeating the same optimal rotation.

## 4. Competitive Context

> What did the competitive research reveal? What are the existing solutions, and how does this design differ?
>
> - **Benchmark:** [Game X] handles this by [approach]. Strengths: [...]. Weaknesses: [...].
> - **Our differentiation:** [What's different and why]

## 5. Specification

> The concrete, implementable design. Use sub-sections appropriate to the mechanic type.

### 5.1 Variables & Configuration

| Variable | Type | Default | Min | Max | Description |
|----------|------|---------|-----|-----|-------------|
| `example_var` | float | 10.0 | 0 | 100 | Description of what this controls |

### 5.2 Mechanics / Rules

> Step-by-step rules in unambiguous language. Use bullet points, numbered steps, or pseudocode.
>
> 1. When [trigger condition], [action].
> 2. Then [consequence].
> 3. The result is [output].

### 5.3 Edge Cases

> What happens when:
> - [Edge case 1] → [Expected behavior]
> - [Edge case 2] → [Expected behavior]
> - [Edge case 3] → [Expected behavior]

### 5.4 Balancing Notes

> Initial values and the reasoning behind them. How to tune. What levers exist for adjustment.

## 6. Integration

> How does this mechanic connect to other systems?
>
> - **Input from:** [systems that feed into this one]
> - **Output to:** [systems this one affects]
> - **Glossary terms:** [new or updated terms to add to glossary.md]

## 7. Implementation Notes

> Guidance for @Angel (programmer) and @Jack (GUI):
>
> - **Project location:** Where in `src/` this should live
> - **Existing hooks:** Which systems to integrate with
> - **Performance:** Any concerns (e.g., many entities, frequent updates)
> - **Deferrable:** What CAN be deferred (MVP vs. polish)

## 8. Playtest Questions

> What should we test to validate this design?
>
> - [Falsifiable question 1]
> - [Falsifiable question 2]
> - [Falsifiable question 3]
