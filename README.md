# PicoClaw Workspace

このリポジトリは PicoClaw の運用ドキュメントとワークフロー設定を管理するためのワークスペース。

## 目的
- HEARTBEAT.md を中心に「今やるタスク」を可視化
- GitHub Issues を司令塔として複数拠点からタスクを分散実行
- 自律運用と Human-in-the-loop の両立

## 主要ファイル
- `SOUL.md` ピコやんの中核ルール
- `AGENTS.md` エージェント運用ルール
- `IDENTITY.md` ピコやんの人格・口調
- `USER.md` 利用環境と技術選定の好み
- `TOOLS.md` ツール運用方針
- `HEARTBEAT.md` 今すぐやるタスクのチェックリスト

## ワークフローの考え方
### ラインA: HEARTBEAT.md 主導（自動タスク消化）
- 目的は「今すぐやる」短時間タスクの消化
- `#issue:` なしの行はローカル運用
- 変更が入ったらコミットと push を促す

### ラインB: Issues 主導（Human-in-the-loop 司令塔）
- 目的は長時間・並列タスクの分散実行
- 担当の巻き取りはラベルで共有（例: `claimed`, `owner-<name>`）
- 進捗はコメントで共有し、完了で close

## HEARTBEAT.md と Issues の同期
- `#issue:` が付いた行だけ Issues に同期
- `- [ ] #issue: Task title` は open
- `- [x] #issue: Task title` は close
- `#issue:` のない行はローカル専用

## 自動同期（GitHub Actions）
- `HEARTBEAT.md` 変更時と毎日 03:00 UTC に同期
- ワークフロー: `.github/workflows/heartbeat-issues.yml`

## .gitignore 方針
- ホワイトリスト形式で必要ファイルだけ追跡
- プロジェクト本体は各ディレクトリごとに独立リポジトリ運用を想定

## プロジェクトの始め方
基本の場所は `./projects/{project-title}` を推奨。

例:
```bash
mkdir -p projects/sample-project
cd projects/sample-project
git init
git branch -m main
```

ワークスペース側はホワイトリスト運用なので、各プロジェクトは独立リポジトリで管理する。

## 今回のトラブルまとめ（2026-02-19）

### 症状
- Telegram で `テスト` を送ると、LLM 呼び出しが `400 invalid params, invalid chat setting (2013)` で失敗することがあった。
- 起動時に `dial tcp 127.0.0.1:8787: connect: connection refused` が出ることがあった（プロキシ未起動時）。

### 原因
- 直接原因は API 接続断ではなく、**セッション履歴の不整合**。
- `sessions/telegram_2038855069.json` の先頭に、対応する assistant の tool_call が存在しない `role=tool` メッセージ（orphan tool message）が残っていた。
- この不正履歴が `messages` に含まれ、MiniMax 側で `invalid chat setting (2013)` になっていた。

### 切り分けで分かったこと
- MiniMax は `tools` 付きでも正常応答可能（curl 検証で 200）。
- 失敗時の request/response はローカル中継プロキシで dump でき、`request_id` 単位で追跡可能。
- `agent: LLM response without tool calls` はエラーではなく、通常の直接回答ログ。

### 実施した対処
- 壊れたセッション JSON を退避して再生成したところ、同症状は解消。
- 通信調査用にローカル中継プロキシを導入し、リクエスト/レスポンスを dump 可能にした。

### 運用メモ
- 2013 が再発したら、まず最新 `proxy_dumps/*.request.json` の `messages` 並びを確認する。
- 特に先頭付近の `role=tool` が orphan になっていないかを確認する。
