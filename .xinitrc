## Keyboard language
setxkbmap latam &

## Hack for fix java graphical app
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -XX:+IgnoreUnrecognizedVMOptions' &

## Init screensaver
/usr/bin/xscreensaver -no-splash &

## Load Xresources configs
xrdb ~/.Xresources &

## Load dbus language keyboard switcher
# ibus-daemon -x -d &
xbindkeys &

## Disable beep and black screen for inativity
xset -b &
xset s off &

## Enable keyring
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh) &
export SSH_AUTH_SOCK &

## Load window composite manager
# picom --daemon &
xcompmgr &

## Enable display for blueman/gtk python apps
export DISPLAY=:0.0 &
dbus-update-activation-environment DISPLAY &

## Load tray system apps
nm-applet &
pasystray &
caffeine &
blueman-applet &
safeeyes &

## Init apps and daemons
# urxvtd &
mpd -v &
exec awesome
