---
name: log-analyzer
description: "Analyze picoclaw application logs. Use proactively after any code change, deployment, or server restart — do not wait for the user to ask. Also use when debugging unexpected behavior, after API calls fail, or when the user mentions errors or system health."
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

## Report Format

分析後は必ず以下の形式で出力する:

**ログ調査結果**
- 調査範囲: WARN以上 / 直近N件
- エラー: X件　警告: Y件
- 影響コンポーネント: [一覧 または「なし」]

**検出された問題** (なければ省略)
- [component] `エラーパターン` — N回発生、最初: T / 最後: T
  → 推定原因 / 対応案

**判定**
- 異常なし — 対応不要
- 要対応 — 上記の問題を確認してください
