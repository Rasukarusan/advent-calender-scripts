#!/usr/bin/env bash

function create_new_tab() {
osascript << EOF
tell application "iTerm"
	tell current window
		create tab with default profile
	end tell
end tell
EOF
}

function send_command() {
osascript -- - "$1" << EOF
on run argv
set _command to item 1 of argv
tell application "iTerm"
	tell current window
		tell current session
			write text _command
		end tell
	end tell
end tell
end run
EOF
}

function split_vertically() {
osascript << EOF
tell application "iTerm"
	tell current window
		tell current session
			select (split vertically with default profile)
		end tell
	end tell
end tell
EOF
}

function split_horizontally() {
osascript << EOF
tell application "iTerm"
	tell current window
		tell current session
			select (split horizontally with default profile)
		end tell
	end tell
end tell
EOF
}

function broadcast_input() {
osascript << EOF
tell application "iTerm"
	activate
	tell application "System Events"
		tell application process "iTerm2"
			tell menu "Shell" of menu bar item "Shell" of menu bar 1
				tell menu "Broadcast Input" of menu item "Broadcast Input"
					click menu item "Broadcast Input to All Panes in Current Tab"
				end tell
			end tell
		end tell
	end tell
end tell
EOF
}

function set_badge() {
    printf "\e]1337;SetBadgeFormat=%s\a" $(/bin/echo -n "$1" | base64)
}

function select_session_by_id() {
osascript -- - "$1" << EOF
on run argv
set _session_id to item 1 of argv
tell application "iTerm"
	tell session id _session_id of current tab of current window
		select
	end tell
end tell
end run
EOF
}

function get_current_session_id() {
osascript << EOF
tell application "iTerm"
	tell current session of current tab of current window
		id
	end tell
end tell
EOF
}

function get_current_columns() {
osascript << EOF
tell application "iTerm"
	tell current session of current tab of current window
		columns
	end tell
end tell
EOF
}

function multi_ssh_split() {
    create_new_tab
    local max_panel_count=3
    local width=$(get_current_columns)
    local min_width=$(expr ${width} / ${max_panel_count})

    local target_servers=($@)
    local servers_count=$#
    local row=$(expr $servers_count / $max_panel_count)
    local session_ids=(`get_current_session_id`)

    # [ $row -eq 1 ] && row=0

    # split horizontally and store a session id
    # for i in `seq 1 ${row}`; do
    while [ $row -gt 0 ];do
        split_horizontally
        row=$(expr $row - 1)
        session_ids=(${session_ids[@]} `get_current_session_id`)
    done

    # select first pane
    select_session_by_id ${session_ids[$row]}
    send_command "set_badge ${target_servers[0]}"
    send_command "ssh ${target_servers[0]}"

    # split vertically
    for i in `seq 1 $(expr ${servers_count} - 1)`; do
        if [ `get_current_columns` -lt $min_width ];then
            row=$(expr $row + 1)
            select_session_by_id ${session_ids[$row]}
        else
            split_vertically
        fi
        send_command "set_badge ${target_servers[$i]}"
        send_command "ssh ${target_servers[$i]}"
    done
    broadcast_input
}

main() {
    local target_servers=$(cat ~/.ssh/config | grep 'Host ' | sed 's/Host //g' | fzf)
    [ -z "$target_servers" ] && return 130
    multi_ssh_split ${target_servers[@]}
}
main >/dev/null
