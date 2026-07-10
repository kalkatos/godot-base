---
name: do-market-research
description: "Use when you need to research the current game market — trending genres, themes, competitor analysis, and potential niches. @Dino (marketer): searches the web, analyzes findings, and writes a market-research report to inform the pitch."
version: 2.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, pre-production, research, market]
    related_skills: [generate-pitch]
---

# /do-market-research — Market Research for Game Development

## Overview

This skill runs market research for a game project. As **@Dino (marketer)**, you search the web for trending game genres, themes, audience preferences, and competitive landscape data. The output is a dated market research document that feeds directly into the pitch generation step.

This is step 1 of the Agentic Gamedev Process (Pre-production phase).

## When to Use

- At the start of a new game project before any concepting
- When pivoting to a new genre or market and need fresh data
- As part of the full pre-production pipeline: `do-market-research` → `generate-pitch` → `start` → `analyze-risks` → `prototype`

## Workflow

### 1. Determine the Project Root

- Read the active workspace directory from the session context.
- Look for a Godot project by checking for `project.godot` or `src/project.godot`.
- If a Godot project is found, use its `.docs/` directory for output. Otherwise, ask the user to specify the project root.
- Store the project root for this session.

### 2. Gather the Research Scope

If the user provided a genre, theme, or hint as an argument, use that as the initial scope. Otherwise, ask:

> "What genre(s) or theme(s) are you considering for this game? Any specific direction you want me to focus the research on?"

Use the user's answer to focus the web searches. If the user is wide open, research broadly across trending indie game genres.

### 3. Conduct Web Research

Search for and extract information on these topics. Run searches in parallel where possible:

- **Genre trends:** Search for "trending indie game genres 2025 2026" and "best selling indie game genres Steam". Extract the current state, growth/decline signals, and notable recent releases for 2-3 relevant genres.
- **Theme & aesthetic trends:** Search for "popular game themes 2025" and "game aesthetic trends". Note what's fresh vs oversaturated.
- **Target audience:** Search for communities around the identified genres — subreddits, Discord servers, Steam reviews. What are players asking for and complaining about?
- **Competitive landscape:** For the most relevant genre, search for "best [genre] games Steam 2024 2025". Identify 3-5 key competitors and note their strengths and gaps.

### 4. Synthesize Findings

Review all collected data. Identify:
- **3-5 potential niches or opportunities** where there is clear market demand but insufficient supply
- **The single most promising direction** that combines market opportunity with feasibility for a solo indie developer

### 5. Write the Market Research Document

Read the template at `.agents/docs/templates/market-research-template.md` from the project root and use it as the document structure. Fill in every section with real data from the research.

Write the output to `.docs/market-research-<short-description>-<date>.md` where:
- `<short-description>` is a 2-4 word hyphenated summary (e.g., `roguelike-card-battler`)
- `<date>` is today's date in YYYY-MM-DD format

### 6. Report Completion

Return a summary including:
- The most promising niche identified
- The top 2-3 competitors and their key gaps
- The path to the written document
- Reminder: "Next step: @Capy runs `/generate-pitch` to create an elevator pitch from these findings."

## Common Pitfalls

1. **Searching too narrowly.** Don't only look at one genre. Cross-genre hybrids are often where the best opportunities are.
2. **Summarizing without citing.** Always note where findings came from — specific games, community posts, articles.
3. **Over-researching.** This is a lean process. 30-45 minutes of research is enough. Don't spend hours chasing every data point.
4. **Ignoring the indie perspective.** Filter findings through the lens of a solo developer — what's feasible with limited resources?
5. **Forgetting to date the document.** The filename must include the date for later reference.

## Verification Checklist

- [ ] Project root identified (`.docs/` directory exists or created)
- [ ] Web searches cover genres, themes, audience, and competitors
- [ ] 3-5 niches/opportunities identified with supporting evidence
- [ ] Output written to `.docs/market-research-<short-desc>-<date>.md`
- [ ] All template sections filled (no placeholder text remaining)
- [ ] Completion summary includes next step reminder
