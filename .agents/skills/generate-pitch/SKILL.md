---
name: generate-pitch
description: "Use when you need to create a short, compelling elevator pitch for a game based on market research. @Capy (game designer): reads market research, synthesizes a pitch with unique selling points, and writes pitch.md."
version: 2.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, pre-production, design, pitch]
    related_skills: [do-market-research, start]
---

# /generate-pitch — Game Elevator Pitch

## Overview

This skill creates a short, compelling elevator pitch for a game concept. As **@Capy (game designer)**, you synthesize the market research findings and the user's initial concept into a focused one-page pitch document that highlights unique selling points and market opportunity.

This is step 2 of the Agentic Gamedev Process (Pre-production phase).

## When to Use

- After `/do-market-research` has produced a market research document
- When you have market data and an initial concept direction and need to crystallize them
- Do NOT use before market research is complete — the pitch must be grounded in data

## Workflow

### 1. Load Context

- Read the most recent market research document from `.docs/market-research-*.md` (find by glob, pick the newest).
- Read `.docs/game-concept.md` if it exists (for existing projects pivoting or refining).
- Read `.docs/glossary.md` if it exists and enforce term consistency.

### 2. Interview for Concept Direction

If the user provided an initial concept or theme as an argument, use it. Otherwise, ask:

> "Based on the market research, the most promising niches are: [list top 2-3 from research]. Which direction feels most exciting to you? You can pick one, combine elements, or share a completely different idea."

Wait for the user's answer. Then ask ONE follow-up question to sharpen the hook:

> "What's the one moment in this game that would make a player say 'I need to play this'?"

### 3. Draft the Pitch

Synthesize the market research, user input, and your game design knowledge into a pitch. Follow the template at `.agents/docs/templates/pitch-template.md`.

Key elements to nail:
- **Elevator Pitch:** 1-2 sentences. "A [genre] where you [core action] in [unique context/twist]."
- **Hook:** The most surprising or compelling single sentence.
- **Unique Selling Points:** Exactly 3. What makes this different from everything else?
- **Comparable titles:** 2 games — what we borrow and how we differ. Be honest about both.
- **Market opportunity:** Tie directly to the research findings.

### 4. Present and Refine

Show the draft pitch to the user. Ask:

> "Here's the draft pitch. Does this capture the essence of what you're envisioning? What would you change?"

Accept feedback and refine. Repeat until the user is satisfied.

### 5. Senior Review — @Hag

Before finalizing, perform a senior game designer review (persona: @Hag). Evaluate the pitch against these criteria:

- **Clarity:** Can someone who knows nothing about the project understand what the game is from the elevator pitch alone?
- **Differentiation:** Are the USPs genuinely different from existing games, or are they generic genre features?
- **Market fit:** Does the pitch align with the market research findings?
- **Scope awareness:** Is this feasible for a solo indie developer?

If any criterion fails, flag it and suggest specific improvements. Present the feedback to the user and incorporate their decisions.

### 6. Write the Document

Write the final pitch to `.docs/pitch.md`. Create the `.docs/` directory if it doesn't exist.

### 7. Report Completion

Return a summary including:
- The elevator pitch sentence
- The 3 unique selling points
- The path to the written document
- Reminder: "Next step: @Capy runs `/start` to develop this pitch into a full game concept."

## Common Pitfalls

1. **Generic USPs.** "Fun gameplay" or "beautiful art" are not unique selling points. Every game claims those. Find the actual differentiator.
2. **No market tie-in.** The pitch must reference the market research. If the pitch doesn't connect to a documented market opportunity, it's just wishful thinking.
3. **Over-promising scope.** As a solo dev, the pitch must be realistic. "Open world with 100+ hours of content" is a red flag.
4. **Skipping the hook.** The elevator pitch is necessary but the hook is what people remember. Make it punchy.
5. **No comparable titles.** If you can't name 2 games this is similar to, either the concept is too vague or you haven't researched enough.

## Verification Checklist

- [ ] Market research document loaded and referenced
- [ ] User confirmed the concept direction
- [ ] Pitch template loaded and all sections filled
- [ ] @Hag review completed and feedback incorporated
- [ ] Output written to `.docs/pitch.md`
- [ ] Elevator pitch is 1-2 sentences and immediately understandable
- [ ] 3 USPs are genuinely differentiating, not generic
- [ ] Next step reminder included
