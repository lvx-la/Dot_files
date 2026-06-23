# devContainer

ホストを汚さないポータブルな開発環境。Linux(Ubuntu) + zsh、ツールは Dockerfile で
焼き込み、dotfile は `AutoInstall.sh` でリンクする。

## 使い方

VS Code で本リポジトリを開き、「Reopen in Container」。

## 他コンテナ(n8n 等)への接続

接続方式は **共有 external network**。n8n 等は **別スタックのまま** 運用し、同じ
ネットワークに相乗りさせることで `dev` からコンテナ名で到達できる。

1. 共有ネットワークを一度だけ作成:

   ```sh
   docker network create dev-shared
   ```

2. 既存スタック側(例: n8n の compose)を `dev-shared` に参加させる:

   ```yaml
   services:
     n8n:
       # ...既存設定...
       networks:
         - default
         - dev-shared
   networks:
     default:
     dev-shared:
       external: true
   ```

3. devContainer 内からはサービス名で到達:

   ```sh
   curl http://n8n:5678
   ```

> ホストが公開しているポートに繋ぎたいだけなら `host.docker.internal:<port>` も使える
> （その場合は本リポジトリの compose に `extra_hosts: ["host.docker.internal:host-gateway"]`
> を追加）。中からホストの docker を操作したくなったら docker ソケットのマウントを検討。

## Claude Code

Claude Code は Dockerfile で導入済み（`~/.local/bin/claude`）。認証は **ホストから引き継がず、
コンテナ内で一度だけログイン** する方式。

```sh
claude        # 初回のみブラウザ/コード認証
```

認証情報は名前付き Volume `claude-config`（`~/.claude` にマウント）に保存され、**リビルドしても
保持**される。トークンはコンテナ自身のセッションとして自動リフレッシュされるため、ホスト側の
再ログインやトークンローテーションの影響を受けない。

> ホスト認証をコピーで引き継ぐ方式は、ホストとコンテナで認証が分岐し、リフレッシュ時に片方が
> 失効し得るため非採用。やむを得ず使う場合は `.credentials.json` / `.claude.json` を RO 一時
> マウント→postCreate でコピー、に切り替える。

認証 Volume を作り直したい（ログアウト相当）:

```sh
docker volume rm <project>_claude-config
```

## メモ

- `AutoInstall.sh` は **dotfile の symlink のみ**。ツールは Dockerfile 側で導入する。
- `mise.toml` の powershell.exe 依存タスクはコンテナ内では動かない（WSL ホスト専用）。
  コンテナで使う言語/ツールは `mise.toml` の `[tools]` に定義すると `mise install` で揃う。
