# 電子書籍変換メモ

このリポジトリでは `manuscript/book.md` を主原稿とし、Pandoc 経由で配布用データへ変換する。

## 現在の前提

- 入力原稿: `manuscript/book.md`
- 出力先: `output/`
- 既定フォーマット: HTML / EPUB / DOCX
- 変換スクリプト: `scripts/convert-book.ps1`
- 見た目調整: `assets/book.css`

## 事前準備

### Pandoc のインストール

Windows では次で入れられる。

```powershell
winget install --id JohnMacFarlane.Pandoc -e
```

PDF まで一気に出したい場合は、Pandoc とは別に PDF エンジンが必要になる。初期段階では HTML / EPUB / DOCX を優先し、PDF は後段で整える方が安全。

## 使い方

### 既定の 3 形式を出力する

```powershell
pwsh ./scripts/convert-book.ps1
```

### 出力前に既存成果物を掃除する

```powershell
pwsh ./scripts/convert-book.ps1 -Clean
```

### 著者名を埋めて出力する

```powershell
pwsh ./scripts/convert-book.ps1 -Author "著者名"
```

### EPUB だけ出力する

```powershell
pwsh ./scripts/convert-book.ps1 -Formats epub
```

### PDF を追加する

```powershell
pwsh ./scripts/convert-book.ps1 -Formats html,epub,docx,pdf -PdfEngine xelatex
```

## VS Code から実行する

ターミナルで毎回コマンドを打たなくても、`Run Task` から次を選べるようにしてある。

- `Build Book HTML`
- `Build Book EPUB`
- `Build Book DOCX`
- `Build Book EPUB+DOCX`
- `Build Book All`

原稿確認を素早く回したいときは HTML、個別に詰めたいときは EPUB / DOCX、配布候補までまとめて見たいときは EPUB+DOCX、全部まとめて再生成したいときは All を使う。

## 現在の警告について

Pandoc 実行時に次の警告が出ることがある。

- `Could not load translations for ja`
- `The term Abstract has no translation defined.`
- `The term Figure has no translation defined.`

現状の Windows 環境では Pandoc 本体は正常に動いており、HTML / EPUB / DOCX の出力自体は成功している。したがって、締切対応としてはこの警告をブロッカー扱いしなくてよい。

ただし入稿前に余裕があれば、次のどちらかで詰め直す価値はある。

- Pandoc のテンプレートや title page 周りを調整して警告源を減らす
- 日本語前提の最終整形を Pandoc の後段で行う

## 整理方針

- 生成物はルート直下に置かず、`output/` に集約する
- 変換用の補助ファイルは `scripts/` と `assets/` に寄せる
- 原稿そのものは `manuscript/` に閉じ込める
- 調査用の一時ファイル群は締切後に別途整理する

## 次に詰めると良い点

- 著者名、サブタイトル、奥付文言の最終確定
- EPUB/PDF での目次深さと改ページ制御
- bare URL をリンク表記へ寄せて電子書籍変換時の見栄えを安定させる
