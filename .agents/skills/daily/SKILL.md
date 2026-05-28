
---
name: daily
description: "Manage the daily backlog — review current sprint tasks, fill in new tasks, or hand off to the milestone skill when sprints change."
user-invocable: true
---

<what-to-do>

1. **Check Files**
  - Before starting, check that all the files below exist. If any are missing, redirect to the `/milestone` skill and exit this skill.
    - `.docs/project-state.md`
    - `.docs/roadmap.md`
    - `.docs/backlog.md`

2. **Check Sprint**
  - Read the project state.
  - If the milestone is "Undefined" (or any value not in the Milestone List), redirect to the `/milestone` skill and exit this skill.
  - Else if the backlog has tasks listed AND the backlog header matches the current sprint in the project state:
    - If all tasks are marked as done, redirect to the `/milestone` skill to finish the sprint and exit this skill.
    - Else `AskUserQuestion` if the user wants to review the tasks for the current sprint.
      - If the user confirms, Interview them to review the tasks, offer help to complete them, then exit this skill.
      - Else, tell the user the next incomplete task, offer to help with it, then exit this skill.
  - Else if the sprint listed in the backlog header differs from the current sprint in the project state:
    - `AskUserQuestion` if you can override the backlog header to match the current sprint in the project state.
      - If they confirm, clear all existing backlog tasks and update the header, then go to step 3 (Fill in the Backlog).
      - Else, redirect to the `/milestone` skill at the "Change Sprint" step to change the current sprint, then exit this skill.
  - Else (the backlog is empty or has no tasks for the current sprint), go to step 3.

3. **Fill in the Backlog**
  - Interview the user to define the tasks for the current sprint, then write them to the backlog.

4. **Write Decisions**
  - Read `.docs/decisions.md`.
  - If any important decisions were made during the interview that were not already recorded, write them to the decisions document.

5. **Keep Up To Date**
  - While running this skill, often there will occur clarifications, specifications, or detailing of concepts, tasks, or decisions.
  - Read the documents:
    - `.docs/game-concept.md`
    - `.docs/roadmap.md`
    - `.docs/glossary.md`
    - `.docs/decisions.md`
  - If you detect that the user choices during the interview conflict with any of the documents or have implications, notify the user, and use `AskUserQuestion` to know if they want to update the documents to reflect the new choices.
    - If they confirm, update the relevant documents with the new choices to keep them up to date.

</what-to-do>

<supporting-info>

**Guidelines for this skill:**

- The backlog can have only one sprint's tasks at a time, which must be the current sprint in the project state. This is to avoid confusion and keep the backlog focused on the current work.
- When filling in the backlog, make sure to write clear and actionable tasks that can be completed in a few hours up to two days. Avoid vague or broad tasks that are not specific enough to guide the work.
- A good task is one that has a clear goal, a defined scope, and can be completed within a reasonable timeframe. For example, "Implement player attack animation" is a good task, while "Implement combat system" is too broad and more fitting to be a sprint where smaller tasks would look like "Player Attack and Block" + "Basic enemy AI" + "Create attack animations" + "Implement damage calculation".

</supporting-info>