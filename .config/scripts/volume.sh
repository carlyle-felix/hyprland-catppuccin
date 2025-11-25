#!/usr/bin/env bash

# Set delay 
LOCK_FILE="/tmp/hyrpland_volume.lock"
DELAY=30

# Check last run
if [ -f "$LOCK_FILE" ]; then
    PREV=$(cat $LOCK_FILE)
    TIME=$(date +%s%3N)
    DIFF=$((TIME - PREV))

    if [ $DIFF -lt $DELAY ]; then
        exit 1
    fi
fi

# Update time
echo "$TIME" > "$LOCK_FILE"

main() {

	arg=$1

	# Execute accordingly
	case ${arg} in
		"--get")
			get_volume
			;;
		"--inc")
			get_mute_state "1"
			if [ $? -eq 1 ]; then	
				notify-send -h string:x-canonical-private-synchronous:sys-notify -u low " Muted"
			else
				inc_volume "$2"
			fi
			;;
		"--dec")
			get_mute_state "1"
			if [ $? -eq 1 ]; then	
				notify-send -h string:x-canonical-private-synchronous:sys-notify -u low " Muted"
			else
				dec_volume "$2"
			fi
			;;
		"--toggle")
			toggle_mute
			;;
		"--toggle-mic")
			toggle_mic
			;;
	esac
}

# Get Volume
get_volume() {
	volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
	volume="${volume#* }"
	volume=$(echo "$volume * 100" | bc)
	volume="${volume%%.*}"
	echo "${volume}"
}

get_mute_state() {
	arg="$1"

	if [ $arg -eq 0 ]; then
		dev="@DEFAULT_AUDIO_SOURCE@"
	elif [ $arg -eq 1 ]; then
		dev="@DEFAULT_AUDIO_SINK@"
	fi

	wpctl get-volume ${dev} | grep "MUTED"
	if [ $? -eq 1 ]; then
		return 0
	else
		return 1
	fi
}

# Get icons
get_icon() {
	current="$(get_volume)"
	if [ "$current" -lt "33" ]; then
		icon=""
	elif [ "$current" -lt "66" ]; then
		icon=""
	elif [ "$current" -le "100" ]; then
		icon=""
	fi
}

# Increase Volume
inc_volume() {
	get_icon
	wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ ${1}%+ && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "$icon Volume: $(get_volume)%" -h int:value:$(get_volume)
}

# Decrease Volume
dec_volume() {
	get_icon
	wpctl set-volume @DEFAULT_AUDIO_SINK@ ${1}%- && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "$icon Volume: $(get_volume)%" -h int:value:$(get_volume)
}

# Toggle Mute
toggle_mute() {
	get_mute_state "1"
	if [ $? -eq 0 ]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low " Mute"
	else
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low " Unmute"
	fi
}

# Toggle Mic
toggle_mic() {
	get_mute_state "0"
	if [ $? -eq 0 ]; then
		wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u critical "󰍭 Mute"
	else
		wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u critical "󰍬 Unmute"
	fi
}

main $@