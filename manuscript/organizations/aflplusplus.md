# AFLplusplus

## 基本情報

- 表示名: AFLplusplus
- アイコン候補: https://avatars.githubusercontent.com/u/62360046?s=200&v=4
- GSoC organization page: https://summerofcode.withgoogle.com/programs/2026/organizations/aflplusplus
- Website: https://aflplus.plus
- Ideas list: https://github.com/AFLplusplus/LibAFL/issues/3706
- Contributor guidance: https://github.com/AFLplusplus/LibAFL/blob/main/CONTRIBUTING.md

## コードホスティング

- 種別: GitHub
- リンク: https://github.com/AFLplusplus
- 代表リポジトリ: AFLplusplus/AFLplusplus
- スター数: 6416 at 2026-04-01

## 一言要約

ファジングを中心にソフトウェアの安全性向上へ直結する低レイヤ寄りの OSS コミュニティ。

## 組織概要

AFLplusplus は、ソフトウェアのバグや脆弱性を自動的に見つけるためのファジング技術を発展させている。AFL++ や LibAFL のように、実際のセキュリティ研究やテスト自動化に直結するツールが中心で、表層の UI よりもコンパイラ、実行系、解析技術の色が強い。

## 主な技術領域

- LLVM
- Rust
- Fuzzing
- QEMU

## 主なトピック

- ファジング
- CI
- セキュリティ検証

## GSoC で関わりそうな内容

新しいファジング手法、効率化、実行基盤の改善、Rust ベースのライブラリ整備、対象環境の拡張などがテーマになりやすい。

## どんな人に向いていそうか

セキュリティ、コンパイラ、低レイヤ、テスト自動化に強い関心がある人に向いている。華やかなアプリではなく、他のソフトウェアの品質を支える道具そのものを作りたい人向けだ。

## 調査メモ

- 確認日: 2026-04-01
- GSoC ページでは AFL++ と LibAFL を中心とした fuzzing framework 群が紹介されている
- GitHub 組織では AFLplusplus/AFLplusplus と AFLplusplus/LibAFL が主要リポジトリとして見える
- 代表指標として AFLplusplus/AFLplusplus のスター数を採用した