#!/bin/bash

# SET TUNNEL
TUNNEL="wg0"

main()
{
    case $1 in
        # query the tunnel state
        query)
            query_state
            echo "$?"
        ;;

        # toggle the state
        toggle)
            toggle_state
        ;;
    esac
}

query_state()
{
    nmcli connection show $TUNNEL &> /dev/null
    if [ $? -ne 0 ]; then   
        return 2    # non existant state
    fi

    ip l | grep "${TUNNEL}" &> /dev/null
    return "$?"
}

toggle_state()
{
    query_state
    state=$?
    if [ $state -eq 0 ]; then
        nmcli connection down ${TUNNEL} && notify-send -h string:x-canonical-private-synchronous:sys-notify -u normal -i "$iDIR/vpn-off.png" "Connection \"${TUNNEL}\": Dectivated"
    elif [ $state -eq 1 ]; then
        nmcli connection up ${TUNNEL} && notify-send -h string:x-canonical-private-synchronous:sys-notify -u normal -i "$iDIR/vpn-on.png" "Connection \"${TUNNEL}\": Activated"
    elif [ $state -eq 2 ]; then
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u critical -i "$iDIR/no-vpn.png" "No VPN Tunnel Found" \
            "If a VPN is running, Set the correct tunnel name in ./config/scripts/wireguard.sh and import it with nmcli."
    fi
}

main $@