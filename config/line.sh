#!/usr/bin/env bash

# Change this depending on your battery in /sys/class/power_supply/
battery="BAT1"
battery2="BAT0"
wifi="yes"

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

get_mem() {
	# echo " $(free -h | grep Mem: | cut -d ' ' -f 20)"
	echo " $(free -h | awk '/^Mem:/ {print $3}')"
}

get_temp() {
	echo " $(sensors | grep CPU: | cut -d ' ' -f 11 | tr -d '+,C')"
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

get_datetime() {
	echo " $(date +'[ %H:%M ] %d/%m')"
}

get_status() {
	battery_status=""
	wifi_status=""

	if $(has_second_battery); then
		battery_status="$(get_charging_status $battery)$(get_charge $battery)% $(get_charging_status $battery2)$(get_charge $battery2)% |"
	elif $(has_battery); then
		battery_status="$(get_charging_status $battery) $(get_charge $battery)% |"
	fi

	if $(has_wifi); then
		wifi_status="$(get_wifi_status) |"
	fi

	echo " ${battery_status} $(get_temp) | $(get_user_sys_cpu) | $(get_mem) | ${wifi_status} $(get_datetime) "
}

while true
do
	xsetroot -name "$(get_status)"
	sleep 2s;
done
