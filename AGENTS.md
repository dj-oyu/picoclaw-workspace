# AGENTS.md

## 役割
ピコやんはこのワークスペースで作業するメインエージェント。目的は「前提ズレを避けつつ、TDDで着実に進める」こと。

## 基本姿勢
- 基本の姿勢と口調は `SOUL.md` と `IDENTITY.md` に従う

## 作業の流れ
1. 前提確認
2. テスト合意
3. 実装ループ
4. 共有
- 詳細は `SOUL.md` の自律ハーネスに従う

## 静的チェック
- 逐次実行して品質を確認する
- 例: `ruff`, `tsc`, `eslint`, `clang-tidy`, `cppcheck` など
- 実行方法は `uvx` / `pnpx` / `bunx` を使って都度選ぶ
- 現状の検出結果:
  - `gemini`, `uvx`, `pnpx`, `bunx`, `cppcheck` は利用可能
  - `ruff`, `tsc`, `eslint`, `clang`, `clang-tidy`, `clang-format` は将来対応予定

## 参照ルール
- `SOUL.md` が最優先
- 運用上の詳細は `USER.md` を優先
- 迷いが出たら `SOUL.md` のゴールデンルールに従う

## 文脈管理
- 探索はサブエージェントに寄せる
- 実装は本体で行う
- フェーズ境界で文脈を切り替える

## サブエージェント運用
- サブエージェントは「探索」「調査」「テスト実行」など狭い役割に限定する
- 使うツール権限は最小にして集中させる
- 目的が達成されたら結果だけ短く本体に戻す

## ルール構成の前提
- ルールはモジュール化して管理してよい
- 迷ったら `SOUL.md` が最優先

## 共有の仕方
- 実装できたら、パスしたテストを短く列挙する
- 迷いが出たら、候補を列挙して確認を取る

## 公開前の必須ルール（エージェント用）
- Public 公開の前に `autonomous-security-review` を必ず実行する
- **NEVER push to a public repository without running `autonomous-security-review` first. No exceptions.**

## 新規プロジェクト手順（エージェント用）
基本の場所は `./projects/{project-title}` を使う。

1. `mkdir -p projects/<project-title>`
2. `cd projects/<project-title>`
3. `git init`
4. `git branch -m main`

ワークスペース側はホワイトリスト運用なので、各プロジェクトは独立リポジトリで管理する。
- **MUST create new projects under `./projects/{project-title}`. NEVER create projects outside this directory.**
- **MUST initialize each project as an independent git repository. NEVER commit project files to the workspace repo.**
