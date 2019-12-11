#!/usr/bin/env bash

function export_chrome_history() {
    # Chromeを開いているとdbがロック状態で参照できないので、コピーしたものを参照する
    cp ~/Library/Application\ Support/Google/Chrome/Default/History ~/
    local SQL="
    SELECT
        url,
        title,
        DATETIME(last_visit_time / 1000000 + (strftime('%s', '1601-01-01') ), 'unixepoch', '+9 hours') AS date
    FROM
        urls
    GROUP BY
        title
    ORDER BY
        date DESC
    LIMIT
        10000 ;
    "
    sqlite3 ~/History -cmd '.mode tabs' "$SQL"
}

function show_chrome_history() {
    local filter=${1:-""}
    local chrome_history=$(export_chrome_history)
    local selected=$(
        echo "\texport\n$chrome_history" \
        | grep -P "(\texport|$filter)" \
        | awk '!title[$2]++' \
        | fzf --delimiter $'\t' --with-nth 2,3 --preview 'w3m -dump {1}'\
        | tr -d '\n'
    )
    [ -z "$selected" ] && return
    # 'export'を選択した場合、全て出力する
    if [ "$(/bin/echo -n "$selected" | tr -d ' ')" = 'export' ]; then 
        echo "$chrome_history" | awk -F '\t' '{print $3"\t"$2}'
        return
    fi
    open $(echo $selected | awk '{print $1}')
}

function show_by_date() {
    local chrome_history=$(export_chrome_history)
    # 表示したい日付を選択する
    local select_date=$(
        echo "$chrome_history" \
        | awk -F '\t' '{print $3}' \
        | awk -F ' ' '{print $1}' \
        | grep -P '^[0-9]{4}-.*' \
        | sort -ur \
        | xargs -I {} gdate '+%Y-%m-%d (%a)' -d {} \
        | fzf
    )
    [ -z "$select_date" ] && return
    show_chrome_history $select_date
}

function main() {
    if [ "$1" = '-d' ]; then 
        show_by_date
    else
        show_chrome_history $1
    fi
}

main $1
