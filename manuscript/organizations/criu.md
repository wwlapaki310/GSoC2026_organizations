# CRIU

## 基本情報

- 表示名: CRIU
- アイコン候補: https://avatars.githubusercontent.com/u/32352560?s=200&v=4
- GSoC organization page: https://summerofcode.withgoogle.com/programs/2026/organizations/criu
- Website: https://criu.org
- Ideas list: https://criu.org/Google_Summer_of_Code_Ideas
- Contributor guidance: https://github.com/checkpoint-restore/criu/blob/criu-dev/CONTRIBUTING.md

## コードホスティング

- 種別: GitHub
- リンク: https://github.com/checkpoint-restore
- 代表リポジトリ: checkpoint-restore/criu
- スター数: 3765 at 2026-04-01

## 一言要約

Linux のプロセスとコンテナを停止保存して再開できる、低レイヤ基盤技術の中核 OSS。

## 組織概要

CRIU は Checkpoint/Restore In Userspace の略で、実行中のアプリケーションやコンテナの状態をディスクへ退避し、後からそのまま復元できる仕組みを提供する。コンテナ基盤や OS の深い部分に関わるため、表からは見えにくいがインフラの自由度を大きく高める技術である。

## 主な技術領域

- C
- Python
- Linux
- Go

## 主なトピック

- クラウド
- コンテナ
- Checkpoint/Restore

## GSoC で関わりそうな内容

コア機能、ランタイム連携、ライブマイグレーション、デバッグ、周辺ツール、各種バインディング改善などが考えられる。

## どんな人に向いていそうか

Linux カーネル寄りの世界、コンテナランタイム、低レイヤの挙動に興味がある人に向いている。アプリ層より OS 基盤を理解したい人向けだ。

## 調査メモ

- 確認日: 2026-04-01
- GSoC ページでは Docker、Podman、LXC/LXD などとの統合実績が示されている
- GitHub 組織では checkpoint-restore/criu が代表リポジトリとして明確に確認できた