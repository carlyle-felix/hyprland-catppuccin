#!/bin/bash

main() {

	arg=$1
	# Execute accordingly
	case ${arg} in
		"--get")
			get_backlight
			;;
		"--inc")
			inc_backlight "$2"
			;;
		"--dec")
			dec_backlight "$2"
			;;
		*)
			get_backlight
			;;
	esac
}

# Get brightness
get_backlight() {
	max=$(brightnessctl m)
	cur=$(brightnessctl g)
	LIGHT=$(echo "scale=3; ($cur / $max) * 100" | bc)
	LIGHT=$(echo "scale=0; ($LIGHT + 0.1)/1" | bc)
	echo "${LIGHT}"
}

# Get icons
get_icon() {
	current="$(get_backlight)"
	if [ "$current" -lt "33" ]; then
		icon="󰃞"
	elif [ "$current" -lt "66" ]; then
		icon="󰃟"
	elif [ "$current" -le "100" ]; then
		icon="󰃠"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "$icon Brightness: $(get_backlight)%" -h int:value:$(get_backlight)
}

# Increase brightness
inc_backlight() {
	brightnessctl s +${1}% && get_icon && notify_user
}

# Decrease brightness
dec_backlight() {
	brightnessctl s ${1}%- && get_icon && notify_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_backlight
elif [[ "$1" == "--inc" ]]; then
	inc_backlight
elif [[ "$1" == "--dec" ]]; then
	dec_backlight
else
	get_backlight
fi

main $@