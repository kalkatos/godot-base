
<what-to-do>

1. **Check Files**
  - Before starting, check if all the files below exist. If any of them are missing, redirect to the `/milestone` skill and exit this skill.
    - `.docs/project-state.md`
    - `.docs/roadmap.md`
    - `.docs/backlog.md`

2. **Check Sprint**
  - Read the project state.
  - If the milestone is "Undefined" or "Project Setup", redirect to the `/milestone` skill and exit this skill.
  - Else if the backlog document has tasks for current sprint already:
    - If they are all marked as done, redirect to the `/milestone` skill to finish the sprint and exit this skill.
    - Else `AskUserQuestion` if they want to review the tasks for current sprint.
      - If they confirm, Interview them to review the tasks, offer help to complete them, then exit this skill.
      - Else, tell them the next task they have to do, offer to help them with it, then exit this skill.
  - Else if the the sprint shown is different from current sprint in project state:
    - `AskUserQuestion` if you can override the sprint shown in the backlog to match the current sprint in project state.
      - If they confirm, clear it up and go to step 3 (Fill in the Backlog).
      - Else, redirect to the `/milestone` at the `Change Sprint` step to change the current sprint, then exit this skill.

3. **Fill in the Backlog**
  - Interview the user to define the tasks for current sprint, write them to the backlog.

</what-to-do>

<supporting-info>

**Guidelines for this skill:**

- The backlog can have only one sprint's tasks at a time, which must be the current sprint in project state. This is to avoid confusion and keep the backlog focused on the current work.
- When filling in the backlog, make sure to write clear and actionable tasks that can be completed in a few hours up to two days. Avoid vague or broad tasks that are not specific enough to guide the work.
- A good task is one that has a clear goal, a defined scope, and can be completed within a reasonable timeframe. For example, "Implement player attack animation" is a good task, while "Implement combat system" is too broad and more fitting to be a sprint where smaller tasks would look like "Player Attack and Block" + "Basic enemy AI" + "Create attack animations" + "Implement damage calculation".

</supporting-info>