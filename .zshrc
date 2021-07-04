# = = = = = = = = = = = = =
# INITIAL CONFIGS
# = = = = = = = = = = = = =
export ZSH=$HOME/.oh-my-zsh
export LC_ALL="es_CO.UTF-8"
export LANG="es_CO.UTF-8"
export ZSH_DISABLE_COMPFIX=true
export TERM="xterm-256color"
## See https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"

## Theme and plugins from .oh-my-zsh
ZSH_THEME="afowler"
plugins=(git docker archlinux npm git-flow zsh-autosuggestions zsh-syntax-highlighting tmux screen)

# = = = = = = = = = = = = =
# DEV CONFIGS
# = = = = = = = = = = = = =
## Ruby
#GEM_HOME=$(ls -t -U | ruby -e 'puts Gem.user_dir')
#GEM_PATH=$GEM_HOME

## Node & NPM
NPM_CONFIG_PREFIX=/opt/node_modules

## GO
export GOPATH="/home/desarrollo/.go"

## Java & Android
export ANDROID_HOME="/opt/android-sdk"
export ANDROID_SDK_ROOT=$ANDROID_HOME
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -XX:+IgnoreUnrecognizedVMOptions'

## General & system
export BROWSER="firefox-developer-edition"
# export CHROME_BIN="/usr/bin/google-chrome-unstable"
# export CHROME_EXECUTABLE=google-chrome-unstable
export EDITOR="vim"
export PATH=/usr/local/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:/opt/lampp/bin:/opt/node_modules/bin:/home/desarrollo/.local/bin:/opt/flutter/bin:$PATH

source $ZSH/oh-my-zsh.sh

# = = = = = = = = = = = = =
# ALIASES
# = = = = = = = = = = = = =
alias cheatsheet='notify-send -t 15000 "CheatSheet" "$(cat ~/.cheatsheet)" >/dev/null 2>&1'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias emu="cd $ANDROID_HOME/tools && ./emulator"
alias docker_clean_images='docker rmi $(docker images -a --filter=dangling=true -q)'
alias docker_clean_ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'
alias paste='curl -F "sprungie=<-" http://sprunge.us'

# = = = = = = = = = = = = = = = 
# LOAD NO VERSIONABLE CONFIGS
# = = = = = = = = = = = = = = =
[[ ! -f ~/.securerc ]] || source ~/.securerc
