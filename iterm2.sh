#!/usr/bin/env bash

function get_current_background_color() {
osascript << EOF
tell application "iTerm"
    activate
    tell current session of current window
        return background color
    end tell
end tell
EOF
}

function change_background_color() {
local r=$(echo "scale=2; ($1/255) * 65535" | bc)
local g=$(echo "scale=2; ($2/255) * 65535" | bc)
local b=$(echo "scale=2; ($3/255) * 65535" | bc)
osascript -- - $r $g $b << EOF
on run argv
    tell application "iTerm"
        activate
        tell current session of current window
            set red to (item 1 of argv)
            set green to (item 2 of argv)
            set blue to (item 3 of argv)
            set background color to {red, green, blue, 1}
        end tell
    end tell
end run
EOF
}

function main() {
    local current_color
    IFS=',' read -a current_color < <(get_current_background_color)
    local current_color_rgb=(
        $(echo "scale=2;(${current_color[0]}/65535)*255" | bc)
        $(echo "scale=2;(${current_color[1]}/65535)*255" | bc)
        $(echo "scale=2;(${current_color[2]}/65535)*255" | bc)
    )

    local colors=(
        # "color_name R G B"
        "black     0    0   0",
        "red     201   27   0",
        "green     0  194   0",
        "yellow  199  196   0",
        "blue      2   37 199",
        "magenda 201   48 199",
        "white     0  197 199",
    )
    local color
    read -r -a color < <(
        echo ${colors[@]} | tr ',' '\n' | sed 's/^ //g' \
           | fzf --delimiter=" " --with-nth 1 --bind 'ctrl-p:execute-silent(./iterm2.sh {2} {3} {4})'
    )

    if [ -z "$color" ];then
        ./iterm2.sh ${current_color_rgb[@]}
    else
        ./iterm2.sh ${color[@]:1:3}
    fi
}

if [ $# -eq 0 ];then
    main
else
    change_background_color $@
fi
