#!/bin/bash

options="Desligar\nReiniciar\nSair\nCancelar"

choice=$(echo -e "$options" | wofi --dmenu --prompt "Power" --width 400 --height 250)

case "$choice" in
  Desligar)
    systemctl poweroff
    ;;
  Reiniciar)
    systemctl reboot
    ;;
  Sair)
    hyprctl dispatch exit
    ;;
  *)
    exit 0
    ;;
esac