#!/bin/bash

# SETUP
TUNNEL="wg0"

main()
{
    case $1 in
        query)
            query_state
            if [ $? -eq 0 ]; then
                echo "ON"
            else
                echo "OFF"
            fi
        ;;
        toggle)
            toggle_state
        ;;
    esac
}

query_state()
{
    ip l | grep "${TUNNEL}" &> /dev/null
    return "$?"
}

toggle_state()
{
    query_state
    if [ $? -ne 0 ]; then
        nmcli connection up ${TUNNEL} && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/vpn-on.png" "   Connection \"${TUNNEL}\": Activated"
    else
        nmcli connection down ${TUNNEL} && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/vpn-on.png" "   Connection \"${TUNNEL}\": Dectivated"
    fi
}

main $@