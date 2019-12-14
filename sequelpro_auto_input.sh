#!/usr/bin/env bash

function connect() {
local name=$1
local host=$2
local username=$3
local password=$4
local database=$5
local port=$6

osascript << EOF
tell application "Sequel Pro"
    activate
    delay 0.5
    tell application "System Events"
        tell process "Sequel Pro"

            # 新規タブ作成
            set frontmost to true
            keystroke "t" using {command down}

            tell window "Sequel Pro"
                # 「クイック接続」をクリック
                tell outline 1 of scroll area 1 of splitter group 1 of group 2
                    select row 1
                end tell

                # DB情報を入力
                tell tab group 1 of scroll area 2 of splitter group 1 of group 2
                    # 名前
                    set focused of text field 5 to true
                    keystroke "${name}"
                    key code 100

                    # MySQLホスト
                    delay 0.3
                    set focused of text field 6 to true
                    keystroke "${host}"
                    key code 100

                    # ユーザ名
                    delay 0.3
                    set focused of text field 4 to true
                    keystroke "${username}"
                    key code 100

                    # パスワード
                    delay 0.3
                    set focused of text field 3 to true
                    keystroke "${password}"
                    key code 100

                    # データベース
                    delay 0.3
                    set focused of text field 2 to true
                    keystroke "${database}"
                    key code 100

                    # ポート
                    delay 0.3
                    set focused of text field 1 to true
                    keystroke "${port}"
                    key code 100
                end tell

                # 接続
                tell scroll area 2 of splitter group 1 of group 2
                     click button 2
                end tell
            end tell
        end tell
    end tell
end tell
EOF
}

function main() {
    # DB情報はコマンドで取得して渡す想定
    local name='docker1'
    local host='127.0.0.1'
    local username='docker'
    local password='docker'
    local database='testdb'
    local port='13306'
    connect $name $host $username $password $database $port >/dev/null
}
main
