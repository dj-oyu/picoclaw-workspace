---
name: gemini-cli
description: Use gemini-cli to run an external LLM for quick second opinions, alternative drafts, or sanity checks, while confirming command, auth, and cost constraints first.
---

# Gemini CLI Skill

## いつ使う
- 別モデルのセカンドオピニオンが欲しいとき
- 別案や別表現を素早く出したいとき
- 事実関係や方針の sanity check が欲しいとき

## 使う前の確認（必須）
1. **コマンド名と場所**を確認する  
   - `command -v gemini` などで確認  
2. **認証方法**を確認する  
   - APIキーの場所や環境変数名はユーザーに確認  
3. **利用範囲とコスト**を確認する  
   - どの用途で使うか、回数/サイズの制限があるかを確認

## 基本フロー
1. `gemini --help` で使い方とオプションを把握
2. 非対話実行の基本形は `gemini --prompt "質問"`
3. ユーザー合意済みの目的に限定して実行
3. 出力は短く要約して本体に反映

## 禁止事項
- コマンド仕様が不明なまま実行しない
- 認証や課金が不明なまま実行しない
- ユーザー合意のない用途で使わない

## 迷ったら
「ごめん、ちょっと迷っちゃって 聞いてもいい？gemini-cli のコマンド名や認証方法がまだ確定してないんだ」
