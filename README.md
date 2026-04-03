# GSoC 2026 参加機関ガイド原稿

技術書店向け原稿

仮題:
「世の中の Open Source Software を把握しよう！
 Google Summer of Code 2026 の参加機関を解説」

## このリポジトリの目的

Google Summer of Code 2026 の参加機関をアルファベット順に整理し、
2機関で1ページになる構成を前提として、日本語の紹介原稿を書くための作業用リポジトリです。

## 重要方針

- GSoC 公式サイトや各団体サイトの説明文をそのまま翻訳転載しない
- 英語の説明を読んだうえで、日本語で独自に要約して紹介する
- 事実と解釈を分ける
- 公開時点での情報であることを明記する

2026-04-01 時点で program API の accepted organizations は 184 件です。
organizations API の全件数と manuscript/book.md の収録数も 184 件で一致しています。
一時的に UI 上で 185 と見えた記録がありましたが、現時点では再現できず、program API の集計値とも一致しません。

## 原稿の基本フォーマット

各ページには上下2枠で2機関を載せ、各機関について原則として次の項目を入れます。

1. 機関名
2. アイコン画像
3. 一言要約
4. 何を作っている組織か
5. GitHub もしくは主要コードホスティング先
6. スター数などの公開指標
7. GSoC 参加者が関わりそうなテーマ
8. どんな人に向いていそうか
9. 調査メモ
10. 出典

## 指標の扱い

- クローン数は通常公開されないため、掲載指標はスター数を優先する
- GitHub が主戦場でない組織は、GitLab など主要ホスティング先を載せる
- 組織全体の人気ではなく、代表リポジトリのスター数を使う
- スター数は確認日付きの参考値として扱う

## ディレクトリ構成

- `manuscript/book.md`: 電子書籍変換用の主原稿
- `manuscript/index.md`: 目次と進捗管理
- `manuscript/organizations/`: 各機関の調査メモ兼原稿
- `manuscript/pages/`: 一時的なレイアウト確認用。主原稿にはしない
- `scripts/convert-book.ps1`: Pandoc 変換スクリプト
- `assets/book.css`: HTML / EPUB 向けの基本スタイル
- `output/`: 変換成果物の出力先
- `templates/organization-page.md`: 各機関の調査テンプレート
- `templates/two-organizations-page.md`: 2機関1ユニットのテンプレート
- `docs/editorial-policy.md`: 執筆ルールと判断基準
- `docs/conversion.md`: 変換手順メモ

## ファイル運用方針

- 電子書籍化を前提に、主データは `manuscript/book.md` に集約する
- 2機関で1ページという考え方は維持するが、Markdown 上では固定ページではなく「2機関1ユニット」として扱う
- `manuscript/organizations/` には調査結果を残し、`manuscript/book.md` に読者向け本文を連結する
- `manuscript/pages/` は必要なときだけ使う確認用ドラフトとする

## 執筆フロー

1. GSoC の機関ページを確認する
2. 公式サイト、Ideas ページ、Contributor Guidance を確認する
3. 機関の活動内容を日本語で要約する
4. 技術スタックとトピックを整理する
5. 読者に向けて「どんな人に向くか」を書く
6. 出典 URL を残す

## 現在の到達点

- `manuscript/book.md` は A-Z、184 機関ぶんの本文を収録済み
- `manuscript/organizations/` も 184 機関ぶんの個別メモを収録済み
- 現在は「追加」よりも「精度向上」と「表記統一」の段階に入っている

## 次の作業候補

- 代表リポジトリとスター数の placeholder を優先度順に実測値へ置き換える
- 主原稿と個別メモの表記ゆれを減らす
- 電子書籍化に向けて前書き、目次、奥付まわりを整える

## 変換フロー

Pandoc が入っていれば、主原稿から HTML / EPUB / DOCX を `output/` にまとめて出力できます。

```powershell
pwsh ./scripts/convert-book.ps1
```

著者名を埋める場合:

```powershell
pwsh ./scripts/convert-book.ps1 -Author "著者名"
```

既存出力を消してから作り直す場合:

```powershell
pwsh ./scripts/convert-book.ps1 -Clean
```

詳細は `docs/conversion.md` を参照してください。

VS Code では `Run Task` から次も使えます。

- `Build Book HTML`
- `Build Book EPUB`
- `Build Book DOCX`
- `Build Book EPUB+DOCX`
- `Build Book All`

Pandoc 実行時に `Could not load translations for ja`、`The term Abstract has no translation defined.`、`The term Figure has no translation defined.` といった警告が出る場合がありますが、現状のこの環境では HTML / EPUB / DOCX の生成自体は成功しています。したがって、これらの警告は即時のブロッカーではありません。詳細は `docs/conversion.md` を参照してください。
