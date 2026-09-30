#!/bin/bash

# Carpeta con tus fondos
WALLPAPER_DIR="$HOME/Imágenes/wallpapers"

# Elegir un archivo al azar
FILE=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

# Aplicar con swww
[ -n "$FILE" ] && awww img -t random "$FILE"

