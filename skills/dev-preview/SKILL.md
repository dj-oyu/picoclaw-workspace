---
name: dev-preview
description: Start a dev server for in-progress code and expose it through the Mini App proxy for live preview in Telegram.
---

# Dev Preview Skill

## When to use
- User asks to preview/test a web app, API, or HTML page being developed
- User wants to see the output of code that serves HTTP content
- After writing server code that needs visual confirmation

## Flow
1. Write or modify the server/web code as requested
2. Start the dev server as a background process
3. Register the proxy target with the `dev_preview` tool
4. Tell the user to check the Dev tab in the Mini App

## Starting the dev server
Choose the right command based on the project:
- Python: `python3 -m http.server PORT &`
- Node.js: `npx serve -l PORT &` or `node server.js &`
- Go: `go run . &`
- Static HTML: `python3 -m http.server PORT &`

Use a port in the range 3000-9000. Append `&` to background the process.

## Registering the proxy
Use the `dev_preview` tool:
- Start: `dev_preview(action="start", target="http://localhost:PORT")`
- Check: `dev_preview(action="status")`
- Stop: `dev_preview(action="stop")`

## After registration
Tell the user: "Dev tab in the Mini App でプレビューできます"

## Stopping
When the user is done or asks to stop:
1. `dev_preview(action="stop")`
2. Kill the background process if known

## Prohibited
- MUST NOT use ports below 1024
- MUST NOT proxy to external hosts (only localhost)
