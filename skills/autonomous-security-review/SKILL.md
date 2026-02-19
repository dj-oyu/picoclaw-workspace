---
name: autonomous-security-review
description: Non-interactive security review of codebases using frontier AI via the `codex` CLI.
---

# Autonomous Security Review Skill

## いつ使う
- 公開前のセキュリティ監査を求められたとき
- 脆弱性チェックの依頼が来たとき
- リポジトリ全体/差分/特定ディレクトリの安全性を短時間で洗い出したいとき

## 使う前の確認（必須）
1. **コマンド名と場所**を確認する
   - `command -v codex` で確認
2. **監査範囲**を合意する
   - `リポジトリ全体` / `差分のみ` / `特定ディレクトリ`

## 基本フロー
1. 対象ディレクトリを決める
2. 非対話でレビューを実行する
3. 重要度順に指摘を要約し、再現手順や対策案があれば添える
4. 公開方針に従い、監査完了後に Public 公開する

## 実行コマンド例
- 最重要コマンド（非対話レビュー）
  - `codex exec -C <project-dir> --yolo "/review"`
- Gitリポジトリではない場合
  - `codex exec -C <project-dir> --yolo "/review skip-git-repo-check"`

## Prohibited (English)
- MUST NOT publish as Public before completing the review
- MUST NOT run the review when static checks or automated tests are not passing

## 迷ったら
「ごめん、ちょっと迷っちゃって 監査範囲と認証の前提をもう一度確認していい？」
