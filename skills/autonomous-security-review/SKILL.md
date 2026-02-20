---
name: autonomous-security-review
description: Non-interactive code review of codebases using frontier AI via the `codex` CLI. Supports fixed security review (Mode A) and custom-perspective review (Mode B).
---

# Autonomous Code Review Skill

## When to use
- Pre-release security audits (Mode A)
- Vulnerability checks on request (Mode A)
- Quick safety scan of a whole repo, a diff, or a specific directory (Mode A)
- Code review from any perspective — performance, accessibility, design quality, etc. (Mode B)
- Focused review of specific concern areas requested by the user (Mode B)

## Pre-flight gate (MUST pass before execution)

Run ALL of the following. If ANY fails, STOP and report the failure.

| Step | Command | Pass condition |
|------|---------|----------------|
| codex exists | `command -v codex` | exit 0 |
| static checks pass | project-specific lint / type-check command | exit 0 |
| tests pass | project-specific test command | exit 0 |

If you do not know the lint/type-check/test commands for the project, look for `Makefile`, `package.json`, `pyproject.toml`, `Cargo.toml`, or equivalent. If none exist, STOP and report that no test commands were found.

## Common variables (both modes)

| Variable | Description | Example |
|----------|-------------|---------|
| `PROJECT_DIR` | Absolute path to the project directory to review | `/home/user/projects/my-app` |
| `GIT_FLAG` | Empty string if the directory is a git repo. Otherwise the literal string ` skip-git-repo-check` (with leading space). | `` or ` skip-git-repo-check` |

## Mode A: Security Review

Use this mode when the user requests a security review, vulnerability scan, or safety audit.

**Fixed command (do not modify the structure):**

```
codex exec --yolo -C ${PROJECT_DIR} "/review${GIT_FLAG}"
```

Everything else in the command is a literal. Do not add, remove, or change any flags or subcommands.

## Mode B: Custom Review

Use this mode when the user requests a code review from a non-security perspective (e.g., performance, accessibility, design quality, maintainability).

### Step 1 — Compose REVIEW_PROMPT

Build `REVIEW_PROMPT` by filling in the template below. Do NOT use free-form text; follow this structure exactly.

```
Review this project.
Perspective: <one sentence describing the review perspective>
Focus areas: <comma-separated list of specific check items>
Report format: List findings by severity (Critical / High / Medium / Low / Info). Include reproduction steps and recommended fixes.
```

**Constraints on REVIEW_PROMPT:**
- MUST follow the template above — no structural deviation
- MUST NOT contain shell meta-characters: `$`, `` ` ``, `$(...)`, `;`, `|`, `&&`
- MUST be plain English text only

### Step 2 — Present for approval (mandatory, cannot be skipped)

Before execution, you MUST present the following to the user and obtain explicit approval:

1. The full `REVIEW_PROMPT` text
2. The complete command that will be executed:
   ```
   codex exec --yolo -C ${PROJECT_DIR} "${REVIEW_PROMPT}${GIT_FLAG}"
   ```

Wait for the user to approve. Do NOT proceed without approval. There is no option to skip this gate.

### Step 3 — Execute

After receiving user approval, run the command exactly as presented:

```
codex exec --yolo -C ${PROJECT_DIR} "${REVIEW_PROMPT}${GIT_FLAG}"
```

Do not add, remove, or change any flags or subcommands.

## After execution
1. **Report MUST be written in the user's language.** Match the language the user used in their request.
2. Summarize findings by severity; include reproduction steps and mitigations where possible
3. Follow the publication policy — publish as Public only after the review is complete

## Prohibited
- MUST NOT publish as Public before completing the review
- MUST NOT add, remove, or change any flags or subcommands beyond the defined variables
- MUST NOT skip the pre-flight gate
- MUST NOT skip the human approval gate in Mode B (Step 2)
- MUST NOT include shell meta-characters (`$`, `` ` ``, `$(...)`, `;`, `|`, `&&`) in `REVIEW_PROMPT`
- MUST NOT deviate from the `REVIEW_PROMPT` template structure in Mode B
