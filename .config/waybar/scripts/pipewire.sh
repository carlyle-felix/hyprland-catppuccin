#!/bin/bash

set -e

ARG=$1

# https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read -r ${1:+-t "$1"} -u $_snore_fd || :
}

DELAY=0.2

while snore $DELAY; do
    WP_OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

    if [[ $WP_OUTPUT =~ ^Volume:[[:blank:]]([0-9]+)\.([0-9]{2})([[:blank:]].MUTED.)?$ ]]; then
        if [[ -n ${BASH_REMATCH[3]} ]]; then
            printf "    \n"
        else
            VOLUME=$((10#${BASH_REMATCH[1]}${BASH_REMATCH[2]}))
            ICON=(
                "   "
                "   "
                "   "
            )

            if [[ $VOLUME -gt 50 ]]; then
                printf "${ICON[0]}  \n"
            elif [[ $VOLUME -gt 25 ]]; then
                printf "${ICON[1]}  \n"
            elif [[ $VOLUME -ge 0 ]]; then
                printf "${ICON[2]}  \n"
            fi
        fi
    fi
done

exit 0
