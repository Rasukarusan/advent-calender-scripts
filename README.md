Advent Calender Scripts
====
Qiitaアドベントカレンダー2019, [今年イチ！お勧めしたいテクニック by ゆめみ feat.やめ太郎 Advent Calendar 2019](https://qiita.com/advent-calendar/2019/yumemi_no1)の記事投稿用リポジトリ

## 記事

[業務で使うツール(iTerm2,SequelPro,Chrome)をShellScriptでハイパーテクニックする]()

## Requirement

- OS X
- fzf

## Chrome

### ・ブラウザに移動せずTerminalで自在にタブ移動する

```sh
$ bash chrome_tab_activate.sh
```

### ・Chromeの履歴を一覧表示して開く

```sh
$ sh chrome_history.sh
```

#### ・Requirement

- w3m
- gdate(GNU date)

## iTerm2

### ・画面分割、新タブ作成、ブロードキャスト入力もコマンドで実行する

```sh
$ sh iterm_multi_ssh.sh 
```

### ・気軽に背景色を変える

```sh
$ ./iterm_background_color.sh
```

### ・透明度も自在に変更する

```sh
$ ./iterm_transparency.sh
```

## Sequel Pro

### ・「お気に入り」から複数選択して自動で接続する

```sh
$ sh sequelpro_auto_select.sh
```

### ・ワンタイムパスがあるDBでも自動入力で接続する

```sh
$ sh sequelpro_auto_input.sh
```
