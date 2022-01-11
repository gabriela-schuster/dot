# dotfiles

![photo of a dark desktop](https://github.com/gabriela-tomazzi/dot/blob/main/warm_desktop.png)

## dependencies:

* bspwm
* sxhkd
* alacritty
* starship
* polybar
* conky
* rofi
* picom
* nvim
* dunst
* cozette-ttf
* zsh

### Arch:
```
yay -S bspwm sxhkd alacritty starsip polybar conky rofi picom cozette-ttf zsh
```
***
## install: 
make start.sh executable with
```
chmod +x start.sh
```
and run with
```
./start.sh
```
***

#### IMPORTANT: this is a set of both xorg (bspwm + sxhkd + polybar) and wayland (sway + waybar) desktops, you can remove the folders of the wm you don't want, or any other folder in config if you don't want that application
