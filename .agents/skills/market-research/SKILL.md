---
name: market-research
description: 'Conduct market research to identify genre trends, target audiences, and competitive landscape. Use when: analyzing a game idea''s market viability, researching genre/theme trends, identifying underserved niches, filling in .docs/market-research-*.md, or invoking /market-research. Part of the Agentic Gamedev Process pre-production phase, but usable standalone anytime.'
argument-hint: '[pitch, genre/theme combo, or leave blank to explore]'
user-invocable: true
---

# /market-research — Market Research

## Overview

Produces a structured market research report from a user-provided idea (pitch, genre/theme combo, or nothing). Through light triage, hybrid research (model knowledge + optional web enrichment), and a sanity check, writes `market-research-<slug>-<date>.md` following the template in `.agents/templates/market-research-template.md`.

Part of the Agentic Gamedev Process (Pre-production phase), but headless — usable standalone, not bound to the current project. Output is optionally consumed by `/game-concept`.

## When to Use

- User invokes `/market-research` with a pitch, genre idea, or blank
- User wants to validate market viability of a game idea
- User wants to explore genre trends or find underserved niches
- Do NOT use for: mid-development competitive analysis of specific features (that's a design task)

## Workflow

### 1. Load Context

- Read `.agents/templates/market-research-template.md` as the output schema. Fill sections flexibly — include what's relevant, flag what's skipped with a brief reason.
- Scan `.docs/market-research-*.md` for prior reports. Note them for the lineage summary.
- If `.docs/game-concept.md` exists, read it for the current project's genre/theme context (informational only — not binding).

### 2. Triage — Scope the Research

Based on what the user provided, do **at most 2 questions** to narrow scope:

- **If user gave a concrete pitch:** Confirm the primary genre. "I see this as a [genre]. Does that sound right?" Then proceed.
- **If user gave a loose genre/theme:** "Any specific themes or tones you're leaning toward, or should I explore broadly?" Then proceed with whatever they give.
- **If user gave nothing:** "What genre or theme are you considering? (e.g., roguelike deckbuilder, cozy farming sim, cosmic horror FPS)" Then proceed.

Derive a short slug from the confirmed scope (e.g., `roguelike-deckbuilder`, `cozy-farming`). Use today's date for the filename: `market-research-<slug>-<date>.md`.

### 3. Research — Hybrid Approach

**Phase A — Model Knowledge (always):** Use training data to fill the template sections:

- **Genre Trends:** For each relevant genre (1-3, as applicable): current state, notable recent releases, player expectations, opportunity. If only one genre is relevant, fill one — don't pad.
- **Theme & Aesthetic Trends:** What's trending, oversaturated, or fresh in the relevant aesthetic space. Skip if not applicable.
- **Target Audience:** Primary audience profile, underserved audiences, community sentiment.
- **Competitive Landscape:** Table of 3-5 competitors with genre, key strength, weakness/gap, and our opportunity.
- **Potential Niches & Opportunities:** 2-4 promising niches based on gaps identified.
- **Recommendation:** One paragraph synthesizing findings into a clear direction.
- **Sources:** List sources used (model knowledge acknowledged as such).

**Phase B — Web Enrichment (opportunistic):** Use `fetch_webpage` to supplement specific data points. Attempt these lookups in priority order, but do not block — if any fail or timeout, proceed with model knowledge alone and note it:

1. **SteamDB or Steam Charts** — current player counts, saturation signals for the genre (e.g., how many similar games released recently, price distribution).
2. **Relevant subreddit or forum** (e.g., r/roguelikes, r/cozygames, r/IndieDev) — community sentiment, common complaints about existing games in the genre, what players are asking for.
3. **Metacritic / OpenCritic** — recent notable releases in the genre, critic vs. user score gaps that signal unmet expectations.
4. **Steam tags / "More Like This"** — for a key competitor, check what games Steam recommends as similar; reveals how the platform categorizes the genre and what adjacent niches exist.

If all lookups fail or are skipped, add a note: "Web enrichment not available — findings based on model knowledge as of [training cutoff]."

### 4. Sanity Check — Before Writing

Self-check the draft against these criteria. Flag any concerns to the user but do not block:

- **Completeness:** Are the filled sections meaningful? If a section was skipped, is the reason noted?
- **Recommendation grounded:** Does the recommendation follow from the findings, or is it a leap?
- **Specificity:** Are competitor names and genre trends concrete, not generic?
- **Sources:** Are knowledge sources acknowledged?

### 5. Write the Document

Write to `.docs/market-research-<slug>-<date>.md`. Create the `.docs/` directory if it doesn't exist.

At the top of the report, before the summary, add a lineage note if prior reports exist:

```
> **Prior research:** `roguelike-deckbuilder-2026-06-15.md` (competitive landscape), `cozy-farming-2026-07-01.md` (audience analysis)
```

Follow the template structure flexibly. Every section that is included must have meaningful content. Sections that are skipped must have a brief reason noted (e.g., "Theme trends not applicable — focus is purely mechanical.").

### 6. Report Completion

Return a summary including:

- The slug and date used
- Key finding (one sentence from the Recommendation)
- The path to the written document
- Next steps: "Optional: run `/game-concept` to turn these findings into a concrete game concept. The `/game-concept` skill will automatically pick up this research."

## Common Pitfalls

1. **Forcing three genres.** If the scope is narrow, one well-researched genre is better than three thin ones. Note why others were skipped.
2. **Generic competitor table.** "Game A, Game B, Game C" is useless. Name real, specific games and pinpoint real gaps.
3. **Unanchored recommendation.** The recommendation must trace back to data in the report, not be a random opinion.
4. **Over-interviewing.** The triage is 1-2 questions max. Don't replicate `/game-concept`'s full anchor interview.
5. **Skipping the lineage note.** Prior reports must be listed so the research trail is visible.
6. **Web scraping as blocker.** If `fetch_webpage` fails or is slow, proceed without it. Model knowledge alone is sufficient.

## Verification Checklist

- [ ] Template loaded: `.agents/templates/market-research-template.md`
- [ ] Prior reports scanned and lineage noted
- [ ] Scope triaged (1-2 questions max)
- [ ] Slug derived from confirmed scope
- [ ] Model knowledge research completed for all applicable sections
- [ ] Web enrichment attempted (non-blocking)
- [ ] Sanity check passed (gaps flagged, not blocked)
- [ ] Sections filled flexibly — meaningful content or skipped with reason
- [ ] Output written to `.docs/market-research-<slug>-<date>.md`
- [ ] Next steps reminder included
