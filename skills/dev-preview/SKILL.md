---
name: dev-preview
description: Start a dev server in the background and preview it through the Mini App reverse proxy.
---

# Dev Preview Skill

## When to use
- User asks to preview/test a web app, API, or HTML page being developed
- User wants to see the output of code that serves HTTP content
- After writing server code that needs visual confirmation

## Quickstart

```
1. exec(command="npm run dev", background=true)
   → bg-1 started

2. bg_monitor(action="watch", bg_id="bg-1", pattern="ready|listening|localhost")
   → Match: "Server ready on http://localhost:3000"

3. dev_preview(action="start", target="http://localhost:3000", name="frontend")
   → Dev preview started
```

## Flow
1. Write or modify the server/web code as requested
2. Start the dev server with `exec(command="...", background=true)`
3. Wait for readiness with `bg_monitor(action="watch", bg_id="bg-1", pattern="...")`
4. Register the proxy with `dev_preview(action="start", target="http://localhost:PORT")`
5. Tell the user to check the Dev tab in the Mini App

## Starting the dev server

Use `exec` with `background=true` — the process runs in the background and returns immediately with a process ID.

| Framework | Command |
|-----------|---------|
| Python (FastAPI) | `exec(command="uv run fastapi dev --port PORT", background=true)` |
| Python (Flask) | `exec(command="uv run flask run --port PORT", background=true)` |
| Python (Django) | `exec(command="uv run python manage.py runserver PORT", background=true)` |
| Bun (Hono/Elysia) | `exec(command="bun run --hot src/index.ts", background=true)` |
| Bun (Next.js) | `exec(command="bun run next dev --port PORT", background=true)` |
| Go (Echo/Gin/Chi) | `exec(command="go run .", background=true)` |
| Static HTML | `exec(command="uv run python -m http.server PORT", background=true)` |
| Node.js (Vite) | `exec(command="npm run dev", background=true)` |

Use a port in the range 3000-9000.

## Waiting for server readiness

**Always** use `bg_monitor(action="watch")` before calling `dev_preview(action="start")`:

```
bg_monitor(action="watch", bg_id="bg-1", pattern="ready|listening|Serving|localhost")
```

- Polls every 100ms, returns when pattern matches (default 30s timeout).
- Set `watch_timeout` (seconds) to extend if the server is slow to start.
- If timeout occurs, use `bg_monitor(action="tail", bg_id="bg-1")` to diagnose.

## Registering the proxy

Use the `dev_preview` tool:
- Start: `dev_preview(action="start", target="http://localhost:PORT")`
- Check: `dev_preview(action="status")`
- Stop: `dev_preview(action="stop")`

## Monitoring and debugging

| Call | Purpose |
|------|---------|
| `bg_monitor(action="list")` | List all background processes |
| `bg_monitor(action="tail", bg_id="bg-1", lines=30)` | Get last 30 lines of output |
| `exec(bg_action="output", bg_id="bg-1")` | Full output with status |

Background processes are also shown in the system prompt automatically.

## After registration
Tell the user: "Dev tab in the Mini App でプレビューできます"

## Stopping

```
exec(bg_action="kill", bg_id="bg-1")
dev_preview(action="stop")
```

## Background process details
- Auto-terminated after **45 minutes**
- Output kept in a **32 KB ring buffer** (most recent bytes)
- Maximum **10** concurrent background processes
- Exited processes remain visible until explicitly killed

## Prohibited
- MUST NOT use ports below 1024
- MUST NOT proxy to external hosts (only localhost)
