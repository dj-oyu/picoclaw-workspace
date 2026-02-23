---
name: log-analyzer
description: "Analyze application logs for errors, patterns, and anomalies. Use when user asks about errors, system health, log analysis, or 'check the logs'."
---

# log-analyzer Skill

Analyze picoclaw application logs on demand using the `logs` tool.

## Token-Efficient Analysis Pattern

Always start narrow, then widen only if needed:

1. **Overview** — `logs` with `level=WARN`, `limit=20` to get a quick summary of issues
2. **Drill down** — If errors found, use `component` or `query` to isolate
3. **Full context** — Only use `level=INFO` or `level=DEBUG` when the user explicitly asks or when WARN/ERROR alone is insufficient

Never fetch DEBUG-level logs without a specific reason — most are routine noise.

## logs Tool Parameters

| Parameter | Default | Use when |
|-----------|---------|----------|
| `level` | WARN | User says "errors" → ERROR, "everything" → DEBUG |
| `component` | (all) | User mentions a specific channel: telegram, discord, slack, wecom, agent |
| `limit` | 50 | Start with 20 for overview, increase only if needed |
| `query` | (none) | User mentions a keyword: "timeout", "webhook", "auth" |

## Analysis Checklist

When reporting findings:

- **Error count & types** — Group by component and error pattern
- **Timestamps** — Note if errors are clustered (burst) or spread out
- **Recurring patterns** — Same error repeating = systematic issue
- **Actionable items** — Suggest concrete fixes, not just descriptions

## User Intent Mapping

| User says | Parameters |
|-----------|-----------|
| "Check the logs" / "Any errors?" | `level=WARN, limit=20` |
| "What's wrong with Telegram?" | `level=WARN, component=telegram` |
| "Show me everything" | `level=DEBUG, limit=50` |
| "Find timeout errors" | `level=ERROR, query=timeout` |
| "System health check" | `level=WARN, limit=30` then summarize |
