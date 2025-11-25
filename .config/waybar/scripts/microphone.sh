#!/bin/bash

# https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read -r ${1:+-t "$1"} -u $_snore_fd || :
}

source $HOME/.config/scripts/volume.sh

DELAY=0.2

while snore $DELAY; do
    get_mute_state "0" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "{\"tooltip\": \"Mic access enabled\", \"alt\": \"unmute\", \"class\": \"unmute\"}"
    else 
        echo "{\"tooltip\": \"Mic access disabled\", \"alt\": \"mute\", \"class\": \"mute\"}"
    fi
done

exit 0