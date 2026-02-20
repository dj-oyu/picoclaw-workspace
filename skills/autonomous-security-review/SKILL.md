---
name: autonomous-security-review
description: Non-interactive security review of codebases using frontier AI via the `codex` CLI.
---

# Autonomous Security Review Skill

## When to use
- Pre-release security audits
- Vulnerability checks on request
- Quick safety scan of a whole repo, a diff, or a specific directory

## Pre-flight gate (MUST pass before execution)

Run ALL of the following. If ANY fails, STOP and report the failure.

| Step | Command | Pass condition |
|------|---------|----------------|
| codex exists | `command -v codex` | exit 0 |
| static checks pass | project-specific lint / type-check command | exit 0 |
| tests pass | project-specific test command | exit 0 |

If you do not know the lint/type-check/test commands for the project, look for `Makefile`, `package.json`, `pyproject.toml`, `Cargo.toml`, or equivalent. If none exist, STOP and report that no test commands were found.

## Execution

You MUST call the command exactly as shown below. The only parts you fill in are the two variables.

**Variables you decide:**

| Variable | Description | Example |
|----------|-------------|---------|
| `PROJECT_DIR` | Absolute path to the project directory to review | `/home/user/projects/my-app` |
| `GIT_FLAG` | Empty string if the directory is a git repo. Otherwise the literal string ` skip-git-repo-check` (with leading space). | `` or ` skip-git-repo-check` |

**Fixed command (do not modify the structure):**

```
codex exec --yolo -C ${PROJECT_DIR} "/review${GIT_FLAG}"
```

Everything else in the command is a literal. Do not add, remove, or change any flags or subcommands.

## After execution
1. **Report MUST be written in the user's language.** Match the language the user used in their request.
2. Summarize findings by severity; include reproduction steps and mitigations where possible
3. Follow the publication policy — publish as Public only after the review is complete

## Prohibited
- MUST NOT publish as Public before completing the review
- MUST NOT add, remove, or change any flags beyond the two variables above
- MUST NOT skip the pre-flight gate
