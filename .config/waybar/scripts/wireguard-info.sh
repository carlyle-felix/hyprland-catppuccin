#!/bin/bash

# https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read -r ${1:+-t "$1"} -u $_snore_fd || :
}
DELAY=0.2

source $HOME/.config/scripts/wireguard.sh
STATS="/sys/class/net/$TUNNEL/statistics"

while snore $DELAY; do
    # State
    res=$(main "query")

    if [ $res -eq 0 ]; then
        state="activated"

        # Get local IP
        local_ip=$(ip addr show wg0 | grep -oP "inet \K.*")
        local_ip=${local_ip%% *}

        # Get Up/Down totals in MB
        if [ -f ${STATS}/tx_bytes ]; then
            tx_bytes=$(cat ${STATS}/tx_bytes)
            tx=$(echo "scale=2; $tx_bytes / 1024 / 1024" | bc -l)
        else 
            tx=0
        fi

        if [ -f ${STATS}/rx_bytes ]; then
            rx_bytes=$(cat ${STATS}/rx_bytes)
            rx=$(echo "scale=2; $rx_bytes / 1024 / 1024" | bc -l)
        else
            rx=0
        fi

        # Print json
        echo "{\"class\": \"$state\", \"alt\": \"$state\", \"ip_addr\": \"$local_ip\", \
        \"tooltip\": \" VPN:\t\tActivated \n Tunnel IP:\t$local_ip \n\n Upload:\t\t${tx}MB \n Download:\t${rx}MB \", \"upload\": \
        \"$tx\", \"download\": \"$rx\"}"

    elif [ $res -eq 1 ]; then
        state="deactivated"

        # Print json
        echo "{\"class\": \"$state\", \"alt\": \"$state\", \"ip_addr\": \"NA\", \"upload\": \"0\", \
        \"tooltip\": \" VPN: Deactivated \", \"download\": \"0\"}" 
    
    elif [ $res -eq 2 ]; then
        state="none"

        echo "{\"class\": \"$state\", \"alt\": \"$state\", \"ip_addr\": \"NA\", \"upload\": \"0\", \
        \"tooltip\": \" VPN: No Tunnel \n  Set TUNNEL in .config/scripts/wireguard.sh \", \"download\": \"0\"}" 
    fi

done

exit 0