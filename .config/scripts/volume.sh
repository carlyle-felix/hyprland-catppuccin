#!/usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

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
				notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "    Muted"
			else
				inc_volume "$2"
			fi
			;;
		"--dec")
			get_mute_state "1"
			if [ $? -eq 1 ]; then	
				notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "    Muted"
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
		"--mic-inc")
			inc_mic_volume
			;;
		"--mic-dec")
			dec_mic_volume
			;;
		*)
			get_volume
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

# Increase Volume
inc_volume() {
	wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ ${1}%+ && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-up.png" "    Volume: $(get_volume)%"
}

# Decrease Volume
dec_volume() {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ ${1}%- && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-down.png" "    Volume: $(get_volume)%"
}

# Toggle Mute
toggle_mute() {
	get_mute_state "1"
	if [ $? -eq 0 ]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "    Mute"
	else
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-unmute.png" "    Unmute"
	fi
}

# Toggle Mic
toggle_mic() {
	get_mute_state "0"
	if [ $? -eq 0 ]; then
		wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone-mute.png" "    Microphone: OFF"
	else
		wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone.png" "    Microphone: ON"
	fi
}

main $@