# TOOLS.md

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

## 言語ごとの推奨スタック
### Python
- 依存管理: `uv`
- 追加: `uv add <package>`
- 実行: `uv run <script.py>` または `uv run -m <module>`
- リンター/フォーマッター: `ruff`（導入済みなら `uv run ruff check .` / `uv run ruff format .`）
- **NEVER use `pip` or bare `python`. Always go through `uv`.**

#### Command Substitution Rules
- ~~`pip install <pkg>`~~ → `uv add <pkg>` — MUST use uv for package installation
- ~~`pip install -e .`~~ → `uv sync` — MUST use uv sync for editable installs
- ~~`pip install -r requirements.txt`~~ → `uv add` per package — MUST manage deps in pyproject.toml
- ~~`python script.py`~~ → `uv run script.py` — MUST run through uv
- ~~`python -m pytest`~~ → `uv run -m pytest` — MUST run through uv
- ~~`python -m <module>`~~ → `uv run -m <module>` — MUST run through uv

### TypeScript
- 依存管理: `pnpm` か `bun`
- 追加: `pnpm add <pkg>` / `bun add <pkg>`
- 実行: `pnpm <script>` / `bun <script>`
- 単発実行: `pnpx <tool>` / `bunx <tool>`
- 例: `pnpx tsc --noEmit` / `bunx eslint .`
- リンター/フォーマッター: `eslint` / `prettier`（ある場合は `pnpx` / `bunx` で実行）
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
- モジュール: `go mod init`, `go get`
- 実行: `go run`, `go test`, `go build`
- フォーマッター: `gofmt -w <file>`

### シェル
- 短命・単発用途に限定
- 破壊的操作は必ず事前確認

## Prohibited Commands
- **NEVER use `pip` or `pip install` directly.** Always use `uv add` instead.
- **NEVER run `python` or `python3` directly.** Always use `uv run` instead.
- **NEVER use `npm`, `npm install`, or `npx`.** Always use `pnpm` or `bun` instead.
- **NEVER run `node` directly.** Always use `bun` instead.
- **NEVER write plain JavaScript (.js/.mjs/.cjs).** Always use TypeScript (.ts/.mts/.cts).
- These rules apply unconditionally — including retries after timeouts or errors.

## 現時点の制約
- 特になし
