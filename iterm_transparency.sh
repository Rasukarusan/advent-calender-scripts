#!/usr/bin/env bash

function change_transparency() {
osascript -- - $1 << EOF
on run argv
    tell application "iTerm"
        activate
        tell current session of current window
            set transparency to (item 1 of argv as number)
        end tell
    end tell
end run
EOF
}

function main() {
    local transparency=$(seq -f "%.1f" 0.0 0.1 1 | fzf --header 'transparency' --bind "ctrl-p:execute-silent($0 {})")
    [ -z "$transparency" ] && return
    change_transparency $transparency
}

if [ $# -eq 0 ];then
    main
else
    change_transparency $@
fi
