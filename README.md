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
