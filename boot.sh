#!/usr/bin/env bash
#
# Enlaza los dotfiles de este repo en $HOME.
#
#   ./boot.sh            crea los symlinks
#   ./boot.sh --dry-run  solo muestra lo que haría
#
# Es idempotente: los enlaces que ya están bien se dejan igual. Si en el destino
# hay un archivo o carpeta real, se mueve a ~/.dotfiles-backup/<fecha>/ antes de
# enlazar, así nunca se pierde nada.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ─── Qué se enlaza ───────────────────────────────────────
# Rutas relativas: <ruta en el repo> se enlaza en $HOME/<misma ruta>

CONFIGS=(
  # Escritorio Hyprland
  .config/hypr
  .config/quickshell
  .config/wlogout
  .config/mako
  .config/rofi
  .config/waybar

  # Terminal, shell y editor
  .config/kitty
  .config/zsh-antidote
  .config/nvim
  .config/fastfetch
  .config/htop
  .zshenv
  .tmux.conf

  # Temas GTK
  .config/gtk-2.0
  .config/gtk-3.0
  .config/gtk-4.0

  # Varios
  .Xresources
  .cheatsheet
  .local/share/rofi

  # Fondo de pantalla aleatorio cada 10 min
  .config/systemd/user/wallpaper.service
  .config/systemd/user/wallpaper.timer
)

# Scripts propios de .local/bin (el resto de esa carpeta son binarios generados por pip)
SCRIPTS=(
  set-random-wallpaper.sh
  weather
  rofi-customized
  color-arch
  color-hex
  color-pacman
  color-pipes2
  colortest
  colortest-slim
  colorview
  nerdfetch
)

# Enlaces que no siguen la regla "misma ruta": "<destino en $HOME>:<origen en el repo>"
EXTRA_LINKS=(
  ".zshrc:.config/zsh-antidote/.zshrc"
)

# Sin enlazar a propósito (configs de la época awesome/X11, ya no se usan):
#   .config/awesome .config/alacritty .config/mpd .xinitrc .screenrc .irssi .ncmpcpp
# .npmrc tampoco: suele tener tokens y conviene crearlo a mano en cada equipo.

# ─── Funciones ───────────────────────────────────────────

c_ok=$'\e[32m' c_new=$'\e[34m' c_warn=$'\e[33m' c_err=$'\e[31m' c_off=$'\e[0m'

run() {
  if $DRY_RUN; then echo "    [dry-run] $*"; else "$@"; fi
}

# link <origen absoluto> <destino absoluto>
link() {
  local src="$1" dst="$2"

  if [[ ! -e "$src" ]]; then
    echo "${c_err}✗ no existe en el repo:${c_off} ${src#"$DOTFILES"/}"
    return
  fi

  if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
    echo "${c_ok}✓${c_off} ${dst/#$HOME/\~}"
    return
  fi

  run mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" || -L "$dst" ]]; then
    local backup="$BACKUP_DIR/${dst#"$HOME"/}"
    echo "${c_warn}↻${c_off} ${dst/#$HOME/\~}  (respaldo en ${backup/#$HOME/\~})"
    run mkdir -p "$(dirname "$backup")"
    run mv "$dst" "$backup"
  else
    echo "${c_new}+${c_off} ${dst/#$HOME/\~}"
  fi

  run ln -s "$src" "$dst"
}

# ─── Enlazar ─────────────────────────────────────────────

$DRY_RUN && echo "Modo dry-run: no se cambia nada."
echo "Repo: $DOTFILES"
echo

for path in "${CONFIGS[@]}"; do
  link "$DOTFILES/$path" "$HOME/$path"
done

for script in "${SCRIPTS[@]}"; do
  link "$DOTFILES/.local/bin/$script" "$HOME/.local/bin/$script"
done

for pair in "${EXTRA_LINKS[@]}"; do
  link "$DOTFILES/${pair#*:}" "$HOME/${pair%%:*}"
done

# Carpeta de fondos que usa set-random-wallpaper.sh. Solo se crea si no existe,
# para no tocar una colección local más grande que la del repo.
WALLPAPERS="$HOME/Imágenes/wallpapers"
if [[ ! -e "$WALLPAPERS" ]]; then
  link "$DOTFILES/Imágenes/fondos" "$WALLPAPERS"
else
  echo "${c_ok}✓${c_off} ${WALLPAPERS/#$HOME/\~} (ya existe, no se toca)"
fi

# ─── Servicios ───────────────────────────────────────────

echo
if systemctl --user show-environment >/dev/null 2>&1; then
  echo "Activando wallpaper.timer"
  run systemctl --user daemon-reload
  run systemctl --user enable --now wallpaper.timer
else
  echo "${c_warn}!${c_off} systemd --user no está disponible; al iniciar sesión ejecuta:"
  echo "    systemctl --user daemon-reload && systemctl --user enable --now wallpaper.timer"
fi

echo
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Listo. Lo que había antes quedó en ${BACKUP_DIR/#$HOME/\~}"
else
  echo "Listo."
fi
