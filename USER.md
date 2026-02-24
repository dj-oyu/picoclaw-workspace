## 環境前提
- このデバイスはリソースが限られている
- CPUバウンドな処理は Go などのネイティブアプリを推奨

## 推奨ツール
- `uv`
- `pnpm`
- `bun`
- `TypeScript`
- `ruff`
- `ty`

## 技術選定の好み
- サーバーサイドJSはあまり好みじゃない（シングルスレッド制約が気になる）
- ただし TypeScript はAIにとって開発が容易な優秀な言語
- 開発速度・特殊性・性能の律速ポイントを考慮して技術選定する
## 方針
- 使うツールやコマンドは状況に合わせて選ぶ
- 危険な操作は事前に確認する

## ソフトウェアスタック選定の基準
- 起動時間が長いアプリや常駐プロセスは、基本的にコンパイル言語（Go/Rust/C++）を優先する
- ワンショットの処理や短命な自動化は、Python/シェルでも十分なことが多い
- 速度・運用性・依存管理のどれが律速かを先に見極める
- 提供形態で選ぶ: WebサービスならHTTPサーバ実装が得意な言語、CLIなら配布の軽さと起動速度を優先
- API都合で選ぶ: 低レイヤーやデバイスAPIがC/C++専用ならC++を優先
- ML/推論ならPyTorchや周辺エコシステムの都合でPythonを優先することがある
- I/O多めで並行性が重要ならGo/Rust、スクリプト用途ならPython/シェル

## Recommended Stack per Language
### Python
- Deps: `uv`
- Add: `uv add <package>`
- Run: `uv run <script.py>` or `uv run -m <module>`
- Lint/Format: `ruff` (`uv run ruff check .` / `uv run ruff format .`)
- Type check: `ty` (`uv run ty check` / `uvx ty check`)
- **NEVER use `pip` or bare `python`. Always go through `uv`.**

#### Command Substitution Rules
- ~~`pip install <pkg>`~~ → `uv add <pkg>` — MUST use uv for package installation
- ~~`pip install -e .`~~ → `uv sync` — MUST use uv sync for editable installs
- ~~`pip install -r requirements.txt`~~ → `uv add` per package — MUST manage deps in pyproject.toml
- ~~`python script.py`~~ → `uv run script.py` — MUST run through uv
- ~~`python -m pytest`~~ → `uv run -m pytest` — MUST run through uv
- ~~`python -m <module>`~~ → `uv run -m <module>` — MUST run through uv
- ~~`mypy`~~ → `uv run ty check` — MUST use ty for type checking

### TypeScript
- Deps: `pnpm` or `bun`
- Add: `pnpm add <pkg>` / `bun add <pkg>`
- Run: `pnpm <script>` / `bun <script>`
- One-off: `pnpx <tool>` / `bunx <tool>`
- e.g. `pnpx tsc --noEmit` / `bunx eslint .`
- Lint/Format: `eslint` / `prettier` (run via `pnpx` / `bunx`)
- **NEVER use `npm`, `npx`, or bare `node`. Always use `pnpm`/`bun` instead.**
- **NEVER write JavaScript (.js/.mjs/.cjs). Always use TypeScript (.ts/.mts/.cts).**

#### Command Substitution Rules
- ~~`npm install <pkg>`~~ → `pnpm add <pkg>` / `bun add <pkg>` — MUST use pnpm or bun
- ~~`npm install`~~ → `pnpm install` / `bun install` — MUST use pnpm or bun
- ~~`npx <tool>`~~ → `pnpx <tool>` / `bunx <tool>` — MUST use pnpx or bunx
- ~~`node script.js`~~ → `bun script.ts` — MUST use bun and TypeScript
- ~~`node -e "..."`~~ → `bun -e "..."` — MUST use bun
- ~~creating `.js`/`.mjs`/`.cjs`~~ → create `.ts`/`.mts`/`.cts` — MUST write TypeScript, NEVER JavaScript

### Go
- Module: `go mod init`, `go get`
- Run: `go run`, `go test`, `go build`
- Format: `gofmt -w <file>`

### Shell
- Short-lived / one-off tasks only
- Always confirm before destructive ops

## Prohibited Commands
- **NEVER use `pip` or `pip install` directly.** Always use `uv add` instead.
- **NEVER run `python` or `python3` directly.** Always use `uv run` instead.
- **NEVER use `npm`, `npm install`, or `npx`.** Always use `pnpm` or `bun` instead.
- **NEVER run `node` directly.** Always use `bun` instead.
- **NEVER write plain JavaScript (.js/.mjs/.cjs).** Always use TypeScript (.ts/.mts/.cts).
- These rules apply unconditionally — including retries after timeouts or errors.

### GitHub CLI (`gh`)
- Use `gh` for ALL GitHub operations (issues, PRs, releases, repos, etc.)
- **NEVER use raw GitHub API calls or manual browser operations when `gh` can do it.**

#### Cheatsheet

| Category | Command | Description |
|----------|---------|-------------|
| **Repo** | `gh repo clone <owner/repo>` | Clone a repo |
| | `gh repo view [owner/repo]` | View repo details |
| | `gh repo create <name> --public/--private` | Create a new repo |
| | `gh repo gitignore view <template>` | View a .gitignore template (e.g. `Go`, `Python`, `Node`) |
| | `gh repo gitignore list` | List available .gitignore templates |
| **Issue** | `gh issue list` | List issues |
| | `gh issue create --title "..." --body "..."` | Create an issue |
| | `gh issue view <num>` | View issue details |
| | `gh issue close <num>` | Close an issue |
| **PR** | `gh pr list` | List PRs |
| | `gh pr create --title "..." --body "..."` | Create a PR |
| | `gh pr checkout <num>` | Check out a PR locally |
| | `gh pr view <num>` | View PR details |
| | `gh pr merge <num>` | Merge a PR |
| **Search** | `gh search repos <query>` | Search repositories |
| | `gh search issues <query>` | Search issues across GitHub |
| | `gh search prs <query>` | Search pull requests |
| **Actions** | `gh run list` | List workflow runs |
| | `gh run view <id>` | View a workflow run |
| | `gh run watch <id>` | Watch a run in progress |
| **Misc** | `gh api <endpoint>` | Call any GitHub REST/GraphQL API |
| | `gh gist create <file>` | Create a gist |
| | `gh release create <tag>` | Create a release |

**Tips**:
- Add `--json <fields>` to most commands for machine-readable output (e.g. `gh issue list --json number,title`)
- Use `--jq <expr>` to filter JSON output (e.g. `gh pr list --json number,title --jq '.[].title'`)
- `gh browse` opens the repo in the browser; `gh browse <num>` opens an issue/PR

## Picoclaw ExecTool Guard

Picoclaw's ExecTool has a built-in security guard (`defaultDenyPatterns`) that **blocks commands matching certain patterns** before they reach the shell. These blocks are hard errors — the command is never executed.

### Git-specific blocks
| Pattern | What it catches |
|---------|----------------|
| `git push` | Any push to remote (use `gh` for PR-based workflows instead) |
| `git force` | Force operations (e.g. `git force-push` aliases) |

### Other blocked categories (summary)
| Category | Examples |
|----------|----------|
| Destructive / process | `rm -rf`, `kill -9`, `shutdown` etc |
| Privilege / system | `sudo`, `apt install`, `docker run` etc |
| Injection / RCE | `eval`, `$(...)`, `curl \| sh`, `ssh` etc |
