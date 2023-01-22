#!/usr/bin/env bash

# Change this depending on your battery in /sys/class/power_supply/
battery="BAT1";
wifi="yes"

has_battery() {
	if [ -d /sys/class/power_supply/$battery ]; then
		return 0;
	fi
	return 1;
}

has_wifi() {
	if [ "$wifi" ]; then
		return 0;
	fi
	return 1;
}

get_charging_status() {
	# ⭠ ⭡ ⭢ ⭣ ⭤ ⭥ ⭦ ⭧ ⭨ ⭩
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
	cat "/sys/class/power_supply/$battery/capacity"
}

get_wifi_status() {
	# 直睊 
	status="$(nmcli -o g | sed -n '2p' | cut -d ' ' -f 1)"

	if [ "$status" = "connected" ];then
	   echo ""
	else
		echo "睊"
	fi
}

get_mem() {
	free -h | grep Mem: | cut -d ' ' -f 19
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
	date +"[ %H:%M ] %d/%m"
}

get_status() {
	battery_status="";
	wifi_status="";

	if $(has_battery); then
		battery_status="$(get_charging_status) $(get_charge) |";
	fi

	if $(has_wifi); then
		wifi_status="$(get_wifi_status) |"
	fi

	echo " ${battery_status} $(get_temp) | $(get_user_sys_cpu) | $(get_mem) | ${wifi_status} $(get_datetime) ";
}

while true
do
	xsetroot -name "$(get_status)";
	sleep 30s;
done
