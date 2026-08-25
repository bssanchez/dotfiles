#!/bin/bash

TOP=$(ps -eo pid,comm,rss --sort=-rss | head -n 6)

MAIN=$(echo "$TOP" | awk 'NR==2 {printf "%s (%.0fMB)", $2, $3/1024}')

TOOLTIP=$(echo "$TOP" | awk 'NR>1 {printf "PID: %s | %s | %.1f MB\\n", $1, $2, $3/1024}')

# Escapar correctamente saltos de línea
TOOLTIP_ESCAPED=$(printf "%s" "$TOOLTIP" | sed ':a;N;$!ba;s/\n/\\n/g')

printf '{"text":"%s","tooltip":"%s"}' "$MAIN" "$TOOLTIP_ESCAPED"
