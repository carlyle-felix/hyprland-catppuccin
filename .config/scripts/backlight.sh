#!/usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

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
	if [[ ("$current" -ge "0") && ("$current" -le "19200") ]]; then
		icon="$iDIR/brightness-20.png"
	elif [[ ("$current" -ge "19200") && ("$current" -le "38400") ]]; then
		icon="$iDIR/brightness-40.png"
	elif [[ ("$current" -ge "38400") && ("$current" -le "57600") ]]; then
		icon="$iDIR/brightness-60.png"
	elif [[ ("$current" -ge "57600") && ("$current" -le "76800") ]]; then
		icon="$iDIR/brightness-80.png"
	elif [[ ("$current" -ge "76800") && ("$current" -le "96000") ]]; then
		icon="$iDIR/brightness-100.png"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$icon" "    Brightness: $(get_backlight)%"
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