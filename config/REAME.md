# Requerimentos

sudo pacman -S hyprland hyprpaper waybar wl-clipboard dunst wofi wl-copy

sudo pacman -S thunar udisks2 gvfs gvfs-backends gvfs-smb thunar-archive-plugin thunar-volman tumbler xarchiver

- thunar-volman -> automount e ações para dispositivos
- thunar-archive-plugin e xarchiver -> extrair zip/rar no clique direito
- tumbler -> thumbnails

sudo pacman -S ttf-jetbrains-mono-nerd eza bat gzip unzip unrar 7zip wl-clip-persist

sudo pacman -S xdg-desktop-portal-hyprland

systemctl --user restart xdg-desktop-portal
systemctl --user restart xdg-desktop-portal-hyprland
