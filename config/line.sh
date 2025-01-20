#!/usr/bin/env bash
### /bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

# colors

black=#1D2021
blue=#458588
cyan=#689D6A
green=#98971A
magenta=#B16286
red=#cc241d
white=#EBDBB2
yellow=#D79921

ligthBlue=#83a598
ligthCyan=#8ec07c
ligthMagenta=#d3869b
ligthRed=#fb4934
ligthYellow=#fabd2f

# Change this depending on your battery in /sys/class/power_supply/
battery="BAT1"
battery2="BAT0"
# wifi="yes"

format=2

has_battery() {
	if [ -d /sys/class/power_supply/$battery ]; then
		return 0
	fi
	return 1
}

has_second_battery() {
	if [ -d /sys/class/power_supply/$battery2 ]; then
		return 0
	fi

	return 1
}

has_wifi() {
	if [ "$wifi" ]; then
		return 0
	fi
	return 1
}

get_charging_status() {
	# ⭠ ⭡ ⭢ ⭣ ⭤ ⭥ ⭦ ⭧ ⭨ ⭩
	battery=$1;
	status="$(cat /sys/class/power_supply/$battery/status)"
	if [ "$status" = "Discharging" ]; then
		echo "⇃"
	elif [ "$status" = "Charging" ]; then
		echo "↿"
	else
		echo "↻"
	fi
}

get_charge() {
	battery=$1
	cat "/sys/class/power_supply/$battery/capacity"
}

get_wifi_status() {
	# 直睊 
	status="$(nmcli -o g | sed -n '2p' | cut -d ' ' -f 1)"
	name="$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2 | cut -d ':' -f 2)"

	if [ "$status" = "connected" ];then
	   echo " $name"
	else
		echo "睊"
	fi
}

get_wlan() {
	if [ "$format" = "1" ]; then
		printf "^c$black^ ^b$green^ 直"
	    printf "^c$black^ ^b$ligthGreen^ $(ip a | grep wl | grep inet | awk '{print $2}' | cut -d '/' -f 1)"
	else
		printf "^c$green^ ^b$black^[ $(ip a | grep wl | grep inet | awk '{print $2}' | cut -d '/' -f 1) WLAN ]"
	fi

	# case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	# up) printf "^c$black^ ^b$cyan^  ^d^%s" "^c$black^^b$ligthCyan^ Connected" ;;
	# down) printf "^c$black^ ^b$cyan^ 󰤭 ^d^%s", "^c$black^^b$ligthCyan^ Disconnected" ;;
	# esac
}

get_mem() {
	# echo " $(free -h | grep Mem: | cut -d ' ' -f 20)"

	if [  "$format" = "1" ]; then
		printf "^c$black^ ^b$magenta^ "
    	printf "^c$black^ ^b$ligthMagenta^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
	else
		printf "^c$magenta^ ^b$black^[ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g) RAM ]"
	fi
}

get_temp() {
	if [ "$format" = "1" ]; then
		printf "^c$black^ ^b$yellow^ "
	    printf "^c$black^ ^b$ligthYellow^ $(sensors | grep Composite | cut -d ' ' -f 5 | tr -d '+,C')"
	else
		printf "^c$yellow^ ^b$black^[ $(sensors | grep Composite | cut -d ' ' -f 5 | tr -d '+,C') CPU $(sensors | grep edge | cut -d ' ' -f 10 | tr -d '+,C') GPU ]"
	fi
	# echo " $(sensors | grep Composite: | cut -d ' ' -f 5 | tr -d '+,C')"
}

get_sys_cpu() {
	top -bn1 | awk '/Cpu/ { print $4}'
}

get_user_cpu() {
	top -bn1 | awk '/Cpu/ { print $2}'
}

get_user_sys_cpu() {
	echo " $(get_user_cpu)%U $(get_sys_cpu)%S"
}

get_total_cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	if [ "$format" = "1" ]; then
		printf "^c$black^ ^b$red^ "
	    printf "^c$black^ ^b$ligthRed^ $cpu_val"
	else
		printf "^c$red^ ^b$black^[ $cpu_val CPU ]"
	fi
}

get_datetime() {
	# echo " $(date +'[ %H:%M ] %d/%m')"
	hour=$(date +"%H:%M")
	day=$(date +"%d/%m")

	if [ "$format" = "1" ]; then
		printf "^c$black^ ^b$blue^ "
		printf "^c$black^ ^b$ligthBlue^ $hour"
	    printf "^c$black^ ^b$ligthBlue^ $day"
	else
		printf "^c$blue^ ^b$black^[ $day $hour ]"
	fi
}

get_status() {
	battery_status=""
	wifi_status=""

	if $(has_second_battery); then
		battery_status="$(get_charging_status $battery)$(get_charge $battery)% $(get_charging_status $battery2)$(get_charge $battery2)% "
	elif $(has_battery); then
		battery_status="$(get_charging_status $battery) $(get_charge $battery)% "
	fi

	if $(has_wifi); then
		wifi_status="$(get_wifi_status) "
	else
		wifi_status="$(get_wlan)"
	fi

	echo " ${battery_status} $(get_temp) $(get_total_cpu) $(get_mem) ${wifi_status} $(get_datetime) "
	# printf "$(get_user_cpu)"
}

while true
do
	xsetroot -name "$(get_status)"
	sleep 2s;
done
