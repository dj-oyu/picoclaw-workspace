#!/bin/bash

# --- 設定項目 ---
REPO="sipeed/picoclaw"
# アーキテクチャ: Raspberry PiやLinux SBCの場合は linux_arm64
TARGET_ARCH="linux_arm64"
CONFIG_DIR="$HOME/.picoclaw"
CONFIG_FILE="$CONFIG_DIR/config.json"

echo "=== PicoClaw 自動セットアップ (決定版) ==="

# 1. 依存ツールの確認
echo "Checking dependencies..."
for cmd in curl jq tar; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "エラー: '$cmd' がインストールされていません。'sudo apt install $cmd' で導入してください。"
        exit 1
    fi
done

# 2. GitHub APIから最新リリースの情報を取得
echo "1. GitHub APIから最新リリースのURLを抽出中..."
RELEASE_JSON=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest")

# エラーチェック
if echo "$RELEASE_JSON" | grep -q "Not Found"; then
    echo "エラー: リポジトリ '${REPO}' が見つからないか、アクセスできません。"
    exit 1
fi

# ダウンロードURLの抽出 (.assets配列を展開して検索)
DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r ".assets[] | select(.name | ascii_downcase | contains(\"${TARGET_ARCH}\")) | .browser_download_url" | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "エラー: '${TARGET_ARCH}' を含むアセットがリリースの中に見つかりませんでした。"
    echo "検出されたリリース情報: $(echo "$RELEASE_JSON" | jq -r .tag_name)"
    exit 1
fi

# 3. ダウンロードと展開
echo "2. 最新バイナリをダウンロード中... ($DOWNLOAD_URL)"
INSTALL_TMP=$(mktemp -d)

if curl -L "$DOWNLOAD_URL" -o "$INSTALL_TMP/download.tar.gz"; then
    tar -xzf "$INSTALL_TMP/download.tar.gz" -C "$INSTALL_TMP"
else
    echo "エラー: ダウンロードに失敗しました。"
    rm -rf "$INSTALL_TMP"
    exit 1
fi

# 4. バイナリのインストール
# ファイル検索 (直下またはサブディレクトリ)
FOUND_BIN=$(find "$INSTALL_TMP" -name picoclaw -type f | head -n 1)

if [ -n "$FOUND_BIN" ]; then
    chmod +x "$FOUND_BIN"
    sudo mv "$FOUND_BIN" /usr/local/bin/
    echo "3. インストール完了: /usr/local/bin/picoclaw"
else
    echo "エラー: 展開されたアーカイブ内に 'picoclaw' バイナリが見つかりませんでした。"
    rm -rf "$INSTALL_TMP"
    exit 1
fi

  # 5. 設定ディレクトリとテンプレートの作成
  mkdir -p "$CONFIG_DIR/workspace"

if [ ! -e $CONFIG_FILE ]; then
  start_config=1
  # 設定ファイル生成 (OpenAI互換モードで作成)
  echo "4. 設定ファイルを生成中..."

  cat <<EOF > "$CONFIG_FILE"
{
  "agents": {
    "defaults": {
      "provider": "openai",
      "model": "MiniMax-M2.5",
      "workspace": "$CONFIG_DIR/workspace",
      "max_tokens": 8192,
      "temperature": 1.0, 
      "max_tool_iterations": 20
    }
  },
  "providers": {
    "openai": {
      "api_key": "sk-cp-ここに取得したキーを記入",
      "api_base": "https://api.minimax.io/v1"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "ここにTelegramのボットトークン",
      "allow_from": []
    }
  }
}
EOF
  echo "設定ファイル作成完了: $CONFIG_FILE"
fi

# 後片付け
rm -rf "$INSTALL_TMP"

echo "=== すべての工程が完了しました ==="

if [ "$start_config" ]; then
echo "【重要：次のステップ】"
echo "1. 'nano $CONFIG_FILE' を実行してください。"
echo "2. 'api_key' に MiniMaxのキー (sk-cp-...) を入力してください。"
echo "3. 'token' に Telegramのボットトークンを入力してください。"
echo "4. 'allowFrom' の [] の中に、あなたのTelegram ID (数字) をカンマ区切りで入力してください。"
echo "   例: \"allowFrom\": [ 123456789 ]"
echo -n "5. 設定保存後、"
fi
echo "'picoclaw gateway' で起動します。"
