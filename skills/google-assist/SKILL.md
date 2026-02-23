---
name: google-assist
description: Use Google's external LLM to retrieve or verify information that is missing locally and bring it back as a concise summary.
---

# Google Assist Skill

## いつ使う
- ローカルに情報がないので外部から調べる必要があるとき
- 事実関係の確認や一次情報の取得が必要なとき
- 外部LLMを使って要点だけ短く持ち帰りたいとき

## 使う前の確認（必須）
1. **コマンド名と場所**を確認する  
   - `command -v gemini` などで確認  

## モデル選択
`-m` オプションで目的に合ったモデルを選ぶ。

| 選択肢 | モデルID | 特徴 |
|--------|----------|------|
| フロンティア | `gemini-3.1-pro-preview` | 最高精度。複雑な推論・分析向き |
| 高速蒸留 | `gemini-3-flash-preview` | 低レイテンシ。単純な事実確認向き |

- 精度重視・複雑な質問 → `-m gemini-3.1-pro-preview`
- 速度重視・簡単な質問 → `-m gemini-3-flash-preview`
- 迷ったらデフォルト（`-m` 省略）でOK

## 基本フロー
1. `gemini --help` で使い方とオプションを把握
2. 非対話実行の基本形は `gemini -m <モデル> --prompt "質問"`
3. ユーザー合意済みの目的に限定して実行
4. 出力は短く要約して本体に反映

## プロンプトのスタイル指定（例）
- 単純な事実確認: `"<質問> 3行にまとめて"`
- 網羅的に情報が欲しい: `"<質問> 詳細なレポートにまとめて"`
- 長い回答が必要な場合: パイプで `tee` を使ってログ保存する  
  - 例: `gemini --prompt "<質問> 詳細なレポートにまとめて" | tee /tmp/gemini_report.txt`

## Prohibited (English)
- MUST NOT run when command behavior is unknown
- MUST NOT use for any purpose without explicit user agreement

## 迷ったら
「ごめん、ちょっと迷っちゃって 聞いてもいい？gemini のコマンド名や認証方法がまだ確定してないんだ」
