---
name: dev-preview
description: Start a dev server in the background and preview it through the Mini App reverse proxy.
---

# Dev Preview Skill

## Network Architecture

```
User's phone (Telegram)
  │
  │  HTTPS (internet)
  ▼
Telegram Bot API server
  │
  │  Mini App WebView (iframe)
  │  URL: https://BOT_DOMAIN/miniapp
  ▼
picoclaw server (VPS / local machine)
  │
  │  /miniapp/dev/*  →  reverse proxy (httputil.ReverseProxy)
  │  strips /miniapp/dev prefix, forwards all HTTP methods
  ▼
localhost:PORT (dev server)
  e.g. Vite on :5173, FastAPI on :8000, Go on :8080
```

**Request path**: User opens Dev tab in Mini App → iframe loads `/miniapp/dev/` → picoclaw reverse proxy → `localhost:PORT`

**What works**: All HTTP methods (GET/POST/PUT/DELETE/PATCH), JSON APIs, form submissions, static files, SSE
**What doesn't work**: WebSocket (reverse proxy limitation), non-HTTP protocols

**Key points**:
- The dev server only needs to bind to **localhost** — it is never exposed directly to the internet
- picoclaw's reverse proxy handles the internet-facing HTTPS
- The Mini App frontend sees API paths as `/miniapp/dev/api/...` — the `/miniapp/dev` prefix is stripped before forwarding
- **fetch/XHR are auto-rewritten**: The proxy injects a script into HTML responses that patches `fetch()` and `XMLHttpRequest.open()` to add the `/miniapp/dev` prefix to absolute paths — no manual base URL configuration needed

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

## Pitfalls / 落とし穴

### Path rewriting (パスリライト)

The dev server runs at `/` but is proxied under `/miniapp/dev/`. The reverse proxy **automatically injects a `<script>`** into HTML responses that patches `fetch()` and `XMLHttpRequest.open()` so that absolute paths like `/api/items` are rewritten to `/miniapp/dev/api/items`.

- **Covered automatically**: `fetch("/api/items")`, `xhr.open("GET", "/data")` — these are patched at runtime.
- **NOT rewritten automatically**: HTML attribute URLs such as `<img src="/img/logo.png">`, `<link href="/style.css">`, `<a href="/page">`. Use **relative paths** (`img/logo.png`, `./style.css`) in your frontend code.
- URLs that already start with `/miniapp/dev` or `//` (protocol-relative) are left untouched to prevent double-rewriting.

### WebSocket not supported

`httputil.ReverseProxy` does **not** transparently proxy WebSocket connections. If your dev server uses WebSocket (e.g., Vite HMR), it will not work through the proxy. Use polling or SSE as alternatives.

### Static asset absolute paths

Any `src="/..."` or `href="/..."` in the HTML will be resolved by the browser relative to the domain root, **not** `/miniapp/dev/`. The injected script only patches `fetch` and `XHR`, not DOM attribute resolution.

**Recommendation**: Use relative paths in all HTML attributes (e.g., `src="./assets/logo.png"` instead of `src="/assets/logo.png"`).

### SPA routing

If your SPA uses `history.pushState("/page")`, the browser URL becomes `/page` which is outside the `/miniapp/dev/` mount. Navigating to it will hit picoclaw's own routes instead of the dev server.

**Recommendation**: Use **hash routing** (`/#/page`) to keep all navigation within the iframe's current path.

## Prohibited
- MUST NOT use ports below 1024
- MUST NOT proxy to external hosts (only localhost)
