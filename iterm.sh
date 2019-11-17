#!/usr/bin/env bash

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
			select (split vertically with same profile)
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
