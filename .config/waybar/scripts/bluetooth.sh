#!/bin/bash

main() {

    local state=$(bluetoothctl show | grep "PowerState")
    state="${state#* }"

    if [[ "${state}" == "on" ]]; then
        bluetoothctl power off &> /dev/null
    else 
        bluetoothctl power on &> /dev/null
    fi
    
}

main $@