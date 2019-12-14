#!/usr/bin/env bash

#
# SequelProで指定した接続を開く
# 引数にはSequelProの「お気に入り」の行番号を示すインデックスが入る
#
function connect() {
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
                keystroke "t" using {command down}
                tell window "Sequel Pro"
                    delay 0.5
                    tell outline 1 of scroll area 1 of splitter group 1 of group 2
                        # because row1 is "QUICK CONNECT" and row2 is "FAVORITES", the top of favorites is row3.
                        set _row_index to (item i of argv as number) + 2
                        select row _row_index
                    end tell
                    tell scroll area 2 of splitter group 1 of group 2
                        click button 2
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
    connect ${rows[@]} >/dev/null
}

main
