#!/bin/sh

#
# SequelProで指定した接続を開く
# 引数にはSequelProの「お気に入り」の行番号を示すインデックスが入る
#
function run_sequel_pro() {
osascript -- - "$@" << EOF
on run argv
tell application "Sequel Pro"
    activate
    delay 0.5
    tell application "System Events"
        tell process "Sequel Pro"
            set frontmost to true
            delay 0.5
            repeat with i from 1 to (count argv)
                click menu item "新規接続タブ" of menu "ファイル" of menu bar item "ファイル" of menu bar 1 of application process "Sequel Pro" of application "System Events"
                tell window "Sequel Pro"
                    delay 0.5
                    tell outline 1 of scroll area 1 of splitter group 1 of group 2 of window "Sequel Pro" of application process "Sequel Pro" of application "System Events"
                        # row 1は「クイック接続」、row 2は「お気に入り」の行なので実質一番上はrow 3となる
                        set _row_index to (item i of argv as number) + 2
                        select row _row_index
                    end tell
                    tell scroll area 2 of splitter group 1 of group 2 of window "Sequel Pro" of application process "Sequel Pro" of application "System Events"
                        click button "接続"
                    end tell
                end tell
            end repeat
        end tell
    end tell
end tell
end run
EOF
}

function main() {
    local favorites=$(plutil -convert json ~/Library/Application\ Support/Sequel\ Pro/Data/Favorites.plist -o - | jq -r '."Favorites Root".Children[].name')
    local targets=($(echo "${favorites}" | fzf))
    local rows=()
    for target in ${targets[@]}; do
        echo $target
        local row=$(echo "${favorites}" | grep -n ${target} | cut -d ':' -f 1)
        rows=(${rows[@]} $row)
    done
    [ ${#rows[@]} -eq 0 ] && return 130
    run_sequel_pro ${rows[@]} >/dev/null
}

main
